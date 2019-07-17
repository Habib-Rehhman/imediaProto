
import UIKit

class QuoteViewController : UIViewController {
    
    // MARK: - Constants
    
    private struct Key {
        static let CurrentQuoteIndex = "CurrentQuoteIndex"
        static let Topic = "Topic"
    }
    
    private struct Storyboard {
        static let QuoteOfTheDayTitle = ""
        static let ShowTopicsSegueIdentifier = "ShowTopics"
        static let TopicsTitle = "Topics"
    }
    
    
    // @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var textView: UITextView!
    // MARK: - Properties
    
    var currentQuoteIndex = 0
    var topic: String?
    var quotes: [Quote]!
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Helpers
    
    
    private func updateUIByToggling() {
        
        if let topicFilter = topic {
            
            
            let fadeTextAnimation = CATransition()
            
            fadeTextAnimation.duration = 0.75
            fadeTextAnimation.type = CATransitionType.fade
            
            navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
            navigationItem.title = "\(topicFilter.capitalized)"
        }
    }
    
    private func updateUI() {
        let quote = quotes[currentQuoteIndex]
        
        if let topicFilter = topic {
            title = "\(topicFilter.capitalized)"
        } else {
            title = Storyboard.QuoteOfTheDayTitle
        }
        textView.text = quote.text
    }
    
}
