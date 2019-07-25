//
//import UIKit
//import Kingfisher
//
//class ZoomedPhotoViewController: UIViewController, UIScrollViewDelegate {
// 
//  @IBOutlet weak var scrollView: UIScrollView!
//  open var photoIndex: Int!
//  //var photo: UIImage?
//  
//    override func viewDidLoad() {
//        
//        scrollView.isPagingEnabled = true
//        self.navigationController?.navigationBar.backItem?.title = ""//"backBtn".localizableString(loc: LanguageViewController.buttonName)
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.showsHorizontalScrollIndicator = false
//        scrollView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        addNavBarImage()
//        setupImages()
//    }
//
//    func thisImage(i: Int){
//        let imageView = UIImageView()
//        imageView.image = ImagesVC.picz[i]
//        let xPosition = UIScreen.main.bounds.width * CGFloat(i)
//        imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
//        imageView.contentMode = .scaleAspectFit
//        
//        scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
//        scrollView.addSubview(imageView)
//    }
//
//    func setupImages(){
//    
//        for i in 0..<ImagesVC.picz.count{
//            thisImage(i: i)
//        }
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.title = ""
//        self.navigationController?.navigationBar.backItem?.title = ""
//    }
//  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//        //centerImageViewToSuperView()
//        if UIDevice.current.orientation.isLandscape {
//         //  updateMinZoomScaleForSize(size)
//           //  updateConstraintsForSize(size)
//        } else {
//            print("Portrait")
//             //updateMinZoomScaleForSize(size)
//             //updateConstraintsForSize(size)
//        }
//    }
//
//   
//    @objc func button1Touched(_ sender: UIBarButtonItem) {
////        if(ImagesVC.isSentByMainGallery){
////             self.performSegue(withIdentifier: "associatedPicz", sender: sender)
////        }else{
//            self.performSegue(withIdentifier: "associatedPicz", sender: sender)
//       // }
//    }
//    
//    @objc func button2Touched(_ sender: UIBarButtonItem) {
//        
////        if(ImagesVC.isSentByMainGallery){
////             self.performSegue(withIdentifier: "associatedPicz", sender: sender)
////        }else{
//            self.performSegue(withIdentifier: "associatedPicz", sender: sender)
//    //    }
//        
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let id = segue.identifier,
//            let associated = segue.destination as? AssociatedPhotos,
//            id == "associatedPicz" {
//            associated.tag = (sender as! UIBarButtonItem).tag
//            
//            associated.photo = photoIndex
//        }
//        
//    }
//
//    fileprivate func addNavBarImage() {
//        
//        let lab = UIBarButtonItem(title: "labTestBtn".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(button1Touched))
//        lab.tag = 1
//         lab.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
//        lab.tintColor = .white//UIColor(hexString: "#6AA9FF")
//        let fake = UIBarButtonItem(title: "fake&OriginalBtn".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(button2Touched))
//        fake.tintColor = .white//UIColor(hexString: "#6AA9FF")
//        fake.tag = 2
//         fake.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
//        self.navigationItem.setRightBarButtonItems([lab, fake], animated: true)
//
//    }
//    
//
//  
//}
//
