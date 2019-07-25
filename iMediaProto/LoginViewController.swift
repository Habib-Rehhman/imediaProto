
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
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
    
    
    
    @IBAction func signInPressed(_ sender: Any?) {
        
        //    print((password.text!.isEmpty))
        //     print((password.text!.count < 8))
        //     print((SignUpViewController.isValidEmail(emailID: email.text!)))
        if((password.text!.isEmpty) || (password.text!.count < 7)){
            
            showOkAlert(tit: "", msg: "passwordMismatchMessage".localizableString(loc: LanguageViewController.buttonName))
            return
            
        }
        if(!SignUpViewController.isValidEmail(emailID: email.text!)) {
            
            showOkAlert(tit: "", msg: "InvalidEmail".localizableString(loc: LanguageViewController.buttonName))
            return
            
        }
        
        self.navigationController?.isNavigationBarHidden = true
        let url = URL(string: networkConstants.baseURL+networkConstants.login)!
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
                        
                        switch gitData.message{
                            
                        case "verification_required":
                            self.showOkAlert(tit: "verificationRequired".localizableString(loc: LanguageViewController.buttonName), msg: "verificationRequiredMsg".localizableString(loc: LanguageViewController.buttonName))
                            break
                            
                        case "invalid_credentials":
                            self.showOkAlert(tit: "WrongCredAlertTitle".localizableString(loc: LanguageViewController.buttonName), msg: "WrongCredAlertMessage".localizableString(loc: LanguageViewController.buttonName))
                            
                            break
                            
                        default:
                            
                            break
                        }
                        
                        UIViewController.removeSpinner(spinner: self.sv!)
                        
                        print("login unsuccessful reason:\(gitData.message)")
                        
                    }else{
                        networkConstants.session = "\(gitData.loginSession!)@d4:61:9d:21:ea:f4"
                        UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                        LanguageViewController.buttonName = gitData.loginLanguage!
                        UserDefaults.standard.set(gitData.loginLanguage!, forKey: "language")
                        UserDefaults.standard.set(networkConstants.session, forKey: "session")
                        self.loadChapters()
                    }
                    
                } catch let err {
                    print(err.localizedDescription)
                }
                break
                
            case .failure(let error):
                UIViewController.removeSpinner(spinner: self.sv!)
                if((error as NSError).code == -1009){
                    let alert = UIAlertController(title: "NetworkAlertTitle".localizableString(loc: LanguageViewController.buttonName), message: "NetworkAlertMessage".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                    let tryAgain = UIAlertAction(title: "tryagain".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: {_ in
                        self.signInPressed(nil)
                    })
                    let cancell = UIAlertAction(title: "Cancel".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    })
                    alert.addAction(tryAgain)
                    alert.addAction(cancell)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            }
        })
        
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
                        LanguageViewController.arrayOfChapterIDs.removeAll()
                        
                        UIViewController.removeSpinner(spinner: self.sv!)
                        self.performSegue(withIdentifier: "showChaptersNow", sender: self)
                        gitData.chaptersList!.forEach({ (chapter) in
                            LanguageViewController.arrayOfChapterIDs.append(chapter.id)
                            QuoteDeck.sharedInstance.quotes.append( Quote(text: chapter.part,tags: [chapter.name]))
                            QuoteDeck.sharedInstance.update()
                        })
                        QuoteDeck.sharedInstance.quotes.append( Quote(text: "",tags: ["gallery".localizableString(loc: LanguageViewController.buttonName)]))
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
