
//

import UIKit
import Kingfisher

class PhotoViewController: UIViewController, UIScrollViewDelegate {
	
    open var photoIndex: Int!
   // var photo: UIImage?
    var segment: UISegmentedControl!
	let pagePadding: CGFloat = 10
	var pagingScrollView: UIScrollView!
	
	var recycledPages: Set<ImageScrollView> = []
	var visiblePages: Set<ImageScrollView> = []
	
	var firstVisiblePageIndexBeforeRotation: Int!
	
	/// single tap for hide / show bar
	var singleTap: UITapGestureRecognizer!
	
	var navigationBarIsHidden: Bool = true

	override func viewDidLoad() {
		super.viewDidLoad()
		 self.navigationController?.navigationBar.backItem?.title = ""
		// single tap to show or hide navigation bar
		self.singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
		self.view.addGestureRecognizer(self.singleTap)
		
		if self.navigationController != nil, !self.navigationController!.navigationBar.isHidden {
			self.navigationBarIsHidden = false
		}
        
        let pagingScrollViewFrame = self.frameForPagingScrollView()
        self.pagingScrollView = UIScrollView(frame: pagingScrollViewFrame)
        self.updateBackgroundColor()
        self.pagingScrollView.showsVerticalScrollIndicator = false
        self.pagingScrollView.showsHorizontalScrollIndicator = false
        self.pagingScrollView.isPagingEnabled = true
        self.pagingScrollView.contentSize = self.contentSizeForPagingScrollView()
        self.pagingScrollView.delegate = self
        self.pagingScrollView.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.pagingScrollView)
        self.layoutPagingScrollView()
        pagingScrollView.setContentOffset(CGPoint(x: pagingScrollView.frame.size.width * CGFloat(photoIndex), y: 0), animated: true)
        self.tilePages()
		addSegments()
	}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            let associated = segue.destination as? AssociatedPhotos,
            id == "associatedPicz" {
            associated.tag = (sender as! UIBarButtonItem).tag
            associated.photo = photoIndex
        }
        
    }
    
    func addNavBarImage() {
        
        let lab = UIBarButtonItem(title: "labTestBtn".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(button1Touched))
        lab.tag = 1
         lab.tintColor = .white//UIColor(hexString: "#6AA9FF")
         lab.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
        let fake = UIBarButtonItem(title: "fake&OriginalBtn".localizableString(loc: LanguageViewController.buttonName), style: .plain, target: self, action: #selector(button2Touched))
        fake.tintColor = .white//UIColor(hexString: "#6AA9FF")
        fake.tag = 2
         fake.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
        self.navigationItem.setRightBarButtonItems([lab, fake], animated: true)
        
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
    
	//MARK: - Tiling and page configuration
	
	func tilePages() {
		// Calculate which pages should now be visible
		let visibleBounds = pagingScrollView.bounds
		
		var firstNeededPageIndex: Int = Int(floor(visibleBounds.minX/visibleBounds.width))
		var lastNeededPageIndex: Int = Int(floor((visibleBounds.maxX - 1)/visibleBounds.width))
		firstNeededPageIndex = max(firstNeededPageIndex, 0)
		lastNeededPageIndex = min(lastNeededPageIndex, self.imageCount - 1)
		
		//Recycle no longer needs pages
		for page in self.visiblePages {
			if page.index < firstNeededPageIndex || page.index > lastNeededPageIndex {
				self.recycledPages.insert(page)
				page.removeFromSuperview()
			}
		}
		self.visiblePages.subtract(self.recycledPages)
		
		//add missing pages
		for index in firstNeededPageIndex...lastNeededPageIndex {
			if !self.isDisplayingPage(forIndex: index) {
				let page = self.dequeueRecycledPage() ?? ImageScrollView()
				
				self.configure(page, for: index)
				self.pagingScrollView.addSubview(page)
				self.visiblePages.insert(page)
				
			}
		}
		
	}
	
	func dequeueRecycledPage() -> ImageScrollView? {
		if let page = self.recycledPages.first {
			self.recycledPages.removeFirst()
			return page
		}
		return nil
	}
	
	
	func isDisplayingPage(forIndex index: Int) -> Bool {
		for page in self.visiblePages {
			if page.index == index {
				return true
			}
		}
		return false
	}
	
	
	func configure(_ page: ImageScrollView, for index: Int) {
		self.singleTap.require(toFail: page.zoomingTap)
		page.backgroundColor = self.view.backgroundColor

		page.index = index
		page.frame = self.frameForPage(at: index)
		page.display(self.image(at: index))
	}
	
	//MARK: - ScrollView delegate methods
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		self.tilePages()
	}
	
	//MARK: - Frame calculations
	
	func frameForPagingScrollView(in size: CGSize? = nil) -> CGRect {
		var frame = UIScreen.main.bounds
		
		if size != nil {
			frame.size = size!
		}
		
		frame.origin.x -= pagePadding
		frame.size.width += 2*pagePadding
		return frame
	}
	
	func contentSizeForPagingScrollView() -> CGSize {
		let bounds = self.pagingScrollView.bounds
		return CGSize(width: bounds.size.width*CGFloat(self.imageCount), height: bounds.size.height)
	}
	
	
	func frameForPage(at index: Int) -> CGRect {
		
		let bounds = self.pagingScrollView.bounds
		var pageFrame = bounds
		pageFrame.size.width -= 2*pagePadding
		pageFrame.origin.x = (bounds.size.width*CGFloat(index)) + pagePadding
		
		return pageFrame
	}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.title = ""
       // addNavBarImage()  note that this controller is initial in story board temporarily
      // segment.removeSegment(at: 0, animated: false)
     
    }
    
    func addSegments(){
        
       segment = UISegmentedControl(items: ["pictures".localizableString(loc: LanguageViewController.buttonName),"labTestBtn".localizableString(loc: LanguageViewController.buttonName), "fake&OriginalBtn".localizableString(loc: LanguageViewController.buttonName)])
        segment.sizeToFit()
        segment.tintColor = .blue//UIColor(red:0.99, green:0.00, blue:0.25, alpha:1.00)
        segment.selectedSegmentIndex = 0;
       // segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "ProximaNova-Light", size: 15)!], for: .normal)
        self.navigationItem.titleView = segment
        
        segment.addTarget(self, action: #selector(segmentedControlValueChanged), for:.valueChanged)
    }
	//MARK: - Rotation Configuration
	
    @objc func segmentedControlValueChanged(segment: UISegmentedControl){
     
        if segment.selectedSegmentIndex == 0 {
            self.updateBackground(to: .black)
            self.imageScrollView.isHidden = true
            self.pagingScrollView.isHidden = false
        }else if(segment.selectedSegmentIndex == 1 ){
            self.updateBackground(to: .white)
            if(self.imageScrollView != nil){ self.imageScrollView.isHidden = true}
            self.pagingScrollView.isHidden = true
            viewDidLoadOfAssociated(photo: photoIndex, tag: 1)
             self.imageScrollView.isHidden = false
          
        }else{
            self.updateBackground(to: .white)
             if(self.imageScrollView != nil){ self.imageScrollView.isHidden = true}
            self.pagingScrollView.isHidden = true
           viewDidLoadOfAssociated(photo: photoIndex, tag: 2)
             self.imageScrollView.isHidden = false
        }
        
    }
    
    
	override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
		self.saveCurrentStatesForRotation()
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		self.restoreStatesForRotation(in: size)
        self.restoreStatesForRotationOfAssociated(in: size)
	}
    
	/**
	Save current page and zooming states for device rotation.
	*/
	func saveCurrentStatesForRotation() {
		let visibleBounds = pagingScrollView.bounds
		firstVisiblePageIndexBeforeRotation = Int(floor(visibleBounds.minX/visibleBounds.width))
	}
	
	/**
	Apply tracked informations for device rotation.
	*/
	func restoreStatesForRotation(in size: CGSize) {
		// recalculate contentSize based on current orientation
		let pagingScrollViewFrame = self.frameForPagingScrollView(in: size)
		pagingScrollView?.frame = pagingScrollViewFrame
		pagingScrollView?.contentSize = self.contentSizeForPagingScrollView()
		
		// adjust frames and configuration of each visible page
		for page in visiblePages {
			let restorePoint = page.pointToCenterAfterRotation()
			let restoreScale = page.scaleToRestoreAfterRotation()
			page.frame = self.frameForPage(at: page.index)
			page.setMaxMinZoomScaleForCurrentBounds()
			page.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
		}
		
		// adjust contentOffset to preserve page location based on values collected prior to location
		var contentOffset = CGPoint.zero
		
		let pageWidth = pagingScrollView?.bounds.size.width ?? 1
		contentOffset.x = (CGFloat(firstVisiblePageIndexBeforeRotation) * pageWidth)
		
		pagingScrollView?.contentOffset = contentOffset
		
	}
	
	//MARK: - Handle Tap
	
	/// Single tap action which hides navigationBar by default implementation
	@objc func handleSingleTap() {
		let duration: TimeInterval = 0.2
		
		if self.navigationController != nil {
			
			if !self.navigationBarIsHidden {
				
				self.navigationBarIsHidden = true
				UIView.animate(withDuration: duration, animations: {
					self.navigationController!.navigationBar.alpha = 0
					self.updateBackgroundColor()

				}, completion: { (finished) in
					self.navigationController!.navigationBar.isHidden = true
				})
				
			}
			else {
				self.navigationBarIsHidden = false
				UIView.animate(withDuration: duration) {
					self.navigationController!.navigationBar.alpha = 1
					self.navigationController!.navigationBar.isHidden = false
					self.updateBackgroundColor()
				}
				
			}
			
		}
	}
	
	/// Update background color. Default is white / black.
	func updateBackgroundColor() {
//        if  !self.navigationBarIsHidden {
//            self.updateBackground(to: .white)
//        }
//        else {
//            self.updateBackground(to: .black)
//        }
	}
	
	func updateBackground(to color: UIColor) {
		self.view.backgroundColor = color
		pagingScrollView?.backgroundColor = color
		
		for page in visiblePages {
			page.backgroundColor = color
		}
	}
	
	
	
	func layoutPagingScrollView() {
		self.pagingScrollView.translatesAutoresizingMaskIntoConstraints = false
		
        let top = NSLayoutConstraint(item: self.pagingScrollView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: self.pagingScrollView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: -10.0)
		
        let bottom = NSLayoutConstraint(item: self.pagingScrollView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        let right = NSLayoutConstraint(item: self.pagingScrollView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 10.0)
		
		self.view.addConstraints([top, left, bottom, right])
	}
	
	
	
	lazy var imageCount: Int = {
        return ImagesVC.picz.count
	}()

	
	// we use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching
	func image(at index: Int) -> UIImage {
        return ImagesVC.picz[index] ?? #imageLiteral(resourceName: "ComingSoon")
	}
	
    func imageSizeAt(index: Int) -> CGSize {
     
        return CGSize(width: ImagesVC.picz[index]!.size.width , height: ImagesVC.picz[index]!.size.height)

    }
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    var imageScrollView: ImageScrollView!
    private let noImage = UIImage(named: "ComingSoon")
    
    
    func viewDidLoadOfAssociated(photo: Int, tag: Int) {
        //"back".localizableString(loc: LanguageViewController.buttonName)
        //1. Initialize imageScrollView and adding it to viewControllers view
        self.imageScrollView = ImageScrollView(frame: self.view.bounds)
        self.view.addSubview(self.imageScrollView)
        self.layoutImageScrollView()
        
        let processor = BlurImageProcessor(blurRadius: 0)
        let placeholderImage = UIImage( #imageLiteral(resourceName: "NowLoading"))
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
        let imageView = UIImageView(image: #imageLiteral(resourceName: "ComingSoon"))
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.backItem?.title = ""
    }
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        super.viewWillTransition(to: size, with: coordinator)
//
//        self.restoreStatesForRotationOfAssociated(in: size)
//    }
    
    
    func restoreStatesForRotation(in bounds: CGRect) {
        // recalculate contentSize based on current orientation
        let restorePoint = imageScrollView.pointToCenterAfterRotation()
        let restoreScale = imageScrollView.scaleToRestoreAfterRotation()
        imageScrollView.frame = bounds
        imageScrollView.setMaxMinZoomScaleForCurrentBounds()
        imageScrollView.restoreCenterPoint(to: restorePoint, oldScale: restoreScale)
    }
    
    func restoreStatesForRotationOfAssociated(in size: CGSize) {
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
