////
////  ImagesVC.swift
////  iMediaProto
////
////  Created by Habib on 7/3/19.
////  Copyright © 2019 a. All rights reserved.

import Alamofire
import UIKit
import Kingfisher

class ImagesVC: UICollectionViewController {
    
    static var picz: [UIImage?] = []
   // static var chapterGallerPicz: [UIImage] = []
    static var newStruct: [imagesStruct] = []
    
    static var imagesForNewGallery: [imagesStruct] = []
    static var imagesForBrandComposition: [imagesStruct] = []
    static  var whoSent: String?
    static var dealWithIt: [imagesStruct]?
    
    fileprivate let reuseIdentifier = "PhotoCell"
    fileprivate let thumbnailSize = CGSize(width: 90.0, height: 100.0)
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 5.0, bottom: 10.0, right: 5.0)
    
    var indx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationController?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        if(ImagesVC.whoSent == "mainGallery"){
            addNavBarImage()
        }
        ImagesVC.dealWithIt?.forEach({_ in ImagesVC.picz.append(nil)})
        
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 25)
        messageLabel.sizeToFit()
        
        self.collectionView.backgroundView = messageLabel;
    }
    
    func restore() {
        self.collectionView.backgroundView = nil
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           indx = indexPath.row
           
           self.performSegue(withIdentifier: "zoom", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            let photoViewController = segue.destination as? PhotoViewController,
            id == "zoom" {
            photoViewController.photoIndex = indx
        }
        
    }
}

// MARK: UICollectionViewDataSource
extension ImagesVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if (ImagesVC.dealWithIt!.count == 0) {
            setEmptyMessage("No Images to show :(")
        } else {
             restore()
        }
        
        return ImagesVC.dealWithIt!.count
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = ""
    }
    
    fileprivate func addNavBarImage() {
        
        let lab = UIBarButtonItem(title: "byBrands".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(brandsTouched))
        lab.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
        lab.width = 5
        lab.tag = 1
         lab.tintColor = .white//UIColor(hexString: "#6AA9FF")
        let fake = UIBarButtonItem(title: "byComposition".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(compositionTouched))
         fake.tintColor = .white//UIColor(hexString: "#6AA9FF")
         fake.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
        fake.width = 5
        fake.tag = 2
        self.navigationItem.setRightBarButtonItems([fake, lab], animated: true)
    }
    
    @objc func brandsTouched(_ sender: UIBarButtonItem) {
        loadData(url: URL(string: networkConstants.baseURL+networkConstants.brands)!)

    }
    
    @objc func compositionTouched(_ sender: UIBarButtonItem) {
        
         loadData(url: URL(string: networkConstants.baseURL+networkConstants.compositions)!)
        
    }
    func loadData(url: URL){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        //let urlChapter = URL(string: networkConstants.baseURL+networkConstants.nextToLogin)!//"https://reqres.in/api/login")!
        
        let parametersChapter:Parameters = [
            "app_id":"com.wikibolics.com",
            "appstore_id":"com.wikibolics.com",
            "session":networkConstants.session
        ]
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        AF.request(url, method:.post, parameters: parametersChapter, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            //    print("its sess::: \(gitData.loginSession!)@d4:61:9d:21:ea:f4")
            switch response.result {
                
            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(arrayOfBrands.self, from: jsonData)
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
                    }else if(gitData.brandsList != nil){
                        
                        UIViewController.removeSpinner(spinner: sv)
                        SortedTableVC.titleOfBar = "byBrands".localizableString(loc: LanguageViewController.buttonName)
                        self.parseList(arr: gitData.brandsList!)
                        
//                        for i in 0...1{
//                             if(i == 0){
//                                gitData.brandsList!.forEach({brand in
//                                if(!SortedTableVC.receivedAlphabetCharactersForHeader.contains(String(brand.name.first!))){ SortedTableVC.receivedAlphabetCharactersForHeader.append(String(brand.name.first!))
//                                SortedTableVC.twoDimensionalArray.append([])
//                                }
//                            })
//                             }else{
//                                gitData.brandsList!.forEach({ (brand) in
//                                    SortedTableVC.twoDimensionalArray[SortedTableVC.receivedAlphabetCharactersForHeader.firstIndex(of: String(brand.name.first!)) ?? 27]!.append(brand.name)
//                                })
//                            }
//                        }
//                        self.performSegue(withIdentifier: "sortedTableView", sender: nil)
                        
                    }else{
                        UIViewController.removeSpinner(spinner: sv)
                        SortedTableVC.titleOfBar = "byComposition".localizableString(loc: LanguageViewController.buttonName)
                        self.parseList(arr: gitData.compositionsList!)
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
    
    
    func parseList(arr: [brands]){
        
        SortedTableVC.receivedAlphabetCharactersForHeader.removeAll()
        //SortedTableVC.twoDimensionalArray.removeAll()
        SortedTableVC.brandOrCompositionsData.removeAll()
        for i in 0...1{
            if(i == 0){
                arr.forEach({brand in
                    if(!SortedTableVC.receivedAlphabetCharactersForHeader.contains(String(brand.name.first!))){ SortedTableVC.receivedAlphabetCharactersForHeader.append(String(brand.name.first!))
                        //SortedTableVC.twoDimensionalArray.append([])
                        SortedTableVC.brandOrCompositionsData.append([])
                    }
                })
            }else{
//                arr.forEach({ (brand) in
//                    SortedTableVC.twoDimensionalArray[SortedTableVC.receivedAlphabetCharactersForHeader.firstIndex(of: String(brand.name.first!)) ?? 27]!.append(brand.name)
//                })
                
                arr.forEach({ (brand) in
                    SortedTableVC.brandOrCompositionsData[SortedTableVC.receivedAlphabetCharactersForHeader.firstIndex(of: String(brand.name.first!)) ?? 27]!.append(brand)//.append(brand.name)
                })
            }
        }
        self.performSegue(withIdentifier: "sortedTableView", sender: nil)
        
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        
                let processor = BlurImageProcessor(blurRadius: 0)
                let placeholderImage = UIImage(named: "NowLoading")
        
        cell.imageView.kf.setImage(
                        with: URL(string: ImagesVC.dealWithIt![indexPath.row].image!),
                        placeholder: placeholderImage,
                        options:[.transition(.fade(5.0)), .processor(processor)])
                    {
                        result in
                        switch result {
                       case .success(let value):
                     
                        ImagesVC.picz[indexPath.row] = value.image
                            break
                        case .failure(let error):
                   
                        cell.setErrorImageIfNeeded(error: error)
                  
                        }
                    }
        return cell
    }
}

// MARK:UICollectionViewDelegateFlowLayout
extension ImagesVC : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return thumbnailSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}


