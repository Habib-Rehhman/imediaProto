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
    
    @IBOutlet weak var fifthBtn: UIButton!
    @IBOutlet weak var fourthBtn: UIButton!
    @IBOutlet weak var thrdBtn: UIButton!
    @IBOutlet weak var secBtn: UIButton!
    @IBOutlet weak var firstBtn: UIButton!
    var dismissButton: UIButton?
    var titleLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBottomBorder(sender: firstBtn)
        changeBottomBorder(sender: secBtn)
        changeBottomBorder(sender: thrdBtn)
        changeBottomBorder(sender: fourthBtn)
        //   changeBottomBorder(sender: fifthBtn)
        dismissButton = {
            let button = UIButton(frame: .zero)
            button.setImage(UIImage(named: "ic_menu"), for: .normal)
            button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
            return button
        }()
        
        titleLabel = {
            let label = UILabel()
            label.numberOfLines = 1;
            label.text = ""
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Menu: viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Menu: viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("Menu: viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Menu: viewDidDisappear")
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        switch (sender.tag){
            
        case 1:
            let a = UIAlertController(title: "Privacy Policy", message: "policy Contentjkewfgjkaweh,dewhjfg wefgdhjwe,df,wevhjf,yewJCHVE,WJYFVEHWMVFJH,WEDFQEJHVQEWJHFV,Whdfj3fdevwBweFWEMHFVQEJMWHGFGQJEWVFEJWQMDFEJWVD,HVCEWM RXJYEMFEWHMFVJHEWFGJQWY,RFVQEWHFVQWMJQHFVEWJ,YFQWER,MQEYWJFQUYEWFVWEYDVEMYJRFQ4EFJV DFYFREJFV   YGFYFUMFDY3UJDFTUYDUTDMU3DVUKY2DFU2FDTJD32J23YB3UYR3UYRJEWMDFQJYFUQ23JFR2JEDF   2UY3RFKYEFWD    Y23RRFUY23FRJY  MF  U23RJ23U6G2Q3UYJR23U23TYURQTJERFUU32E   HFJF2JRFKU3TFQ32RKUF23KURFQ23URF23URF32TR policy Contentjkewfgjkaweh,dewhjfg wefgdhjwe,df,wevhjf,yewJCHVE,WJYFVEHWMVFJH,WEDFQEJHVQEWJHFV,Whdfj3fdevwBweFWEMHFVQEJMWHGFGQJEWVFEJWQMDFEJWVD,HVCEWM RXJYEMFEWHMFVJHEWFGJQWY,RFVQEWHFVQWMJQHFVEWJ,YFQWER,MQEYWJFQUYEWFVWEYDVEMYJRFQ4EFJV DFYFREJFV   YGFYFUMFDY3UJDFTUYDUTDMU3DVUKY2DFU2FDTJD32J23YB3UYR3UYRJEWMDFQJYFUQ23JFR2JEDF   2UY3RFKYEFWD    Y23RRFUY23FRJY  MF  U23RJ23U6G2Q3UYJR23U23TYURQTJERFUU32E   HFJF2JRFKU3TFQ32RKUF23KURFQ23URF23URF32TR policy Contentjkewfgjkaweh,dewhjfg wefgdhjwe,df,wevhjf,yewJCHVE,WJYFVEHWMVFJH,WEDFQEJHVQEWJHFV,Whdfj3fdevwBweFWEMHFVQEJMWHGFGQJEWVFEJWQMDFEJWVD,HVCEWM RXJYEMFEWHMFVJHEWFGJQWY,RFVQEWHFVQWMJQHFVEWJ,YFQWER,MQEYWJFQUYEWFVWEYDVEMYJRFQ4EFJV DFYFREJFV   YGFYFUMFDY3UJDFTUYDUTDMU3DVUKY2DFU2FDTJD32J23YB3UYR3UYRJEWMDFQJYFUQ23JFR2JEDF   2UY3RFKYEFWD    Y23RRFUY23FRJY  MF  U23RJ23U6G2Q3UYJR23U23TYURQTJERFUU32E   HFJF2JRFKU3TFQ32RKUF23KURFQ23URF23URF32TR policy Contentjkewfgjkaweh,dewhjfg wefgdhjwe,df,wevhjf,yewJCHVE,WJYFVEHWMVFJH,WEDFQEJHVQEWJHFV,Whdfj3fdevwBweFWEMHFVQEJMWHGFGQJEWVFEJWQMDFEJWVD,HVCEWM RXJYEMFEWHMFVJHEWFGJQWY,RFVQEWHFVQWMJQHFVEWJ,YFQWER,MQEYWJFQUYEWFVWEYDVEMYJRFQ4EFJV DFYFREJFV   YGFYFUMFDY3UJDFTUYDUTDMU3DVUKY2DFU2FDTJD32J23YB3UYR3UYRJEWMDFQJYFUQ23JFR2JEDF   2UY3RFKYEFWD    Y23RRFUY23FRJY  MF  U23RJ23U6G2Q3UYJR23U23TYURQTJERFUU32E   HFJF2JRFKU3TFQ32RKUF23KURFQ23URF23URF32TR", preferredStyle: .actionSheet)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            a.addAction(defaultAction)
            self.present(a, animated: true, completion: nil)
            break
        case 2:
            
            break
        case 3:
            
            break
        case 4:
            UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
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
