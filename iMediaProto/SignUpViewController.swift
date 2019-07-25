

import UIKit
import Alamofire

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var sihnIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    @IBOutlet weak var alreadyAccount: UILabel!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var header: UILabel!
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        renderLanguage()
        
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        
        print((password.text!.isEmpty))
        print((password.text!.count < 7))
        print((SignUpViewController.isValidEmail(emailID: email.text!)))
        
        if((password.text!.isEmpty) || (password.text!.count < 7)){
            
            showOkAlert(tit: "", msg: "passwordMismatchMessage".localizableString(loc: LanguageViewController.buttonName))
            return
            
        }
        if(!SignUpViewController.isValidEmail(emailID: email.text!)) {
            
            showOkAlert(tit: "", msg: "InvalidEmail".localizableString(loc: LanguageViewController.buttonName))
            return
            
        }
        
        if password.text != passwordConfirm.text{
            showOkAlert(tit:  "RetypePassword", msg: "retypePasswordMsg")
            return
        }
        
        
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let url = URL(string: networkConstants.baseURL+networkConstants.signup)!
        
        let parameters:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "language":LanguageViewController.buttonName,
            "full_name":fullName.text!,
            "email_address":email.text!,
            "password":passwordConfirm.text!]
        
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        AF.request(url, method:.post, parameters: parameters, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            UIViewController.removeSpinner(spinner: sv)
            switch response.result {
                
            case .success(let json):
                print(json)
                do {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(signUpStructure.self, from: jsonData)
                    if(gitData.message != "signup_success"){
                        
                        switch gitData.message{
                            
                        case "account_exist_error":
                            self.showOkAlert(tit: "emailAlreadyExists".localizableString(loc: LanguageViewController.buttonName), msg:"")
                            print("login unsuccessful reason:\(gitData.message)")
                            break
                            
                            
                        default:
                            break
                        }
                    }else{
                        self.performSegue(withIdentifier: "verifySegue", sender: self)
                        print(gitData.userEmail!)
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure:
                self.showOkAlert(tit: "NetworkAlertTitle".localizableString(loc: LanguageViewController.buttonName), msg: "NetworkAlertMessage".localizableString(loc: LanguageViewController.buttonName))
                break
            }
        })
        
    }
    static func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        
        signUp.setTitle("SignUpButtonKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        sihnIn.setTitle("SignUpInButtonKey".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        alreadyAccount.text = "SignUpAlreadyAccountKey".localizableString(loc: LanguageViewController.buttonName)
        header.text = "SignUpHeaderKey".localizableString(loc: LanguageViewController.buttonName)
        
        fullName.placeholder = "SignUpFullNameKey".localizableString(loc: LanguageViewController.buttonName)
        email.placeholder = "SignUpEmailKey".localizableString(loc: LanguageViewController.buttonName)
        password.placeholder = "SignUpPasswordKey".localizableString(loc: LanguageViewController.buttonName)
        passwordConfirm.placeholder = "SignUpConfirmPaswordKey".localizableString(loc: LanguageViewController.buttonName)
        
    }
    func confirmPassword() {
        guard  !password.text!.isEmpty else {return}
        if password.text != passwordConfirm.text{
            let alertController = UIAlertController(title: "incorrectPassword".localizableString(loc: LanguageViewController.buttonName), message: "incorrectPasswordMsg".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


