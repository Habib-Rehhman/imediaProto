
import UIKit

class PhotoCell : UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
    
    private let noImage = UIImage(named: "NoImage")
    
    func setErrorImageIfNeeded(error: Error?) {
        if error != nil {
            imageView.image = noImage
            
        }
    }
}
