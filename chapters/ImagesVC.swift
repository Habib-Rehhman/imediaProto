////
////  ImagesVC.swift
////  iMediaProto
////
////  Created by Habib on 7/3/19.
////  Copyright © 2019 a. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
//class ImagesVC: UIViewController{
//
//    @IBOutlet var collectionView: UICollectionView!
//    var pictures = [CollieGalleryPicture]()
//    var numberOfItemsPerRow: CGFloat = 3.0
//    static var newStruct: [imagesStruct] = []
//
//
//    var options = CollieGalleryOptions()
//    private let placeholderImage = UIImage(named: "NowLoading")
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        options.enableSave = false
//
//        let screenSize = UIScreen.main.bounds
//        let screenWidth = screenSize.width
//        _ = screenSize.height
//
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth / 3, height: screenWidth / 3)
//        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionView!.dataSource = self
//        collectionView!.delegate = self
//        collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
//        collectionView!.backgroundColor = UIColor.green
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//       collectionView!.collectionViewLayout = layout
//    }
//
//
//}
//
//extension ImagesVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return ImagesVC.newStruct.count
//    }
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
//    {
//        super.viewWillTransition(to: size, with: coordinator)
//        let offset = self.collectionView?.contentOffset;
//        let width  = self.collectionView?.bounds.size.width;
//
//        let index     = round(offset!.x / width!);
//        let newOffset = CGPoint(x: index * size.width, y: offset!.y)
//
//        self.collectionView?.setContentOffset(newOffset, animated: false)
//
//
//        coordinator.animate(alongsideTransition: { (context) in
//            self.collectionView?.reloadData()
//            self.collectionView?.setContentOffset(newOffset, animated: false)
//        }, completion: nil)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        options.openAtIndex = indexPath.row
//        options.enableInteractiveDismiss = false
//       let gallery = CollieGallery(pictures: pictures, options: options)
//        gallery.presentInViewController(self)
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let leftAndRightPaddings: CGFloat = 60.0
//
//        let width = (collectionView.frame.width-leftAndRightPaddings)/numberOfItemsPerRow
//        return CGSize(width: width, height: width)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//         super.viewWillDisappear(animated)
//        print("called Disappear")
//        for i in 0 ..< pictures.count{
//            pictures[i].labTest = UIImageView()
//            pictures[i].labTest!.kf.indicatorType = .activity
//            pictures[i].labTest!.kf.setImage(with: URL(string: ImagesVC.newStruct[i].labTesting!))
////            {
////                result in
////                switch result {
////                case .success(let value):
////                    //lab: ImagesVC.newStruct[indexPath.row].labTesting)
////                    //fake: ImagesVC.newStruct[indexPath.row].fakeOriginal
////                    let picture = CollieGalleryPicture(image: value.image,fake: nil,lab: nil)
////                    self.pictures.append(picture)
////                    break
////                case .failure(let error):
////                    cell.setErrorImageIfNeeded(error: error)
////                    let pic = CollieGalleryPicture(image: UIImage(named: "NoImage")!,fake: nil,lab: nil)
////                    self.pictures.append(pic)
////                }
////            }
//        }
//    }
//
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        if (UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft || UIDevice.current.orientation == UIDeviceOrientation.landscapeRight) {
//            numberOfItemsPerRow = 6.0
//        } else {
//            numberOfItemsPerRow = 3.0
//        }
//
//        collectionView!.collectionViewLayout.invalidateLayout()
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
//
//        let processor = BlurImageProcessor(blurRadius: 0) // Blur with a radius
////        cell.imageView.kf.setImage(with: ImagesVC.newStruct[indexPath.row].image, placeholder: placeholderImage, options: [.transition(.fade(5.0)), .processor(processor)], progressBlock: nil, completionHandler: { (image, error, cachType, url) in
////            if(image != nil){
////                let picture = CollieGalleryPicture(image: image!,fake: ImagesVC.newStruct[indexPath.row].fakeOriginal,lab: ImagesVC.newStruct[indexPath.row].labTesting)
////                self.pictures.append(picture)
////            }else{
////                cell.setErrorImageIfNeeded(error: error)
////                let pic = CollieGalleryPicture(image: UIImage(named: "NoImage")!)
////                self.pictures.append(pic)
////            }
////
////        })
//
////        cell.imageView.kf.indicatorType = .activity
//        cell.imageView.kf.setImage(
//            with: ImagesVC.newStruct[indexPath.row].image,
//            placeholder: placeholderImage,
//            options:[.transition(.fade(5.0)), .processor(processor)])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                //lab: ImagesVC.newStruct[indexPath.row].labTesting)
//                //fake: ImagesVC.newStruct[indexPath.row].fakeOriginal
//                let picture = CollieGalleryPicture(image: value.image,fake: nil,lab: nil)
//                    self.pictures.append(picture)
//                break
//            case .failure(let error):
//                cell.setErrorImageIfNeeded(error: error)
//                let pic = CollieGalleryPicture(image: UIImage(named: "NoImage")!,fake: nil,lab: nil)
//                self.pictures.append(pic)
//            }
//        }
//        return cell
//    }
//}
//


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
    fileprivate let thumbnailSize = CGSize(width: 70.0, height: 70.0)
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 5.0, bottom: 10.0, right: 5.0)
    
    var indx: Int?
    
    override func viewDidLoad() {

        if(ImagesVC.whoSent == "mainGallery"){
            addNavBarImage()
        }
        ImagesVC.dealWithIt?.forEach({_ in ImagesVC.picz.append(nil)})
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           indx = indexPath.row
           self.performSegue(withIdentifier: "zoom", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            let zoomedPhotoViewController = segue.destination as? ZoomedPhotoViewController,
            id == "zoom" {
            zoomedPhotoViewController.photoIndex = indx
        }
        
    }
}

// MARK: UICollectionViewDataSource
extension ImagesVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImagesVC.dealWithIt!.count
    }
    
    
    fileprivate func addNavBarImage() {
        
        let lab = UIBarButtonItem(title: "By Brands", style: .plain, target: self, action: #selector(brandsTouched))
        lab.tag = 1
        // lab.tintColor = UIColor(hexString: "#6AA9FF")
        let fake = UIBarButtonItem(title: "By Composition", style: .plain, target: self, action: #selector(compositionTouched))
        // fake.tintColor = UIColor(hexString: "#6AA9FF")
        fake.tag = 2
        self.navigationItem.setRightBarButtonItems([lab, fake], animated: true)
        
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
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            
                        }else{
                            UIViewController.removeSpinner(spinner: sv)
                            
                            self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                        }
                    }else if(gitData.brandsList != nil){
                        
                        UIViewController.removeSpinner(spinner: sv)
                        SortedTableVC.titleOfBar = "By Brands"
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
                        SortedTableVC.titleOfBar = "By Compositions"
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


