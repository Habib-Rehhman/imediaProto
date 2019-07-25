//  FirstBtnC.swift
//  iMediaProto
//
//  Created by Habib on 7/1/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit

enum menuItems{
    case Profile
    
}

class MenuViewController: UIViewController, GuillotineMenu {
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var aboutUs: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        renderLanguage()
        changeBottomBorder(sender: privacyPolicyBtn)
        //changeBottomBorder(sender: closeBtn)
        changeBottomBorder(sender: signOutBtn)
        changeBottomBorder(sender: aboutUs)
        changeBottomBorder(sender: settingBtn)
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.textColor = UIColor.white
            label.sizeToFit()
            return label
        }()
    }
    
    func changeBottomBorder(sender: UIButton) {
        let lineView = UIView(frame: CGRect(x: 0, y: sender.frame.size.height, width: sender.frame.size.width, height: 2))
        lineView.backgroundColor = UIColor.white
        sender.addSubview(lineView)
    }
    
    
    func renderLanguage(){
        
        if(LanguageViewController.buttonName ==  "ar" || LanguageViewController.buttonName ==  "fa-IR"){
            rightToLeftAlignment(Views: self.view.subviews)
        }
        closeBtn.setTitle("close".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        signOutBtn.setTitle("signOut".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        privacyPolicyBtn.setTitle("PrivacyPolicy".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        settingBtn.setTitle("settings".localizableString(loc: LanguageViewController.buttonName), for: .normal)
        
        aboutUs.setTitle("AboutUs".localizableString(loc: LanguageViewController.buttonName), for: .normal)
    }

    
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        switch (sender.tag){
            
        case 1:
            let a = UIAlertController(title: "PrivacyPolicy".localizableString(loc: LanguageViewController.buttonName), message: "privacyText".localizableString(loc: LanguageViewController.buttonName), preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK".localizableString(loc: LanguageViewController.buttonName), style: .cancel, handler: nil)
            a.addAction(defaultAction)
            self.present(a, animated: true, completion: nil)
            break
        case 2:
            
            break
        case 3:
            
            break
        case 4:
            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
            LanguageViewController.arrayOfChapterIDs.removeAll()
            QuoteDeck.sharedInstance.quotes.removeAll()
            QuoteDeck.sharedInstance.tagSet.removeAll()
            performSegue(withIdentifier: "loggingOut", sender: nil)
            break
        default:
            print("nothing")
        }
        self.performSegue(withIdentifier: "bnbn", sender: sender)
    }
    
    @IBAction func closeMenu(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    
}

extension MenuViewController: GuillotineAnimationDelegate {
    
    func animatorDidFinishPresentation(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishPresentation")
    }
    func animatorDidFinishDismissal(_ animator: GuillotineTransitionAnimation) {
        print("menuDidFinishDismissal")
    }
    
    func animatorWillStartPresentation(_ animator: GuillotineTransitionAnimation) {
        print("willStartPresentation")
    }
    
    func animatorWillStartDismissal(_ animator: GuillotineTransitionAnimation) {
        print("willStartDismissal")
        
    }
}
