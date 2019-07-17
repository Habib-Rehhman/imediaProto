

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
        
        renderLanguage()
        
        email.delegate = self
        password.delegate = self
        passwordConfirm.delegate = self
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        guard  !password.text!.isEmpty else {return}
        if password.text != passwordConfirm.text{
            let alertController = UIAlertController(title: "Retype Password", message: "Characters Entered do not match.Enter exactly the same password in both fields", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let url = URL(string: networkConstants.baseURL+networkConstants.signup)!//"https://reqres.in/api/login")!
        
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
                    self.performSegue(withIdentifier: "verifySegue", sender: self)
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(signUpStructure.self, from: jsonData)
                    if(gitData.message != "signup_success"){
                        
                        print("login unsuccessful reason:\(gitData.message)")
                        
                    }else{
                        print(gitData.userEmail!)
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure:
                self.showOkAlert(tit: "NetworkAlertTitle", msg: "NetworkAlertMessage")
                break
            }
        })
        
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
            let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
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


