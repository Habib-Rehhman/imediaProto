

import UIKit
import Kingfisher

class AssociatedPhotos: UIViewController{
    
    var imageScrollView: ImageScrollView!
    open var photo: Int!
    open var tag: Int!
    private let noImage = UIImage(named: "ComingSoon")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         //"back".localizableString(loc: LanguageViewController.buttonName)
        //1. Initialize imageScrollView and adding it to viewControllers view
        self.imageScrollView = ImageScrollView(frame: self.view.bounds)
        self.view.addSubview(self.imageScrollView)
        self.layoutImageScrollView()
        
        let processor = BlurImageProcessor(blurRadius: 0)
        let placeholderImage = UIImage( #imageLiteral(resourceName: "applogo"))
        var url: URL?
        switch tag {
        case 1:
            url = URL(string: ImagesVC.dealWithIt![photo].labTesting!)
            break
        case 2:
            url = URL(string: ImagesVC.dealWithIt![photo].fakeOriginal!)
            break
        default:
            break
            
        }
        let imageView = UIImageView(image: #imageLiteral(resourceName: "applogo"))
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options:[.transition(.fade(5.0)), .processor(processor)])
        {
            result in
            switch result {
            case .failure(_):
                self.imageScrollView.display(#imageLiteral(resourceName: "applogo"))
                break
                
            case .success(let value):
                self.imageScrollView.display(value.image)
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = ""
         self.navigationController?.navigationBar.backItem?.title = ""
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.navigationController?.navigationBar.backItem?.title = ""
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.restoreStatesForRotation(in: size)
    }
    
    
    func restoreStatesForRotation(in bounds: CGRect) {
        // recalculate contentSize based on current orientation
        let restorePoint = imageScrollView.pointToCenterAfterRotation()
        let restoreScale = imageScrollView.scaleToRestoreAfterRotation()
        imageScrollView.frame = bounds
        imageScrollView.setMaxMinZoomScaleForCurrentBounds()
        imageScrollView.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
    }
    
    func restoreStatesForRotation(in size: CGSize) {
        var bounds = self.view.bounds
        if bounds.size != size {
            bounds.size = size
            self.restoreStatesForRotation(in: bounds)
        }
    }
    
    
    func layoutImageScrollView() {
        self.imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let top = NSLayoutConstraint(item: self.imageScrollView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: self.imageScrollView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0)
        
        let bottom = NSLayoutConstraint(item: self.imageScrollView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.imageScrollView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0)
        
        self.view.addConstraints([top, left, bottom, right])
    }
    
    
}
