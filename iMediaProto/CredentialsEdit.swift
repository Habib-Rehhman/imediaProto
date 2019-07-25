//
//  CredentialsEdit.swift
//  iMediaProto
//
//  Created by Habib on 7/7/19.
//  Copyright © 2019 a. All rights reserved.
//
import PMAlertController
import UIKit
import Alamofire

class CrdentialsEdit : UIViewController, UITextFieldDelegate {
    @IBOutlet weak var EditLabel: UIButton!
    
    
    @IBAction func donPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var doneLabel: UIButton!
    @IBOutlet weak var changPasswordLabel: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lang: UILabel!
    @IBAction func changePassword(_ sender: Any) {
        
        let alertVC = PMAlertController(title: "changePassword".localizableString(loc: LanguageViewController.buttonName), description: "", image: UIImage(named: "img.png"), style: .walkthrough)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder =  "currentpassword".localizableString(loc: LanguageViewController.buttonName)
            textField?.isSecureTextEntry = true
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder =  "Newpassword".localizableString(loc: LanguageViewController.buttonName)
            textField?.isSecureTextEntry = true
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder = "SignUpConfirmPaswordKey".localizableString(loc: LanguageViewController.buttonName)
            textField?.isSecureTextEntry = true
        }
        
        alertVC.addAction(PMAlertAction(title: "Cancel".localizableString(loc: LanguageViewController.buttonName), style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "save".localizableString(loc: LanguageViewController.buttonName), style: .default, action: { () in
            if alertVC.textFields[0].text!.count < 8 {
                let alert = UIAlertController(title:"incorrectPassword".localizableString(loc: LanguageViewController.buttonName), message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            if alertVC.textFields[1].text!.count < 8 || !alertVC.textFields[2].text!.elementsEqual(alertVC.textFields[1].text!)  {
                let alert = UIAlertController(title: "passwordMismatch".localizableString(loc: LanguageViewController.buttonName), message: "passwordMismatchMessage".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            let p: Parameters =
                [
                    "app_id":"com.wikibolics.com",
                    "appstore_id":"com.wikibolics.com",
                    "session":networkConstants.session,
                    "password": alertVC.textFields[2].text!,
                    "c_password": alertVC.textFields[0].text!
            ]
            let e = networkConstants.baseURL+networkConstants.settings
            print(p)
            self.makeRequestToServer(parameters: p, endPointURL: e)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        nameLabel.text = "name".localizableString(loc: LanguageViewController.buttonName)
        
        lang.text = "Language".localizableString(loc: LanguageViewController.buttonName)
        
        EditLabel.setTitle("edit".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        changPasswordLabel.setTitle("changePassword".localizableString(loc: LanguageViewController.buttonName), for: .normal
        )
        doneLabel.setTitle("done".localizableString(loc: LanguageViewController.buttonName), for: .normal)
    }
    
    
    @IBAction func showEditDialog(_ sender: UIButton) {
        
        let alertVC = PMAlertController(title: "enterNewName".localizableString(loc: LanguageViewController.buttonName), description: "", image: UIImage(named: "img.png"), style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "namePlaceHolder".localizableString(loc: LanguageViewController.buttonName)
        }
        
        alertVC.addAction(PMAlertAction(title: "Cancel".localizableString(loc: LanguageViewController.buttonName), style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "save", style: .default, action: { () in
            guard let textField = alertVC.textFields.first else {
                return
            }
            self.nameLabel.text = textField.text!
            print("Capture action OK")
        }))
        
        self.present(alertVC, animated: true, completion: nil)
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
                    let gitData = try decoder.decode(change_Password.self, from: jsonData)
                    if(gitData.message.elementsEqual("current_password_unmatched")){
                        UIViewController.removeSpinner(spinner: sv)
                        let alert = UIAlertController(title: "", message: "incorrectPassword".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else if((gitData.message.elementsEqual("session_inactive"))){
                        
                        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                        UserDefaults.standard.removeObject(forKey: "session")
                        UserDefaults.standard.removeObject(forKey: "language")
                        QuoteDeck.sharedInstance.quotes.removeAll()
                        QuoteDeck.sharedInstance.tagSet.removeAll()
                        self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                        
                    }
                    else if(gitData.message.elementsEqual("password_updated")){
                        UIViewController.removeSpinner(spinner: sv)
                        let alert = UIAlertController(title: "successfulPasswordUpdation".localizableString(loc: LanguageViewController.buttonName), message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
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
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    // MARK: - Constants
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        renderLanguage()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
}
