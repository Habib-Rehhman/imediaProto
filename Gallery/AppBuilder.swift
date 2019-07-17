

import UIKit

class AppBuilder {
    public static let shared = AppBuilder()
    func buildBlurViewController() -> BlurViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: type(of: BlurViewController()))) as! BlurViewController
        return viewController
    }
}
