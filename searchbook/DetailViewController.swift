//
//  DetailViewController.swift
//  searchbook
//
//  Created by 박기찬 on 2018. 3. 18..
//  Copyright © 2018년 박기찬. All rights reserved.
//


import UIKit
import AlamofireImage
import Alamofire

class DetailViewController: UIViewController{
    @IBOutlet weak var navititlelabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var desciption: UITextView!
    
    var bookInfo: Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var title: String = self.bookInfo["title"] as! String
        var author: String = self.bookInfo["author"] as! String
        let price: String = self.bookInfo["price"] as! String
        var publisher: String = self.bookInfo["publisher"] as! String
        let description: String = self.bookInfo["description"] as! String
        let date: String = self.bookInfo["pubdate"]as! String
        let imageurl: String = self.bookInfo["image"]as! String
        
        if !title.isEmpty{
            title = title.replace(target: "<b>",withString:"")
            title = title.replace(target: "</b>",withString:"")
            self.navititlelabel.text = title
            self.titlelabel.text = title
            
        }
        
        if !author.isEmpty{
            author = author.replace(target: "<b>",withString:"")
            author = author.replace(target: "</b>",withString:"")
           self.author.text = author
        }
        
        if !price.isEmpty{
            self.price.text = price
        }
        
        if !publisher.isEmpty{
            publisher = publisher.replace(target: "<b>",withString:"")
            publisher = publisher.replace(target: "</b>",withString:"")
              self.publisher.text = publisher
        }
        
        if !description.isEmpty{
            self.desciption.text = description
        }
        
        if !date.isEmpty{
             self.date.text = date
        }
        
        if !imageurl.isEmpty{
            Alamofire.request(imageurl).responseImage { response in
                if let image = response.result.value {
                    self.imageview.image = image
                }
            }
        }
       
        
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView(_ dict: Dictionary<String, Any>){
        self.bookInfo = dict
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purchace(_ sender: Any) {
        let link: String = self.bookInfo["link"] as! String
        if let url = URL(string: link) {
            UIApplication.shared.open(url, options: [:]) {
                boolean in
                // do something with the boolean
            }
        }
    }
    
}
