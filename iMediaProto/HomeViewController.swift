//
//  HomeViewController.swift
//  Created by Habib on 7/1/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    @IBOutlet weak var trouble: UILabel!
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var contactUs: UIButton!
    @IBOutlet weak var instructionBidy: UITextView!
    @IBOutlet weak var header: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        renderLanguage()
    }
    
    @IBAction func signPressed(_ sender: UIButton) {
        //
        //                let sv = UIViewController.displaySpinner(onView: self.view)
        //                let url = URL(string: networkConstants.baseURL+networkConstants.nextToLogin)!//"https://reqres.in/api/login")!
        //
        //                let parameters:Parameters = [
        //                    "app_id":"com.wikibolics.com",
        //                    "appstore_id":"com.wikibolics.com",
        //                    "session":networkConstants.session
        //                     ]
        //
        //                let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        //
        //                AF.request(url, method:.post, parameters: parameters, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
        //                    UIViewController.removeSpinner(spinner: sv)
        //                    switch response.result {
        //
        //                    case .success(let json):
        //                        do {
        //                            let jsonData = try JSONSerialization.data(withJSONObject: json)
        //                            let decoder = JSONDecoder()
        //                            let gitData = try decoder.decode(arrayOfChapters.self, from: jsonData)
        //                            if(gitData.message != nil){
        //
        //                                print("login unsuccessful reason:\(gitData.message!)")
        //
        //                            }else{
        //
        ////                                gitData.chaptersList!.forEach({ (chapter) in
        ////                                   lesonsViewController.lessons.append(Quote(text: chapter.name
        ////                                    , tags: [chapter.part]))
        ////                                })
        //                                print("home.........")
        //                            }
        //
        //                        } catch let err {
        //                            print("Err", err)
        //                        }
        //                        break
        //
        //                    case .failure(let error):
        //                        print("errorrrrrrrrrrr")
        //                        print(error.localizedDescription)
        //                        break
        //                    }
        //                })
        
    }
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" ||  LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        
        signIn.setTitle("VerifyEmailSignInKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        contactUs.setTitle("VerifyEmailContactUsKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        trouble.text = "VerifyEmailHavingTroubleKey".localizableString(loc: LanguageViewController.buttonName)
        header.text = "VerifyEmailHeaderKey".localizableString(loc: LanguageViewController.buttonName)
        
        instructionBidy.text = "VerifyEmailInstructionKey".localizableString(loc: LanguageViewController.buttonName)
        
        
    }
    
}

