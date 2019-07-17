//
//  lessonsViewController.swift
//  iMediaProto
//
//  Created by Habib on 6/30/19.
//  Copyright © 2019 a. All rights reserved.
//

import WebKit
import UIKit
import Alamofire

class SubLessonsVC : UITableViewController, UIDataSourceModelAssociation {
    
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    @IBOutlet fileprivate var barButton: UIBarButtonItem!
    // MARK: - Constants
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private var index = 0;
    static var sublessons: [sublesson] = []
    private struct Storyboard {
        static let TopicCellIdentifier = "TopicCell"
        static let ShowQuoteSegueIdentifier = "ShowQuote"
    }
    
    @IBAction func showMenuAction(_ sender: UIBarButtonItem) {
        
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .custom
        menuViewController.transitioningDelegate = self
        
        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
        presentationAnimator.supportView = navigationController!.navigationBar
        //presentationAnimator.presentButton = sender
        present(menuViewController, animated: true, completion: nil)
    }
    //var selectedTopic: String?
    
    // MARK: - View controller lifecycle
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as? QuoteViewController {
//            destinationVC.topic = selectedTopic
//        }
//    }
    
    
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        // let row = lesonsViewController.lessons.//firstIndex(of: identifier) ?? 0
       // index += 1
        return IndexPath(row: index, section: 0)
    }
    
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        return SubLessonsVC.sublessons[idx.row].name
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor(hexString: "#A5DEFF")
        print("count::\(SubLessonsVC.sublessons.count)")
        return SubLessonsVC.sublessons.count

    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lessonCell")!
        
        cell.textLabel?.text = SubLessonsVC.sublessons[indexPath.row].name
        cell.layer.cornerRadius = 30
        cell.layer.borderWidth = CGFloat(12)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    var content: String = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? WebVC {
            destinationVC.html = content
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("Sub_lessonObject:  \(SubLessonsVC.sublessons[indexPath.row])\n size: \(SubLessonsVC.sublessons.count)")
        var s = ""
        if(SubLessonsVC.sublessons[indexPath.row].id == "0"){
            s = networkConstants.baseURL+networkConstants.content
            subLessonWasZero(theUrl: s,lesn: "\(lesonsViewController.lessons[indexPath.row].id)", subLsn:"\(SubLessonsVC.sublessons[indexPath.row].id)")
            //lesn: "35",subLsn:  "0")
        }else{
             s = networkConstants.baseURL+networkConstants.sublessons
           subLessonWasOne(theUrl: s, lesn: "\(lesonsViewController.lessons[indexPath.row].id)", subLsn:"\(SubLessonsVC.sublessons[indexPath.row].id)")
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
        let sv = UIViewController.displaySpinner(onView: self.view)
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
                            
                        case "content_empty":
                            print("this sublesson contain")
                            self.showOkAlert(tit: "EmptyLessonsListTitle", msg: "EmptyLessonsListMessage")
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
                        //ImagesVC.dealWithIt = []
                        ImagesVC.picz.removeAll()
                        self.content = gitData.content!
                        gitData.images?.forEach({u in
                            ImagesVC.newStruct.append(u)
                        })
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier:"showWebView", sender: nil)
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
        let sv = UIViewController.displaySpinner(onView: self.view)
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
                            
                        case "content_empty":
                            print("this sublesson contain")
                            self.showOkAlert(tit: "EmptyLessonsListTitle", msg: "EmptyLessonsListMessage")
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
                        self.content = gitData.content!
                         print(gitData.images!)
                        gitData.images?.forEach({u in
                            ImagesVC.newStruct.append(u)
                        })
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier:"showWebView", sender: nil)
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

extension SubLessonsVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
