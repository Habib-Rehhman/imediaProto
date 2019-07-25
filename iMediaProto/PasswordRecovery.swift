//
//  PasswordRecovery.swift
//  iMediaProto
//
//  Created by Habib on 6/24/19.
//  Copyright © 2019 a. All rights reserved.
//


import UIKit
import Alamofire

class PasswordRecoverController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var continueButtonOutlet: UIButton!
    @IBOutlet weak var recoveryHeader: UILabel!
    
    @IBOutlet weak var recoveryContactUs: UIButton!
    @IBOutlet weak var recoveryTrouble: UILabel!
    @IBOutlet weak var recoveryEmailField: UITextField!
    @IBOutlet weak var recoveryDescription: UITextView!
    
    @IBAction func continuePressed(_ sender: Any) {
        
        if(!SignUpViewController.isValidEmail(emailID: recoveryEmailField.text!)) {
            
            showOkAlert(tit: "", msg: "InvalidEmail".localizableString(loc: LanguageViewController.buttonName))
            return
            
        }
        
        let p: Parameters =
            [
                "app_id":"com.wikibolics.com",
                "appstore_id":"com.wikibolics.com",
                "session":networkConstants.session,
                "email_address": recoveryEmailField.text!
        ]
        let e = networkConstants.baseURL+networkConstants.recoverPassword
        print(p)
        self.makeRequestToServer(parameters: p, endPointURL: e)
    }
    
    
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" ||  LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        continueButtonOutlet.setTitle("RecoveryContinueKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        recoveryContactUs.setTitle("RecoveryContactUsKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        recoveryHeader.text = "RecoveryHeaderKey".localizableString(loc: LanguageViewController.buttonName)
        recoveryDescription.text = "RecoveryInstructionKey".localizableString(loc: LanguageViewController.buttonName)
        recoveryTrouble.text = "RecoveryHavingTroubleKey".localizableString(loc: LanguageViewController.buttonName)
        recoveryEmailField.placeholder = "RecoveryEmailKey".localizableString(loc: LanguageViewController.buttonName)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        recoveryEmailField.delegate = self
        renderLanguage()
    }
    
    
    func makeRequestToServer(parameters: Parameters, endPointURL: String)
    {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let url = URL(string: endPointURL)!
        //let parametersChapter : Parameters = parameters
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        AF.request(url, method:.post, parameters: parameters, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            switch response.result {
                
            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(forgotPassword.self, from: jsonData)
                    if((gitData.message?.elementsEqual("email_unrecognized"))!){
                        UIViewController.removeSpinner(spinner: sv)
                        print("message: \(gitData.message!)")
                        let alert = UIAlertController(title: "unregisteredEmail".localizableString(loc: LanguageViewController.buttonName), message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }else if((gitData.message?.elementsEqual("session_inactive"))!){
                        
                        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                        UserDefaults.standard.removeObject(forKey: "session")
                        UserDefaults.standard.removeObject(forKey: "language")
                        QuoteDeck.sharedInstance.quotes.removeAll()
                        QuoteDeck.sharedInstance.tagSet.removeAll()
                        self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                        
                    }
                    else if((gitData.message?.elementsEqual("request_succeed"))!){
                        UIViewController.removeSpinner(spinner: sv)
                        let a = UIAlertController(title: "RecoveryAlertControllerTitleKey".localizableString(loc: LanguageViewController.buttonName), message: "RecoveryAlertControllerKey".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                        let act = UIAlertAction(title: "ok".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: {_ in
                            self.navigationController?.popViewController(animated: true)
                            if(self.navigationController == nil){
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                        a.addAction(act)
                        self.present(a, animated: true, completion: nil)
                        return
                    }else{
                        
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


