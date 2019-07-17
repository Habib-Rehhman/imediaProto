//
//  Extensions.swift
//
//  Created by Habib on 6/27/19.
//  Copyright © 2019 a. All rights reserved.
//
import UIKit

extension String{
    
    func localizableString(loc: String) -> String {
        
        let path = Bundle.main.path(forResource: loc, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
}

extension UIViewController{
    func rightToLeftAlignment(Views: [UIView]){
        for v in Views{
            if (v is UITextField){
                (v as! UITextField).textAlignment = NSTextAlignment.right
            }
            if (v is UITextView){
                (v as! UITextView).textAlignment = NSTextAlignment.right
            }
            rightToLeftAlignment(Views: v.subviews)
        }
    }
    
    func showOkAlert(tit: String, msg: String){
        let alertController = UIAlertController(title: tit.localizableString(loc: LanguageViewController.buttonName), message: msg.localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    //    func showWrongCredentialsAlert(){
    //        let alertController = UIAlertController(title: "WrongCredAlertTitle".localizableString(loc: LanguageViewController.buttonName), message: "WrongCredAlertMessage".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .alert)
    //        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //
    //        alertController.addAction(defaultAction)
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .whiteLarge)
        ai.color = .black
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}



