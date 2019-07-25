//
//  lessonsViewController.swift
//  iMediaProto
//
//  Created by Habib on 6/30/19.
//  Copyright © 2019 a. All rights reserved.
//hjavdjheavfahsjdhjs


import UIKit
import Alamofire

class lesonsViewController : UITableViewController, UIDataSourceModelAssociation {
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet fileprivate var barButton: UIBarButtonItem!
    // MARK: - Constants
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.title =  "Chapters".localizableString(loc: LanguageViewController.buttonName)
        tableView.tableFooterView = UIView(frame: .zero)
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.tableView.backgroundView = backgroundImage
        
    }
    private var index = 0;
    static var lessons: [lesson] = []
    private struct Storyboard {
        static let TopicCellIdentifier = "TopicCell"
        static let ShowQuoteSegueIdentifier = "ShowQuote"
    }
    
    @IBAction func showMenuAction(_ sender: UIBarButtonItem) {
        
//        //let sb = Storyboard(
//        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
//        menuViewController.modalPresentationStyle = .fullScreen
////        menuViewController.transitioningDelegate = self
////
////        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
////        presentationAnimator.supportView = navigationController!.navigationBar
//        //presentationAnimator.presentButton = sender
//        present(menuViewController, animated: true, completion: nil)
        
        
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "settings".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: { _ in

                    let menuViewController = self.storyboard!.instantiateViewController(withIdentifier: "credentials")
                    menuViewController.modalPresentationStyle = .fullScreen
                    self.present(menuViewController, animated: true, completion: nil)
            
        }))
        
        sheet.addAction(UIAlertAction(title: "AboutUs".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: { _ in
            
        }))
        
        sheet.addAction(UIAlertAction(title: "signOut".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: { _ in
            
            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
            LanguageViewController.arrayOfChapterIDs.removeAll()
            QuoteDeck.sharedInstance.quotes.removeAll()
            QuoteDeck.sharedInstance.tagSet.removeAll()
            self.performSegue(withIdentifier: "toAuthBoard", sender: nil)
            
        }))
        
        sheet.addAction(UIAlertAction(title: "PrivacyPolicy".localizableString(loc: LanguageViewController.buttonName), style: .default, handler: { _ in
            
            let a = UIAlertController(title: "PrivacyPolicy".localizableString(loc: LanguageViewController.buttonName), message: "privacyText".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: nil)
            a.addAction(defaultAction)
            self.present(a, animated: true, completion: nil)
            
        }))
        
        sheet.addAction(UIAlertAction(title: "close".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: nil))
        
        self.present(sheet, animated: true, completion: nil)
    }
    var selectedTopic: String?
    
     //MARK: - View controller lifecycle
    
    
    
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        // let row = lesonsViewController.lessons.//firstIndex(of: identifier) ?? 0
        //index += 1
        return IndexPath(row: index, section: 0)
    }
    
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        return lesonsViewController.lessons[idx.row].name
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.backgroundColor = UIColor(hexString: "#A5DEFF")
      return lesonsViewController.lessons.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell")!
        
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            cell.textLabel?.textAlignment = .right
        }else{
            cell.textLabel?.textAlignment = .left
        }
        
        cell.textLabel?.text = lesonsViewController.lessons[indexPath.row].name
        
        //.gray
//         cell.layer.cornerRadius = 30
//        cell.layer.borderWidth = CGFloat(12)
//        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("lessonObject:  \(lesonsViewController.lessons[indexPath.row])\n size: \(lesonsViewController.lessons.count)")
        SubLessonsVC.sublessons.removeAll()
        var s = ""
        if(lesonsViewController.lessons[indexPath.row].subLessons == "0"){
            s = networkConstants.baseURL+networkConstants.content
            subLessonWasZero(theUrl: s,lesn: "\(lesonsViewController.lessons[indexPath.row].id)", subLsn:"\(lesonsViewController.lessons[indexPath.row].subLessons)")
            //lesn: "35",subLsn:  "0")
        }else{
            s = networkConstants.baseURL+networkConstants.sublessons
            subLessonWasOne(theUrl: s, lesn: "\(lesonsViewController.lessons[indexPath.row].id)", subLsn:"\(lesonsViewController.lessons[indexPath.row].subLessons)")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    var content: String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebVC {
            destinationVC.html = content
        }
    }
    
    func subLessonWasZero(theUrl: String, lesn: String, subLsn: String){
        
        let urlChapter = URL(string: theUrl)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "lesson": lesn,
            "sub_lesson": subLsn,
            "session":networkConstants.session
        ]
        let sv = UIViewController.displaySpinner(onView: self.tableView!)
        AF.request(urlChapter, method:.post, parameters: parametersChapter, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            switch response.result {
            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(contentStruct.self, from: jsonData)
                    
                    if(gitData.message != nil){
                        UIViewController.removeSpinner(spinner: sv)
                        switch gitData.message!{
                            
                        case "session_inactive":
                            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                            UserDefaults.standard.removeObject(forKey: "session")
                            UserDefaults.standard.removeObject(forKey: "language")
                            QuoteDeck.sharedInstance.quotes.removeAll()
                            QuoteDeck.sharedInstance.tagSet.removeAll()
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            break
                            
                        case "content_empty":
                            print("this sublesson contain")
                            self.showOkAlert(tit: "EmptyLessonsListTitle", msg: "EmptyLessonsListMessage")
                            break
                        case "subscription_required":
                            self.presentQR(completion: {b in
                                if(b){
                                    self.performSegue(withIdentifier: "scanQRNow", sender: nil)
                                }
                            })
                            break
                        default:
                            print("no point in making this request")
                        }
                        
                    }else if gitData.content == nil{
                        print("Empty Respons   \(gitData)")
                        UIViewController.removeSpinner(spinner: sv)
                    }
                    else{
                        print(gitData.content!)
                        ImagesVC.newStruct.removeAll()
                        ImagesVC.picz.removeAll()
                        self.content = gitData.content!
                        print(gitData.images!)
                        gitData.images?.forEach({u in
                            ImagesVC.newStruct.append(u)
                        })
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier:"webVCcalledBylesonsVC", sender: nil)
                        ImagesVC.dealWithIt = ImagesVC.newStruct
                        ImagesVC.whoSent = "contentVC"
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure(let error):
                UIViewController.removeSpinner(spinner: sv)
                self.showOkAlert(tit: "NetworkAlertTitle", msg: "NetworkAlertMessage")
                print(error.localizedDescription)
                break
            }
            
        })
        // self.performSegue(withIdentifier:"showSubLessons", sender: nil)
    }
    
    
    func subLessonWasOne(theUrl: String, lesn: String, subLsn: String){
        
        let urlChapter = URL(string: theUrl)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "lesson": lesn,
            "sub_lesson": subLsn,
            "session":networkConstants.session
        ]
        let sv = UIViewController.displaySpinner(onView: self.tableView!)
        AF.request(urlChapter, method:.post, parameters: parametersChapter, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            switch response.result{
                
                            case .success(let json):
                                do {
                                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                                    let decoder = JSONDecoder()
                                    let gitData = try decoder.decode(arrayOfSubLessons.self, from: jsonData)
                                    if(gitData.message != nil){
                                        UIViewController.removeSpinner(spinner: sv)
                                        switch gitData.message!{
                
                                        case "lessons_list_empty":
                                            print("this sublesson contain")
                                            self.showOkAlert(tit: "EmptyLessonsListTitle", msg: "EmptyLessonsListMessage")
                                            break
                                        case "subscription_required":
                                            self.presentQR(completion: {b in
                                                if(b){
                                                    self.performSegue(withIdentifier: "scanQRNow", sender: nil)
                                                }
                                            })
                                            break
                                        default:
                
                                            print("no point in making this request")
                                        }
                
                                    }else{
                                        SubLessonsVC.sublessons.removeAll()
                                        gitData.sublessonsList!.forEach({ (lesn) in
                                            SubLessonsVC.sublessons.append(lesn)
                                        })
                                        UIViewController.removeSpinner(spinner: sv)
                
                                        self.performSegue(withIdentifier:"showSubLessons", sender: nil)
                                    }
                
                                } catch let err {
                                    print("Err", err)
                                }
                                break
                
                            case .failure(let error):
                                UIViewController.removeSpinner(spinner: sv)
                                self.showOkAlert(tit: "NetworkAlertTitle", msg: "NetworkAlertMessage")
                                print(error.localizedDescription)
                                break
            }
            
        })
        
    }
}

extension lesonsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}

