//
//  ViewController.swift
//  searchbook
//
//  Created by 박기찬 on 2018. 3. 4..
//  Copyright © 2018년 박기찬. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var mod: UILabel!
    @IBOutlet weak var goup: UIButton!
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var modnum: Int = 0
    var curPage: Int = 1
    var keyWord: String = ""
    var bookItems: Array<Any> = []
    let threshold: CGFloat = 250.0 // threshold from bottom of tableView
    var isLoadingMore = false // flag
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // self.reqvbooklist("harry")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
         }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookItems.count
    }
    
    @IBAction func searchingmod(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil,message: nil,preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "전체", style: .default, handler: { result in
            self.mod.text = "전체"
            self.modnum = 0
        }))
        actionSheet.addAction(UIAlertAction(title: "제목", style: .default, handler: { result in
            self.mod.text = "제목"
            self.modnum = 1
        }))
        actionSheet.addAction(UIAlertAction(title: "저자", style: .default, handler: { result in
            self.mod.text = "저자"
            self.modnum = 2
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchBookCell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookCell
        
        cell.bookImageView.tag = indexPath.row
        let dict: Dictionary = self.bookItems[indexPath.row] as! Dictionary <String, Any>
        var title: String = dict["title"] as! String
        var author: String = dict["author"] as! String
        let price: String = dict["price"] as! String
        let image: String = dict["image"] as! String
        
        //let modified = s.replace(" ", withString:"+")
        if !title.isEmpty {
            title = title.replace(target: "<b>",withString:"")
            title = title.replace(target: "</b>",withString:"")
            cell.bookTitleLabel.text = title
        }
        
        if !author.isEmpty {
            author = author.replace(target: "<b>",withString:"")
            author = author.replace(target: "</b>",withString:"")
            cell.bookInfoLabel.text = author
        }
        
        if !price.isEmpty {
            cell.bookPriceLabel.text = price
        }
        
        if !image.isEmpty{
            Alamofire.request(image).responseImage { response in
                if let image = response.result.value {
                    if cell.bookImageView.tag == indexPath.row {
                        cell.bookImageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    @IBAction func gouptotouched(_ sender: Any) {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        self.goup.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict: Dictionary = self.bookItems[indexPath.row] as! Dictionary <String, Any>
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.setView(dict)
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func reqvbooklist(){
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id":"kHZpka5OMHXGUPS_DcWE",
            "X-Naver-Client-Secret":"20rsZZrIWF"]
        
        var url : String = "https://openapi.naver.com/v1/search/book.json"
        url = url + "?query="
        url = url + self.keyWord
        url = url + "&display=30&start=" + String(curPage)
        if modnum == 1{
            url = url + "&d_titl=Y&d_auth=N&d_cont=N&d_publ=N"
        }
        else if modnum == 2{
            url = url + "&d_auth=Y&d_titl=N&d_cont=N&d_publ=N"
        }
        let encodurl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(encodurl, headers : headers).responseJSON {response in print(response.request)
            if let result: Dictionary<String, Any> = response.result.value as! Dictionary<String, Any>{
                if(self.curPage == 1){
                    self.bookItems = (result["items"] as! NSArray) as! Array<Any>
                    self.tableView.reloadData()
                    self.goup.isHidden = true
                    if(self.bookItems.count > 0) {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }else{
                    self.bookItems += (result["items"] as! NSArray) as! Array<Any>
                    self.tableView.reloadData()
                    self.isLoadingMore = false
                }
                self.curPage += 1
                //self.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }
    }
    
    @IBAction func searching(_ sender: Any) {
        self.reqsearchbook()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.reqsearchbook()
        return false
    }
    
    func reqsearchbook (){
        
        let keyword: String = textfield.text!
        if !keyword.isEmpty{
            self.curPage = 1
            self.keyWord = keyword
            self.reqvbooklist()
        }else{
            let dialog = UIAlertController(title: "알림", message: "검색어를 입력해주세요.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default)
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            /*let action = UIAlertAction(title: "확인", style: UIAlertActionStyle.default){ (action: UIAlertAction) -> Void in
             //수행하고자 하는 코드 추가
             }*/
        
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        if self.bookItems.count > 0 {
            if !isLoadingMore && (maximumOffset - contentOffset <= threshold) {
                self.isLoadingMore = true
                self.reqvbooklist()
            }
            if (contentOffset > 250){
                self.goup.isHidden = false
            }else{
                self.goup.isHidden = true
            }
        }
    }
    
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

