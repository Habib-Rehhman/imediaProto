
import UIKit
import Kingfisher

class ZoomedPhotoViewController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
  open var photoIndex: Int!
  var photo: UIImage?
  
    override func viewDidLoad() {
        addNavBarImage()
    }
    override func viewWillAppear(_ animated: Bool) {
        imageView.image = ImagesVC.picz[photoIndex]
        updateConstraintsForSize(view.bounds.size)
        centerImageViewToSuperView()
       
    }
    override func viewDidAppear(_ animated: Bool) {
        imageView.image = ImagesVC.picz[photoIndex]
        updateConstraintsForSize(view.bounds.size)
        centerImageViewToSuperView()
    }
    
    
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
           updateMinZoomScaleForSize(size)
             updateConstraintsForSize(size)
        } else {
            print("Portrait")
             updateMinZoomScaleForSize(size)
             updateConstraintsForSize(size)
        }
    }

   
    @objc func button1Touched(_ sender: UIBarButtonItem) {
//        if(ImagesVC.isSentByMainGallery){
//             self.performSegue(withIdentifier: "associatedPicz", sender: sender)
//        }else{
            self.performSegue(withIdentifier: "associatedPicz", sender: sender)
       // }
    }
    
    @objc func button2Touched(_ sender: UIBarButtonItem) {
        
//        if(ImagesVC.isSentByMainGallery){
//             self.performSegue(withIdentifier: "associatedPicz", sender: sender)
//        }else{
            self.performSegue(withIdentifier: "associatedPicz", sender: sender)
    //    }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            let associated = segue.destination as? AssociatedPhotos,
            id == "associatedPicz" {
            associated.tag = (sender as! UIBarButtonItem).tag
            
            associated.photo = photoIndex
        }
        
    }

    
    fileprivate func addNavBarImage() {
        
        let lab = UIBarButtonItem(title: "labTest", style: .plain, target: self, action: #selector(button1Touched))
        lab.tag = 1
       // lab.tintColor = UIColor(hexString: "#6AA9FF")
        let fake = UIBarButtonItem(title: "fake&original", style: .plain, target: self, action: #selector(button2Touched))
       // fake.tintColor = UIColor(hexString: "#6AA9FF")
        fake.tag = 2
        self.navigationItem.setRightBarButtonItems([lab, fake], animated: true)

    }
    
    
  fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
    let widthScale = size.width / imageView.bounds.width
    let heightScale = size.height / imageView.bounds.height
    let minScale = min(widthScale, heightScale)
    
    scrollView.minimumZoomScale = minScale
    
    scrollView.zoomScale = minScale
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateMinZoomScaleForSize(view.bounds.size)
   centerImageViewToSuperView()
  }
    fileprivate func centerImageViewToSuperView() {
        var zoomFrame = imageView.frame
        
        if(zoomFrame.size.width < scrollView.bounds.size.width) {
            zoomFrame.origin.x = (scrollView.bounds.size.width - zoomFrame.size.width) / 2.0
            
        } else {
            zoomFrame.origin.x = 0.0
            
        }
        
        if(zoomFrame.size.height < scrollView.bounds.size.height) {
            zoomFrame.origin.y = (scrollView.bounds.size.height - zoomFrame.size.height) / 2.0
            
        } else {
            zoomFrame.origin.y = 0.0
            
        }
        
        imageView.frame = zoomFrame
        
    }

  fileprivate func updateConstraintsForSize(_ size: CGSize) {
    
    let yOffset = max(0, (size.height - imageView.frame.height) / 2)
    imageViewTopConstraint.constant = yOffset
    imageViewBottomConstraint.constant = yOffset
    
    let xOffset = max(0, (size.width - imageView.frame.width) / 2)
    imageViewLeadingConstraint.constant = xOffset
    imageViewTrailingConstraint.constant = xOffset
    
    view.layoutIfNeeded()
  }
  
}

extension ZoomedPhotoViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return imageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    updateConstraintsForSize(view.bounds.size)
  }
  
}
