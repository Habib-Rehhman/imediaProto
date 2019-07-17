//
//  LaunchScreenVC.swift
//  iMediaProto
//
//  Created by Habib on 7/9/19.
//  Copyright © 2019 a. All rights reserved.
//
import UIKit
import  Alamofire
//import Foundation

class LaunchScreenVC: UIViewController {
    
    override func viewDidLoad() {
       super.viewDidLoad()
       loadChapters()
    }
    
    
    func loadChapters(){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let urlChapter = URL(string: networkConstants.baseURL+networkConstants.nextToLogin)!//"https://reqres.in/api/login")!
        
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "session":networkConstants.session
        ]
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        AF.request(urlChapter, method:.post, parameters: parametersChapter, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            //    print("its sess::: \(gitData.loginSession!)@d4:61:9d:21:ea:f4")
            switch response.result {
                
            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(arrayOfChapters.self, from: jsonData)
                    if(gitData.message != nil){
                        UIViewController.removeSpinner(spinner: sv)
                        self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                    }else{
                        UIViewController.removeSpinner(spinner: sv)
                        // self.performSegue(withIdentifier: "showChaptersNow", sender: self)
                        self.performSegue(withIdentifier: "toChaptersBoard", sender: self)
                        gitData.chaptersList!.forEach({ (chapter) in
                            QuoteDeck.sharedInstance.quotes.append( Quote(text: chapter.part,tags: [chapter.name]))
                        })
                        
                        QuoteDeck.sharedInstance.update()
                        QuoteDeck.sharedInstance.quotes.append( Quote(text: "Gallery",tags: ["Gallery"]))
                        
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure(let error):
                UIViewController.removeSpinner(spinner: sv)
                self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                print(error.localizedDescription)
                break
            }
            
        })
    }
    
}
