//
//  WebVC.swift
//  iMediaProto
//
//  Created by Habib on 7/2/19.
//  Copyright © 2019 a. All rights reserved.
//

import WebKit

class WebVC : UIViewController{
    
    @IBOutlet weak var imgBtn: UIBarButtonItem!
    
    @IBOutlet weak var webV: WKWebView!
    var html: String = ""
     var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgBtn.title =  "images".localizableString(loc: LanguageViewController.buttonName)
        imgBtn.tintColor = .white
        imgBtn.setBackgroundImage(#imageLiteral(resourceName: "croped"), for: .normal, barMetrics: .default)
        webV.loadHTMLString(html, baseURL: nil)
    }
    
    @IBAction func imagesPressed(_ sender: Any) {
        
        
    }
}





