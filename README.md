<p>
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/bandeau.png"/>
</p>

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

## PRESENTATION
This search bar will allow you to offer suggestions words to your users when they are looking for something using default iOS search bar. Enjoy it !


## DEMO
**Two ways to use this lib :** 
- One with a simple array of string (Array&#60;String&#62;)
- The other with an array of custom object (Array&#60;ModernSearchBarModel&#62;) if you want to get image of each row from an url.

SIMPLE  |  ADVANCED
:-------------------------:|:-------------------------:
![](https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Gifs/Gif_simple_list.gif)  |  ![](https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Gifs/Gif_complex_list.gif)

## INSTALLATION
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `ModernSearchBar` by adding it to your `Podfile`:
```
pod 'ModernSearchBar'
```
#### Manually
1. Download and drop all *.swift files contained in Pod folder in your project.
2. Don't forget to import the assets folder too.
3. Enjoy !  


## USAGE
### 1 - Configure StoryBoard (Custom Class)
<p align="center">
 <img src ="https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/usage_1.png", height=300/>
</p>

### 2 - Configure ViewController


```swift
//Import lib on the top of ViewController
import ModernSearchBar

//Create an IBOutlet from your searchBar
 @IBOutlet weak var modernSearchBar: ModernSearchBar!

//Extend your ViewController with 'ModernSearchBarDelegate'
class ViewController: UIViewController, ModernSearchBarDelegate

//Implement the delegation
self.modernSearchBar.delegateModernSearchBar = self

//Set datas to fill the suggestionsView of the searchbar.
//Two ways (you have to choose only one, you can't implement both obviously)

// 1 - With an Array<String>
var suggestionList = Array<String>()
suggestionList.append("Onions")
suggestionList.append("Celery")

self.modernSearchBar.setDatas(datas: suggestionList)

// 2 - With custom Array<ModernSearchBarModel>
var suggestionListWithUrl = Array<ModernSearchBarModel>()
suggestionListWithUrl.append(ModernSearchBarModel(title: "Alpha", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleA.png"))
suggestionListWithUrl.append(ModernSearchBarModel(title: "Bravo", url: "https://github.com/PhilippeBoisney/ModernSearchBar/raw/master/Examples%20Url/exampleB.png"))

self.modernSearchBar.setDatasWithUrl(datas: suggestionListWithUrl)

```
## DELEGATE
ModernSearchBarDelegate inherit from UISearchBarDelegate, so you can find commons methods you already use in your project. Also, I add those methods to handle click actions on suggestionsView.
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
## CUSTOMIZING

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
self.modernSearchBar.suggestionsView_verticalSpaceWithSearchBar = 10
self.modernSearchBar.suggestionsView_spaceWithKeyboard = 20

  ```

## Version
1.4

## License

Copyright 2017 Boisney Philippe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. **Create New Pull Request**

## Author
Philippe BOISNEY (phil.boisney(@)gmail.com)
