
//

import UIKit
//import Kingfisher
import Alamofire

class SortedTableVC: UITableViewController {

    let cellId = "cellId123123"

    static var receivedAlphabetCharactersForHeader: [String?] = []
   // static var twoDimensionalArray: [[String?]?] = []
    static var brandOrCompositionsData: [[brands?]?] = []
    static var titleOfBar: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = SortedTableVC.titleOfBar
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = SortedTableVC.receivedAlphabetCharactersForHeader[section]//"Header"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = UIColor(hexString: "#6AA9FF")
        return label
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return SortedTableVC.twoDimensionalArray.count
        return SortedTableVC.brandOrCompositionsData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      //  return SortedTableVC.twoDimensionalArray[section]!.count
         return SortedTableVC.brandOrCompositionsData[section]!.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        callGallery(item: SortedTableVC.brandOrCompositionsData[indexPath.section]![indexPath.row]!.id!, itemType: (SortedTableVC.titleOfBar?.contains("Brands"))! ? "item_brand" : "item_composition")
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let name = SortedTableVC.brandOrCompositionsData[indexPath.section]![indexPath.row]!.name
        
        cell.textLabel?.text = name
        
        return cell
    }
    
    func callGallery(item: String, itemType: String){
        
        let urlChapter = URL(string: networkConstants.baseURL+networkConstants.galleryOfBrandAndCompositions)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "session":networkConstants.session,
            "item": item,
            "item_type": itemType
        ]
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
                            
                        case "session_inactive":
                            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                            UserDefaults.standard.removeObject(forKey: "session")
                            UserDefaults.standard.removeObject(forKey: "language")
                            QuoteDeck.sharedInstance.quotes.removeAll()
                            QuoteDeck.sharedInstance.tagSet.removeAll()
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            break
                            
                        case "no_images":
                            UIViewController.removeSpinner(spinner: sv)
                            self.showOkAlert(tit: "brandCompoNoImages", msg: "")
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
                    else{
                        print(gitData)
                        ImagesVC.imagesForBrandComposition.removeAll()
                        ImagesVC.picz.removeAll()
                        gitData.images?.forEach({u in
                            ImagesVC.imagesForBrandComposition.append(u)
                        })
                        UIViewController.removeSpinner(spinner: sv)
                        self.performSegue(withIdentifier:"rowofBrandsSelectedForGallery", sender: nil)
                        ImagesVC.dealWithIt = ImagesVC.imagesForBrandComposition
                        ImagesVC.whoSent = "sortedVC"
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








