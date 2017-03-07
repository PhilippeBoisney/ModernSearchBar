<p>
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/bandeau.png"/>
</p>
**The famous iOS searching bar with auto completion feature implemented.**

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

## PRESENTATION
This searching bar will allow you to offer suggestions words to your users when they are looking for something using default iOS search bar.


## DEMO (Two ways to use ModernSearchBar)
<p align="center">
 <h3>1 - With String</h3>
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Gifs/Gif_simple_list.gif", height=300/>
 <h3>2 - With custon item (URL + Title)</h3>
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Gifs/Gif_complex_list.gif", height=300/>
 
</p>

## INSTALLATION
####COCOAPODS
```
pod 'ModernSearchBar'
```


## USAGE
####1 - Set custom class with ModernSearchBar
<p align="center">
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/usage_1.png", height=300/> 
</p>
####2 - Create an outlet to your ViewController
```swift
 @IBOutlet weak var modernSearchBar: ModernSearchBar!
 ```
####3 - Set delegate
 ```swift
 self.modernSearchBar.delegateModernSearchBar = self
 ```
####4 - Set datas (Way 1: With String array)
 ```swift
 ///Create array of string
 var suggestionList = Array<String>()
 suggestionList.append("Onions")
 suggestionList.append("Celery")
 
 //Fill the searchbar
 self.modernSearchBar.setDatas(datas: suggestionList)
 ```
####4 bis - Set datas (Way 2: With custom item array)
 ```swift
 ///Create array of ModernSearchBarModel containing a title and a url
 var suggestionListWithUrl = Array<ModernSearchBarModel>()
 suggestionListWithUrl.append(ModernSearchBarModel(title: "Alpha", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleA.png"))
 suggestionListWithUrl.append(ModernSearchBarModel(title: "Bravo", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleB.png"))
 
 //Fill the searchbar
 self.modernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)
 ```
**Delegate**
Delegate inherit from UISearchBarDelegate, so you can find commons methods. Also, we add this methods to handle click actions on suggestionsView.
 ```swift
 
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
 
 ``` 
 **CUSTOMIZING**
 
 ```swift

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
self.modernSearchBar.suggestionsView_selectionStyle = UITableViewCellSelectionStyle.gray

  ```
  
## Version
1.0

## Author
Philippe BOISNEY (phil.boisney(@)gmail.com)
