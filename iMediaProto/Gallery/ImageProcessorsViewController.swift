

import UIKit

class ImageProcessorsViewController: UIViewController {
//    @IBOutlet var tableView: UITableView!

    enum ImageProcessor: CustomStringConvertible {
        case blur
        var description: String {
            switch self {
            case .blur: return "BlurImage Processor"
            }
        }
    }

    private let processors = [
        ImageProcessor.blur
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        //let vc = AppBuilder.shared.buildBlurViewController()
        //navigationController?.pushViewController(vc, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
