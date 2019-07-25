
//

import UIKit
import Alamofire

class QRScannerViewController: UIViewController {
    
    @IBOutlet weak var scannerView: QRScannerView! {
        didSet {
            scannerView.delegate = self
        }
    }
    @IBOutlet weak var scanButton: UIButton! {
        didSet {
            scanButton.setTitle("STOP", for: .normal)
        }
    }
    
    var qrData: QRData? = nil {
        didSet {
            if qrData != nil {
                let p: Parameters =
                    [
                        "app_id":"com.wikibolics.com",
                        "appstore_id":"com.wikibolics.com",
                        "session":networkConstants.session,
                        "qr_code": qrData!.codeString!
                ]
                let e = networkConstants.baseURL+networkConstants.handleQR
                print(qrData!.codeString!)
                makeRequestToServer(parameters: p, endPointURL: e)
                
                 //self.performSegue(withIdentifier: "detailSeuge", sender: self)
            }
        }
    }
    
    
    
    func makeRequestToServer(parameters: Parameters, endPointURL: String)
    {
        let sv = UIViewController.displaySpinner(onView: self.view)
        let url = URL(string: endPointURL)!
        let header : HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
        
        AF.request(url, method:.post, parameters: parameters, encoding:URLEncoding.default, headers:header).responseJSON(completionHandler:{ response in
            switch response.result {
                
            case .success(let json):
                print(json)
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: json)
                    let decoder = JSONDecoder()
                    let gitData = try decoder.decode(forgotPassword.self, from: jsonData)
                    if(gitData.message != nil){
                        
                        switch gitData.message!{
                            
                        case "subscription_succeeded":
                            self.showToast(message : "QRToast".localizableString(loc: LanguageViewController.buttonName))
                            break
                        case "session_inactive":
                            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                            UserDefaults.standard.removeObject(forKey: "session")
                            UserDefaults.standard.removeObject(forKey: "language")
                            QuoteDeck.sharedInstance.quotes.removeAll()
                            QuoteDeck.sharedInstance.tagSet.removeAll()
                            self.performSegue(withIdentifier: "toAuthBoard", sender: self)
                            break
                        case "qr_code_unrecognized":
                            sv.removeFromSuperview()
                            
                            let alertController = UIAlertController(title: "invalidQR".localizableString(loc: LanguageViewController.buttonName), message: "invalidQRMsg".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
                            let tryAgain = UIAlertAction(title: "tryagain".localizableString(loc: LanguageViewController.buttonName), style: .default) { action in
                                self.scanButtonAction(self.scanButton)
                            }
                            let cancel = UIAlertAction(title: "Cancel".localizableString(loc: LanguageViewController.buttonName), style: .cancel) { action in
                                self.navigationController?.popViewController(animated: true)//.dismiss(animated: true, completion: nil)
                            }
                            alertController.addAction(cancel)
                            alertController.addAction(tryAgain)
                            self.present(alertController, animated: true, completion: nil)
                            
                           
                            break
                        default:
                            
                            break
                            
                        }
                        
                    }else{
                        print("server sent nothing")
                    }
                    
                } catch let err {
                    print("Err", err)
                }
                break
                
            case .failure(let error):
                UIViewController.removeSpinner(spinner: sv)
                self.showOkAlert(tit: "EmptyLessonsListMessage", msg: "EmptyLessonsListMessage")
                print(error.localizedDescription)
                break
            }
            
        })
    }
    
    func showToast(message : String, seconds: Double = 2.0) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15
        
        self.present(alert, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.isHidden = true
    }
    
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !scannerView.isRunning {
            scannerView.startScanning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !scannerView.isRunning {
            scannerView.stopScanning()
        }
    }

    @IBAction func scanButtonAction(_ sender: UIButton) {
        scannerView.isRunning ? scannerView.stopScanning() : scannerView.startScanning()
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        sender.setTitle(buttonTitle, for: .normal)
    }
}


extension QRScannerViewController: QRScannerViewDelegate {
    func qrScanningDidStop() {
        let buttonTitle = scannerView.isRunning ? "STOP" : "SCAN"
        scanButton.setTitle(buttonTitle, for: .normal)
    }
    
    func qrScanningDidFail() {
        presentAlert(withTitle: "Error".localizableString(loc: LanguageViewController.buttonName), message: "scanFailedError".localizableString(loc: LanguageViewController.buttonName))
    }
    
    func qrScanningSucceededWithCode(_ str: String?) {
        self.qrData = QRData(codeString: str)
    }
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
}

