//
//  WebVC.swift
//  iMediaProto
//
//  Created by Habib on 7/2/19.
//  Copyright © 2019 a. All rights reserved.
//

import WebKit

class WebVC : UIViewController{
    
    @IBOutlet weak var imgButton: UIButton!
    
    @IBOutlet weak var webV: WKWebView!
    var html: String = ""
     var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webV.loadHTMLString(html, baseURL: nil)
    }
    

    
    @IBAction func imagesPressed(_ sender: Any) {
        
        
    }
}





