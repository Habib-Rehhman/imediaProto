

import UIKit

/// Class used to represent a picture in the gallery
open class CollieGalleryPicture: NSObject {
    
    // MARK: - Internal properties
    internal var image: UIImage!
    internal var url: String!
    internal var placeholder: UIImage?
    internal var title: String?
    internal var caption: String?
    internal var fakeURL: UIImageView?
    internal var labTest: UIImageView?
    
    
    public convenience init(image: UIImage, fake: UIImageView?, lab: UIImageView?, title: String? = nil, caption: String? = nil) {
        self.init()
        self.image = image
        self.title = title
        self.caption = caption
        self.fakeURL = fake
        self.labTest = lab
    }
    

    public convenience init(url: String, placeholder: UIImage? = nil, title: String? = nil, caption: String? = nil) {
        self.init()
        self.url = url
        self.placeholder = placeholder
        self.title = title
        self.caption = caption
  
    }
}
