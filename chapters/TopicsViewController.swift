
//
import UIKit
import Alamofire

class TopicsViewController : UITableViewController, UIDataSourceModelAssociation {
    
    @IBOutlet fileprivate var barButton: UIBarButtonItem!
    fileprivate lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    // MARK: - Constants
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    private struct Storyboard {
        static let TopicCellIdentifier = "TopicCell"
        static let ShowQuoteSegueIdentifier = "ShowQuote"
    }
    
    @IBAction func showMenuAction(_ sender: UIBarButtonItem) {
        let menuViewController = storyboard!.instantiateViewController(withIdentifier: "MenuViewController")
        menuViewController.modalPresentationStyle = .fullScreen//.custom
//        menuViewController.transitioningDelegate = self
//
//        presentationAnimator.animationDelegate = menuViewController as? GuillotineAnimationDelegate
//        presentationAnimator.supportView = navigationController!.navigationBar
//        //presentationAnimator.presentButton = sender
       present(menuViewController, animated: true, completion: nil)
    }
    
   // var selectedTopic: String?
    

    
    
    func indexPathForElement(withModelIdentifier identifier: String, in view: UIView) -> IndexPath? {
        let row = QuoteDeck.sharedInstance.tagSet.firstIndex(of: identifier) ?? 0
        
        return IndexPath(row: row, section: 0)
    }
    
    func modelIdentifierForElement(at idx: IndexPath, in view: UIView) -> String? {
        return QuoteDeck.sharedInstance.tagSet[idx.row]
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundColor = UIColor(hexString: "#A5DEFF")
        return QuoteDeck.sharedInstance.tagSet.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.TopicCellIdentifier)! 
        
        cell.textLabel?.text = QuoteDeck.sharedInstance.tagSet[indexPath.row].capitalized
        
        cell.layer.cornerRadius = 50
        cell.layer.borderWidth = CGFloat(12)
        cell.layer.borderColor = tableView.backgroundColor?.cgColor
        
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
            "chapter": "\(indexPath.row+1)",
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
                    let gitData = try decoder.decode(arrayOfLessons.self, from: jsonData)
                    if(gitData.message != nil){
                        UIViewController.removeSpinner(spinner: sv)
                        switch gitData.message!{

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
