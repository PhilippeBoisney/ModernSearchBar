//
//  ViewController.swift
//  ModernSearchBar
//
//  Created by Philippe on 05/10/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ModernSearchBarDelegate {

    @IBOutlet weak var modernSearchBar: ModernSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.makingSearchBarAwesome()
        
        ///Uncomment this one...
        //self.configureSearchBar()
        ///... or uncomment this one ! (but you can't uncomment both)
        self.configureSearchBarWithUrl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //----------------------------------------
    // OPTIONNAL DELEGATE METHODS
    //----------------------------------------
    
    
    ///Called if you use String suggestion list
    func onClickItemSuggestionsView(item: String) {
        print("User touched this item: "+item)
    }
    
    ///Called if you use Custom Item suggestion list
    func onClickItemWithUrlSuggestionsView(item: ModernSearchBarModel) {
        print("User touched this item: "+item.title+" with this url: "+item.url.description)
    }
    
    ///Called when user touched shadowView
    func onClickShadowView(shadowView: UIView) {
        print("User touched shadowView")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Text did change, what i'm suppose to do ?")
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
        //self.customDesign()
        
    }
    
    // 2 - Configure search bar with a list of ModernSearchBarModel (If you want to show also an image from an url)
    
    private func configureSearchBarWithUrl(){
        
        ///Create array of ModernSearchBarModel containing a title and a url
        var suggestionListWithUrl = Array<ModernSearchBarModel>()
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Alpha", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleA.png"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Bravo", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleB.png"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Charlie ? Well, just a long sentence to show you how powerful is this lib...", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleC.png"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Delta", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleD.png"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Echo", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleE.png"))
        suggestionListWithUrl.append(ModernSearchBarModel(title: "Golf", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleG.png"))
        
        
        ///Adding delegate
        self.modernSearchBar.delegateModernSearchBar = self
        
        ///Set datas to search bar
        self.modernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)
        
        ///Increase size of suggestionsView icon
        self.modernSearchBar.suggestionsView_searchIcon_height = 40
        self.modernSearchBar.suggestionsView_searchIcon_width = 40
        
        ///Custom design with all paramaters
        //self.customDesign()
        
    }
    
    //----------------------------------------
    // CUSTOM DESIGN (WITH ALL OPTIONS)
    //----------------------------------------
    
    private func customDesign(){
        
        // --------------------------
        // Enjoy this beautiful customizations (It's a joke...)
        // --------------------------
        
        
        //Modify shadows alpha
        self.modernSearchBar.shadowView_alpha = 0.8
        
        //Modify the default icon of suggestionsView's rows
        self.modernSearchBar.searchImage = ModernSearchBarIcon.Icon.none.image
        
        //Modify properties of the searchLabel
        self.modernSearchBar.searchLabel_font = UIFont(name: "Avenir-Light", size: 30)
        self.modernSearchBar.searchLabel_textColor = UIColor.red
        self.modernSearchBar.searchLabel_backgroundColor = UIColor.black
        
        //Modify properties of the searchIcon
        self.modernSearchBar.suggestionsView_searchIcon_height = 40
        self.modernSearchBar.suggestionsView_searchIcon_width = 40
        self.modernSearchBar.suggestionsView_searchIcon_isRound = false
        
        //Modify properties of suggestionsView
        ///Modify the max height of the suggestionsView
        self.modernSearchBar.suggestionsView_maxHeight = 1000
        ///Modify properties of the suggestionsView
        self.modernSearchBar.suggestionsView_backgroundColor = UIColor.brown
        self.modernSearchBar.suggestionsView_contentViewColor = UIColor.yellow
        self.modernSearchBar.suggestionsView_separatorStyle = .singleLine
        self.modernSearchBar.suggestionsView_selectionStyle = UITableViewCell.SelectionStyle.gray
        self.modernSearchBar.suggestionsView_verticalSpaceWithSearchBar = 10
        self.modernSearchBar.suggestionsView_spaceWithKeyboard = 20
    }
    
    private func makingSearchBarAwesome(){
        self.modernSearchBar.backgroundImage = UIImage()
        self.modernSearchBar.layer.borderWidth = 0
        self.modernSearchBar.layer.borderColor = UIColor(red: 181, green: 240, blue: 210, alpha: 1).cgColor
    }


}

