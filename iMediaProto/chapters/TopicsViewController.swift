
//
import UIKit
import Alamofire

class TopicsViewController : UITableViewController, UIDataSourceModelAssociation {
    
    @IBOutlet fileprivate var barButton: UIBarButtonItem!
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // MARK: - Constants
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title =  "Sections".localizableString(loc: LanguageViewController.buttonName)
        tableView.tableFooterView = UIView(frame: .zero)
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background.png")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    private struct Storyboard {
        static let TopicCellIdentifier = "TopicCell"
        static let ShowQuoteSegueIdentifier = "ShowQuote"
    }
    
    @IBAction func showMenuAction(_ sender: UIBarButtonItem) {
//        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
//        menuViewController.modalPresentationStyle = .fullScreen//.custom
////        menuViewController.transitioningDelegate = self
////
////        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
////        presentationAnimator.supportView = navigationController!.navigationBar
////        //presentationAnimator.presentButton = sender
//       present(menuViewController, animated: true, completion: nil)
        
        
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
    
    
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        let row = QuoteDeck.sharedInstance.tagSet.firstIndex(of: identifier) ?? 0
        
        return IndexPath(row: row, section: 0)
    }
    
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        return QuoteDeck.sharedInstance.tagSet[idx.row]
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //tableView.backgroundColor = UIColor(hexString: "#A5DEFF")
        return QuoteDeck.sharedInstance.tagSet.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TopicCellIdentifier)! 
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            cell.textLabel?.textAlignment = .right
        }else{
              cell.textLabel?.textAlignment = .left
        }
        cell.textLabel?.text = "\(QuoteDeck.sharedInstance.quotes[indexPath.row].text.isEmpty ? "" : "\(QuoteDeck.sharedInstance.quotes[indexPath.row].text):") "+QuoteDeck.sharedInstance.tagSet[indexPath.row].capitalized
        
//        cell.layer.cornerRadius = 50
//        cell.layer.borderWidth = CGFloat(12)
//        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
        return cell
    }
    
    func callGallery(){
        
        let urlChapter = URL(string: networkConstants.baseURL+networkConstants.gallery)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "session":networkConstants.session
        ]
        print(parametersChapter)
        let sv = UIViewController.displaySpinner(onView: self.tableView)
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
                        
                        case "no_images":
                            UIViewController.removeSpinner(spinner: sv)
                            self.performSegue(withIdentifier:"galleryFromChapters", sender: nil)
                            ImagesVC.dealWithIt = ImagesVC.imagesForNewGallery
                            ImagesVC.whoSent = "mainGallery"
                            break
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
                    }
//                    }else if gitData.content == nil{
//                        print("Empty Respons   \(gitData)")
//                        UIViewController.removeSpinner(spinner: sv)
//                    }
                    else{
                        print(gitData)
                        ImagesVC.imagesForNewGallery.removeAll()
                        ImagesVC.picz.removeAll()
                        gitData.images?.forEach({u in
                            ImagesVC.imagesForNewGallery.append(u)
                        })
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier:"galleryFromChapters", sender: nil)
                         ImagesVC.dealWithIt = ImagesVC.imagesForNewGallery
                        ImagesVC.whoSent = "mainGallery"
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
    
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 3){
            callGallery()
         return
        }

        //selectedTopic = QuoteDeck.sharedInstance.tagSet[indexPath.row]
        lesonsViewController.lessons.removeAll()
        let urlChapter = URL(string: networkConstants.baseURL+networkConstants.lessons)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "chapter":  LanguageViewController.arrayOfChapterIDs[indexPath.row],
            "session":networkConstants.session
        ]
        let sv = UIViewController.displaySpinner(onView: self.tableView)
        AF.request(urlChapter, method:.post, parameters: parametersChapter, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            switch response.result {

            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(arrayOfLessons.self, from: jsonData)
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
                            
                        case "lessons_list_empty":
                            print("this lesson contains nothing")

                            self.showOkAlert(tit: "EmptyLessonsListTitle", msg: "EmptyLessonsListMessage")

                            break
                        default:
                            print("this is default")
                        }

                    }else{

                        UIViewController.removeSpinner(spinner: sv)
                        gitData.lessonsList!.forEach({ (lesn) in
                            lesonsViewController.lessons.append(lesn)
                        })
                        self.performSegue(withIdentifier:"showLessons", sender: nil)
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

         //self.performSegue(withIdentifier:"showLessons", sender: nil)
    }
}

extension TopicsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .presentation
        return presentationAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .dismissal
        return presentationAnimator
    }
}
