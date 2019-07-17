
import UIKit
import Kingfisher
//import CollieGallery

class BlurViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var pictures = [CollieGalleryPicture]()
    var jsonURLs = [
        URL(string: "https://pixel.nymag.com/imgs/daily/science/2016/05/20/20-emily-ratajkowski.w710.h473.2x.jpg"),
            URL(string: "http://2.bp.blogspot.com/-iF3brsnl-Pg/T3qU1f_slOI/AAAAAAAABuI/UGAWVL2nzt8/s1600/Beautiful+Evening+Paographs+2.jpg"),
        URL(string: "https://www.bpsalon.com/wp-content/uploads/2017/10/beauty-salon-89790-900.jpg"),
        URL(string: "https://cdn.images.express.co.uk/img/dynamic/130/590x/beautiful-people-elite-dating-website-545400.jpg"),
        URL(string: "https://viola.bz/wp-content/uploads/2012/04/Beautiful-People-1.jpg"),
        URL(string: "https://images.all-free-download.com/images/graphiclarge/beautiful_evening_pier_picture_165879.jpg"),
        URL(string: "https://mandeephooda.files.wordpress.com/2013/07/2048.jpg"),
    
    ]
    private let placeholderImage = UIImage(named: "NowLoading")
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension BlurViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsonURLs.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
   
                let gallery = CollieGallery(pictures: pictures)
                gallery.presentInViewController(self)
                gallery.scrollToIndex(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
            let processor = BlurImageProcessor(blurRadius: 0) // Blur with a radius
            cell.imageView.kf.setImage(with: jsonURLs[indexPath.row], placeholder: placeholderImage, options: [.transition(.fade(5.0)), .processor(processor)], progressBlock: nil, completionHandler: { (image, error, cachType, url) in
                if(image != nil){
                let picture = CollieGalleryPicture(image: image!, fake: nil, lab: nil)//(image: image!)
                self.pictures.append(picture)
                }else{
                cell.setErrorImageIfNeeded(error: error)
                let pic = CollieGalleryPicture(image: UIImage(named: "NoImage")!, fake: nil, lab: nil)
                self.pictures.append(pic)
                }
                
            })
        
        return cell
    }
}
