//
//  Quote.swift
//  iMediaProto
//
//  Created by Habib on 7/1/19.
//  Copyright © 2019 a. All rights reserved.
//

import UIKit

class Quote {
    
    // MARK: - Properties
    
    var text: String
    var tags: [String]
    
    // MARK: - Initialization
    
    init(text: String, tags: [String]) {
        self.text = text
        self.tags = tags
    }
}
