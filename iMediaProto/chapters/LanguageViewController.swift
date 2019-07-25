

import UIKit
import Alamofire

class LanguageViewController: UIViewController {
    
    
    static var buttonName = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
         navigationController?.isNavigationBarHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    @IBAction func langButtonPressed(_ sender: UIButton) {
        
        switch sender.tag{
            
        case 1:
            LanguageViewController.buttonName = "ar"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 3:
            LanguageViewController.buttonName = "hi"
           self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 4:
            LanguageViewController.buttonName = "es"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 5:
            LanguageViewController.buttonName = "de"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 6:
            LanguageViewController.buttonName = "ru"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 7:
            LanguageViewController.buttonName = "zh-Hans"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 8:
            LanguageViewController.buttonName = "fa-IR"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        case 9:
            LanguageViewController.buttonName = "tr"
           self.performSegue(withIdentifier: "toAuthBoard", sender: self)
            break
        default:
            LanguageViewController.buttonName = "en"
            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
        }
    }
    static var arrayOfChapterIDs: [String] = []
    
}
