//
//  ModernSearchBarModel.swift
//  SearchBarCompletion
//
//  Created by Philippe on 06/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit

public class ModernSearchBarModel: NSObject {
    
    public var title: String!
    public var url: URL!
    public var imgCache: UIImage!
    
    public init(title: String, url: String) {
        super.init()
        self.title = title
        if let newUrl = URL(string: url) {
            self.url = newUrl
        } else {
            print("ModernSearchBarModel: Seems url is not valid...")
            self.url = URL(string: "#")
        }
    }
}
