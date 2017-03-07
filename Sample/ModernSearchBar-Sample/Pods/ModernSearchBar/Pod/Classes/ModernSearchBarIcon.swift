//
//  ModernSearchBarIcon.swift
//  SearchBarCompletion
//
//  Created by Philippe on 06/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//


import UIKit

public class ModernSearchBarIcon : NSObject {
    
    enum Icon {
        case search
        case none
        
        var image: UIImage {
            switch self {
                case .none: return UIImage()
                case .search: return UIImage(named: "search")!               
            }
        }
    }
}
