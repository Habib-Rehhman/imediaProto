//
//  AssociatedPhotos.swift
//  iMediaProto
//
//  Created by Habib on 7/15/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit
import Kingfisher

class AssociatedPhotos: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    open var photo: Int!
    open var tag: Int!
    private let noImage = UIImage(named: "ComingSoon")
    
    
    override func viewWillAppear(_ animated: Bool) {
        let processor = BlurImageProcessor(blurRadius: 0)
        let placeholderImage = UIImage(named: "NowLoading")
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
        imageView.kf.setImage(
            with: url,
            placeholder: placeholderImage,
            options:[.transition(.fade(5.0)), .processor(processor)])
        {
            result in
            switch result {
            case .failure(_):
                self.imageView.image = self.noImage
                self.updateConstraintsForSize((self.view.bounds.size))
                self.centerImageViewToSuperView()
                break
                
            case .success(_):
                self.updateConstraintsForSize((self.view.bounds.size))
                self.centerImageViewToSuperView()
                break
            }
        }
        updateConstraintsForSize((self.view.bounds.size))
        centerImageViewToSuperView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            updateMinZoomScaleForSize(size)
            updateConstraintsForSize(size)
        } else {
            updateMinZoomScaleForSize(size)
            updateConstraintsForSize(size)
        }
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

extension AssociatedPhotos: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
}
