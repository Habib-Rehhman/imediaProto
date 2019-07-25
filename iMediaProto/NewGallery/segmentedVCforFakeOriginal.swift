//
//  ViewController.swift
//  DemoObjectLibrary
//
//  Created by Chao Shin on 16/03/2018.
//  Copyright © 2018 Chao Shin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func mySegmentedAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { //判斷使用者選擇是哪一個Segmented 0是付費App、1是免費App
            myImageView.image = UIImage(named: "SegmentedPay") //顯示付費圖片
        }else {
            myImageView.image = UIImage(named: "SegmentedFree") //顯示免費圖片
        }
    }
    
}

