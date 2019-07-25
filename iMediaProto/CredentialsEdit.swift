//
//  CredentialsEdit.swift
//  iMediaProto
//
//  Created by Habib on 7/7/19.
//  Copyright © 2019 a. All rights reserved.
//sfhbwef,hjbwehjfdwe
import PMAlertController
import UIKit
import Alamofire

class CrdentialsEdit : UIViewController, UITextFieldDelegate {
    
    @IBAction func donPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var lang: UILabel!
    @IBAction func changePassword(_ sender: Any) {
        
        let alertVC = PMAlertController(title: "Password Change", description: "", image: UIImage(named: "img.png"), style: .walkthrough)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "current password"
            textField?.isSecureTextEntry = true
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder = "New passwor"
            textField?.isSecureTextEntry = true
        }
        alertVC.addTextField { (textField) in
            textField?.placeholder = "Confirm password"
            textField?.isSecureTextEntry = true
        }
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Capture action Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "save", style: .default, action: { () in
            if alertVC.textFields[0].text!.count < 8 {
                let alert = UIAlertController(title: "Incorrect current Password", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            if alertVC.textFields[1].text!.count < 8 || !alertVC.textFields[2].text!.elementsEqual(alertVC.textFields[1].text!)  {
                let alert = UIAlertController(title: "New password incorrect/mismatched", message: "password should be at least eight characters in length", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
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
    
    @IBAction func showEditDialog(_ sender: UIButton) {
        
        let alertVC = PMAlertController(title: "Enter New Name", description: "", image: UIImage(named: "img.png"), style: .alert)
        
        alertVC.addTextField { (textField) in
            textField?.placeholder = "New Name..."
        }
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
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
                        let alert = UIAlertController(title: "snap!", message: "You have entered an incorrect current password, try again!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    else if(gitData.message.elementsEqual("password_updated")){
                        UIViewController.removeSpinner(spinner: sv)
                        let alert = UIAlertController(title: "Password updated successfully", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
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
    
    // MARK: - Constants
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
}
