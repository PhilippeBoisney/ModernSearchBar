//
//  ViewController.swift
//  SearchBarCompletion
//
//  Created by Philippe on 03/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModernSearchBarDelegate {
    
    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makingSearchBarAwesome()
        self.configureSearchBar()
        //self.configureSearchBarWithUrl()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //----------------------------------------
    // OPTIONNAL DELEGATE METHODS
    //----------------------------------------
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change, what i'm suppose to do ?")
    }
    
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
    }
    
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
    }
    
    
    //----------------------------------------
    // CONFIGURE SEARCH BAR (TWO WAYS)
    //----------------------------------------
    
    // 1 - Configure search bar with a simple list of string
    
    private func configureSearchBar(){
        
        ///Create array of string
        var suggestionList = Array<String>()
        suggestionList.append("Onions")
        suggestionList.append("Celery")
        suggestionList.append("Very long vegetable to show you that cell is updated and fit all the row")
        suggestionList.append("Potatoes")
        suggestionList.append("Carrots")
        suggestionList.append("Broccoli")
        suggestionList.append("Asparagus")
        suggestionList.append("Apples")
        suggestionList.append("Berries")
        suggestionList.append("Kiwis")
        suggestionList.append("Raymond")
        
        ///Adding delegate
        self.modernSearchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.modernSearchBar.setDatas(datas: suggestionList)
        
        ///Custom design with all paramaters if you want to
        self.customDesign()
        
    }
    
    // 2 - Configure search bar with a list of ModernSearchBarModel (If you want to show also an image from an url)
    
    private func configureSearchBarWithUrl(){
        
        ///Create array of ModernSearchBarModel containing a title and a url
        var suggestionListWithUrl = Array<ModernSearchBarModel>()
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Apple iMac", url: "http://images.apple.com/v/imac/d/images/overview/performance_medium.jpg"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Apple accessories", url: "http://images.apple.com/v/imac/d/images/overview/accessories_medium_2x.jpg"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Every new Mac comes with Photos, iMovie, GarageBand, Pages, Numbers, and Keynote.", url: "http://images.apple.com/v/imac/d/images/overview/built_in_apps_macos_medium_2x.jpg"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Apple Pay", url: "http://images.apple.com/v/apple-pay/f/images/overview/stores_medium_2x.jpg"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Apple iPad", url: "http://images.apple.com/v/apple-pay/f/images/overview/apps_medium_2x.jpg"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "All our products (if you are very rich)", url: "http://images.apple.com/v/apple-pay/f/images/overview/web_medium_2x.jpg"))
        
        
        ///Adding delegate
        self.modernSearchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.modernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)
        
        ///Custom design with all paramaters
        self.customDesign()
        
    }
    
    //----------------------------------------
    // CUSTOM DESIGN (WITH ALL OPTIONS)
    //----------------------------------------
    
    private func customDesign(){
        
        // --------------------------
        // Enjoy this beautiful customizations (It's a joke...)
        // --------------------------
        
        /*
         
         self.modernSearchBar.shadowView_alpha = 0.8
         
         self.modernSearchBar.searchImage = ModernSearchBarIcon.Icon.none.image
         
         self.modernSearchBar.searchLabel_font = UIFont(name: "Avenir-Light", size: 30)
         self.modernSearchBar.searchLabel_textColor = UIColor.red
         self.modernSearchBar.searchLabel_backgroundColor = UIColor.black
         
         self.modernSearchBar.suggestionsView_maxHeight = 1000
         self.modernSearchBar.suggestionsView_backgroundColor = UIColor.brown
         self.modernSearchBar.suggestionsView_contentViewColor = UIColor.yellow
         self.modernSearchBar.suggestionsView_separatorStyle = .singleLine
         self.modernSearchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray
         
         self.modernSearchBar.suggestionsView_searchIcon_height = 40
         self.modernSearchBar.suggestionsView_searchIcon_width = 40
         self.modernSearchBar.suggestionsView_searchIcon_isRound = false
         
         */
    }
    
    private func makingSearchBarAwesome(){
        self.modernSearchBar.backgroundImage = UIImage()
        self.modernSearchBar.layer.borderWidth = 0
        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
    }
    
}
