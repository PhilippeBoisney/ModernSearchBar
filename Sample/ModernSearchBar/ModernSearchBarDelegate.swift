//
//  ModernSearchBarDelegate.swift
//  SearchBarCompletion
//
//  Created by Philippe on 03/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit

@objc public protocol ModernSearchBarDelegate: UISearchBarDelegate {
    @objc optional func onClickShadowView(shadowView: UIView)
    @objc optional func onClickItemSuggestionsView(item: String)
    @objc optional func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel)    
}
