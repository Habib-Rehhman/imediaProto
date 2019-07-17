
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginCreateAccount: UIButton!
    @IBOutlet weak var logingForgot: UIButton!
    @IBOutlet weak var loginHeader: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var sv : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderLanguage()
        email.delegate = self
        password.delegate = self
  
    }
    
    
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        loginButton.setTitle("LoginSignInKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        logingForgot.setTitle("LoginForgotKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        loginCreateAccount.setTitle("LoginCreateAccountKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        loginHeader.text = "LoginHeaderKey".localizableString(loc: LanguageViewController.buttonName)
        
        password.placeholder = "LoginPasswordKey".localizableString(loc: LanguageViewController.buttonName)
        email.placeholder = "LoginEmailKey".localizableString(loc: LanguageViewController.buttonName)
        
    }
    
    
    
@IBAction func signInPressed(_ sender: UIButton) {
    
                let url = URL(string: networkConstants.baseURL+networkConstants.login)!//"https://reqres.in/api/login")!
                sv = UIViewController.displaySpinner(onView: self.view)
                let parameters:Parameters = [
                    "app_id":"com.wikibolics.com",
                    "appstore_id":"com.wikibolics.com",
                    "session":"",
                    "mac_id":"d4:61:9d:21:ea:f4",
                    "email_address":email.text!,
                    "password":password.text!]
        
                let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
                AF.request(url, method:.post, parameters: parameters, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
                    switch response.result {
        
                    case .success(let json):
                        print(json)
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: json)
                            let decoder = JSONDecoder()
                            let gitData = try decoder.decode(signinStructure.self, from: jsonData)
                            if(gitData.message != "login_success"){
        
                                UIViewController.removeSpinner(spinner: self.sv!)
                                self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                                print("login unsuccessful reason:\(gitData.message)")
        
                            }else{
                                networkConstants.session = "\(gitData.loginSession!)@d4:61:9d:21:ea:f4"
                                UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                                UserDefaults.standard.set(networkConstants.session, forKey: "session")
                                self.loadChapters()
                            }
        
                        } catch let err {
                            print(err.localizedDescription)
                        }
                        break
        
                    case .failure:
                        self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                        break
                    }
                })
        
        
       // self.performSegue(withIdentifier: "showChaptersNow", sender: self)
    }
    func loadChapters(){
        
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
                        UIViewController.removeSpinner(spinner: self.sv!)
                        self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                    }else{
                        UIViewController.removeSpinner(spinner: self.sv!)
                        self.performSegue(withIdentifier: "showChaptersNow", sender: self)
                        gitData.chaptersList!.forEach({ (chapter) in
                            QuoteDeck.sharedInstance.quotes.append( Quote(text: chapter.part,tags: [chapter.name]))
                        })
                        QuoteDeck.sharedInstance.quotes.append( Quote(text: "Gallery",tags: ["Gallery"]))
                        QuoteDeck.sharedInstance.update()  
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure(let error):
                UIViewController.removeSpinner(spinner: self.sv!)
                self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                print(error.localizedDescription)
                break
            }
            
        })
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}
