

import UIKit
import Alamofire

class LanguageViewController: UIViewController {
    
    
    static var buttonName = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.isNavigationBarHidden = false
    }
    func checkAutoLogin(){
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            
            networkConstants.session = UserDefaults.standard.string(forKey: "session")!
            loadChapters()
        }else{
            performSegue(withIdentifier: "toAuthBoard", sender: self)
        }
    }
    @IBAction func langButtonPressed(_ sender: UIButton) {
        
        switch sender.tag{
            
        case 1:
            LanguageViewController.buttonName = "ar"
            //performSegue(withIdentifier: "toAuthBoard", sender: self)//
            checkAutoLogin()
            break
        case 3:
            LanguageViewController.buttonName = "hi"
           // performSegue(withIdentifier: "toAuthBoard",sender: self)//"languageSelected",
            checkAutoLogin()
            break
        case 4:
            LanguageViewController.buttonName = "es"
            //performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        case 5:
            LanguageViewController.buttonName = "de"
            //performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        case 6:
            LanguageViewController.buttonName = "ru"
          //  performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        case 7:
            LanguageViewController.buttonName = "zh-Hans"
            //performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        case 8:
            LanguageViewController.buttonName = "fa-IR"
          //  performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        case 9:
            LanguageViewController.buttonName = "tr"
          //  performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
            break
        default:
            LanguageViewController.buttonName = "en"
          //  performSegue(withIdentifier: "toAuthBoard", sender: self)
            checkAutoLogin()
        }
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
                        if((gitData.message?.elementsEqual("session_inactive"))!){
                            
                            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                            UserDefaults.standard.removeObject(forKey: "session")
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            
                        }else{
                        UIViewController.removeSpinner(spinner: sv)
                      
                        self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                        }
                    }else{
                        UIViewController.removeSpinner(spinner: sv)
                         self.performSegue(withIdentifier: "toChaptersBoard", sender: self)
                        gitData.chaptersList!.forEach({ (chapter) in
                            print(chapter.name)
                            QuoteDeck.sharedInstance.quotes.append( Quote(text: chapter.part,tags: [chapter.name]))
                        })
                          QuoteDeck.sharedInstance.quotes.append( Quote(text: "Gallery",tags: ["Gallery"]))
                        QuoteDeck.sharedInstance.update()
                        //    self.performSegue(withIdentifier: "showChaptersNow", sender: self)
                        
                        
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
