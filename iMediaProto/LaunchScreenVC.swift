//
//  LaunchScreenVC.swift
//  iMediaProto
//
//  Created by Habib on 7/9/19.
//  Copyright © 2019 a. All rights reserved.
//
import UIKit
import  Alamofire


class LaunchScreenVC: UIViewController {
    
    
    @IBOutlet weak var tryBtnOutLet: UIButton!
    @IBOutlet weak var noNetworkLabel: UILabel!
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        noNetworkLabel.isHidden = true
        tryBtnOutLet.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(checkAutoLogin), name: UIApplication.willEnterForegroundNotification, object: nil)
        checkAutoLogin()
    }
    
    @IBAction func tryAgainBtn(_ sender: Any) {
        
        self.noNetworkLabel.isHidden = true
        self.tryBtnOutLet.isHidden = true
        loadChapters()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    @objc func checkAutoLogin(){
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            networkConstants.session = UserDefaults.standard.string(forKey: "session")!
            LanguageViewController.buttonName = UserDefaults.standard.string(forKey: "language")!
            loadChapters()
        }else{
            self.performSegue(withIdentifier: "launchTolanguage", sender: nil)
        }
    }
    
    func loadChapters(){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        let urlChapter = URL(string: networkConstants.baseURL+networkConstants.nextToLogin)!
        
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
                            UserDefaults.standard.removeObject(forKey: "language")
                            QuoteDeck.sharedInstance.quotes.removeAll()
                            QuoteDeck.sharedInstance.tagSet.removeAll()
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            
                        }else{
                            UIViewController.removeSpinner(spinner: sv)
                            
                            self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                        }
                    }else{
                        LanguageViewController.arrayOfChapterIDs.removeAll()
                        
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier: "toChaptersBoardFromLVC", sender: self)
                        gitData.chaptersList!.forEach({ (chapter) in
                            print(chapter.name)
                            LanguageViewController.arrayOfChapterIDs.append(chapter.id)
                            QuoteDeck.sharedInstance.quotes.append( Quote(text: chapter.part,tags: [chapter.name]))
                        })
                        QuoteDeck.sharedInstance.quotes.append( Quote(text: "",tags: ["gallery".localizableString(loc: LanguageViewController.buttonName)]))
                        QuoteDeck.sharedInstance.update()
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure(let error):
                
                UIViewController.removeSpinner(spinner: sv)
                
                if((error as NSError).code == -1009){
                    
                    let alert = UIAlertController(title: "NetworkAlertTitle".localizableString(loc: LanguageViewController.buttonName), message: "NetworkAlertMessage".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                    //                    let tryAgain = UIAlertAction(title: "tryagain".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: {_ in
                    //                        self.loadChapters()
                    //                    })
                    let cancell = UIAlertAction(title: "Ok".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: {_ in
                        self.noNetworkLabel.isHidden = false
                        self.tryBtnOutLet.isHidden = false
                        //                        self.dismiss(animated: true, completion: nil)
                        //                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    })
                    // alert.addAction(tryAgain)
                    alert.addAction(cancell)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                break
            }
            
        })
    }
    
}

