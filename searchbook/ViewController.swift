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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var mod: UILabel!
    @IBOutlet weak var textfield: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var curPage: Int = 1
    var bookItems: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       // self.reqvbooklist("harry")
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }))
        actionSheet.addAction(UIAlertAction(title: "제목", style: .default, handler: { result in
            self.mod.text = "제목"
        }))
        actionSheet.addAction(UIAlertAction(title: "저자", style: .default, handler: { result in
            self.mod.text = "저자"
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchBookCell = tableView.dequeueReusableCell(withIdentifier: "SearchBookCell", for: indexPath) as! SearchBookCell
        
        let dict: Dictionary = self.bookItems[indexPath.row] as! Dictionary <String, Any>
        var title: String = dict["title"] as! String
        var author: String = dict["author"] as! String
        let price: String = dict["price"] as! String
        let image: String = dict["image"] as! String
        
        //let modified = s.replace(" ", withString:"+")
        title = title.replace(target: "<b>",withString:"")
        title = title.replace(target: "</b>",withString:"")
        
        author = author.replace(target: "<b>",withString:"")
        author = author.replace(target: "</b>",withString:"")

        let url = URL(string: image)!
        cell.bookImageView.af_setImage(withURL: url)
        cell.bookTitleLabel.text = title
        cell.bookInfoLabel.text = author
        cell.bookPriceLabel.text = price
        
        
        
        /*image    String    "https://bookthumb.phinf.naver.net/cover/132/413/13241318.jpg?type=m1&udate=20180211"    
        Alamofire.request(image).responseImage { response in
            if let image = response.result.value {
                cell.bookImageView.image = image
            }
        }
 */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict: Dictionary = self.bookItems[indexPath.row] as! Dictionary <String, Any>
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: DetailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        controller.setView(dict)
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    func reqvbooklist(_ word: String){
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id":"kHZpka5OMHXGUPS_DcWE",
            "X-Naver-Client-Secret":"20rsZZrIWF"]
        
        var url : String = "https://openapi.naver.com/v1/search/book.json"
        url = url + "?query="
        url = url + word
        url = url + "&display=30&start=" + String(curPage)
        let encodurl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(encodurl, headers : headers).responseJSON {response in print(response.request)
            if let result: Dictionary<String, Any> = response.result.value as! Dictionary<String, Any>{
                self.bookItems = (result["items"] as! NSArray) as! Array<Any>
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func searching(_ sender: Any) {
        let keyword: String = textfield.text!
        if !keyword.isEmpty{
         self.reqvbooklist(keyword)
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
    
}

extension String
{
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
}

