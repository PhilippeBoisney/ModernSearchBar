//
//  SearchBarCompletion.swift
//  SearchBarCompletion
//
//  Created by Philippe on 03/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit
import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


open class ModernSearchBar: UISearchBar, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public enum Choice {
        case normal
        case withUrl
    }
    
    //MARK: DATAS
    fileprivate var isSuggestionsViewOpened: Bool!
    
    fileprivate var suggestionList: Array<String> = Array<String>()
    fileprivate var suggestionListFiltred: Array<String> = Array<String>()
    
    fileprivate var suggestionListWithUrl: Array<ModernSearchBarModel> = Array<ModernSearchBarModel>()
    fileprivate var suggestionListWithUrlFiltred: Array<ModernSearchBarModel> = Array<ModernSearchBarModel>()
    
    fileprivate var choice: Choice = .normal
    
    fileprivate var keyboardHeight: CGFloat = 0
    
    //MARKS: VIEWS
    fileprivate var suggestionsView: UITableView!
    fileprivate var suggestionsShadow: UIView!
    
    //MARK: DELEGATE
    open var delegateModernSearchBar: ModernSearchBarDelegate?
    
    //PUBLICS OPTIONS
    open var shadowView_alpha: CGFloat = 0.3
    
    open var searchImage: UIImage! = ModernSearchBarIcon.Icon.search.image
    
    open var searchLabel_font: UIFont?
    open var searchLabel_textColor: UIColor?
    open var searchLabel_backgroundColor: UIColor?
    
    open var suggestionsView_maxHeight: CGFloat!
    open var suggestionsView_backgroundColor: UIColor?
    open var suggestionsView_contentViewColor: UIColor?
    open var suggestionsView_separatorStyle: UITableViewCellSeparatorStyle = .none
    open var suggestionsView_selectionStyle: UITableViewCellSelectionStyle = UITableViewCellSelectionStyle.none
    open var suggestionsView_verticalSpaceWithSearchBar: CGFloat = 3
    
    open var suggestionsView_searchIcon_height: CGFloat = 17
    open var suggestionsView_searchIcon_width: CGFloat = 17
    open var suggestionsView_searchIcon_isRound = true
    
    open var suggestionsView_spaceWithKeyboard:CGFloat = 3
    
  
    //MARK: INITIALISERS
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init () {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    fileprivate func setup(){
        self.delegate = self
        self.isSuggestionsViewOpened = false
        self.interceptOrientationChange()
        self.interceptKeyboardChange()
        self.interceptMemoryWarning()
    }
    
    fileprivate func configureViews(){
        
        ///Configure suggestionsView (TableView)
        self.suggestionsView = UITableView(frame: CGRect(x: getSuggestionsViewX(), y: getSuggestionsViewY(), width: getSuggestionsViewWidth(), height: 0))
        self.suggestionsView.delegate = self
        self.suggestionsView.dataSource = self
        self.suggestionsView.register(ModernSearchBarCell.self, forCellReuseIdentifier: "cell")
        self.suggestionsView.rowHeight = UITableViewAutomaticDimension
        self.suggestionsView.estimatedRowHeight = 100
        self.suggestionsView.separatorStyle = self.suggestionsView_separatorStyle
        if let backgroundColor = suggestionsView_backgroundColor { self.suggestionsView.backgroundColor = backgroundColor }
        
        ///Configure the suggestions shadow (Behing the TableView)
        self.suggestionsShadow = UIView(frame: CGRect(x: getShadowX(), y: getShadowY(), width: getShadowWidth(), height: getShadowHeight()))
        self.suggestionsShadow.backgroundColor = UIColor.black.withAlphaComponent(self.shadowView_alpha)
        
        ///Configure the gesture to handle click on shadow and improve focus on searchbar
        let gestureShadow = UITapGestureRecognizer(target: self, action:  #selector (self.onClickShadowView (_:)))
        self.suggestionsShadow.addGestureRecognizer(gestureShadow)
        
        let gestureRemoveFocus = UITapGestureRecognizer(target: self, action:  #selector (self.removeFocus (_:)))
        gestureRemoveFocus.cancelsTouchesInView = false
        self.getTopViewController()?.view.addGestureRecognizer(gestureRemoveFocus)
        
        ///Reload datas of suggestionsView
        self.suggestionsView.reloadData()
    }
    
    // --------------------------------
    // SET DATAS
    // --------------------------------
    
    open func setDatas(_ datas: Array<String>){
        if (!self.suggestionListWithUrl.isEmpty) { fatalError("You have already filled 'suggestionListWithUrl' ! You can fill only one list. ") }
        self.suggestionList = datas
        self.choice = .normal
    }
    
    open func setDatasWithUrl(_ datas: Array<ModernSearchBarModel>){
        if (!self.suggestionList.isEmpty) { fatalError("You have already filled 'suggestionList' ! You can fill only one list. ") }
        self.suggestionListWithUrl = datas
        self.choice = .withUrl
    }
    
    // --------------------------------
    // DELEGATE METHODS SEARCH BAR
    // --------------------------------
    
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchWhenUserTyping(searchText)
        self.delegateModernSearchBar?.searchBar?(searchBar, textDidChange: searchText)
    }
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if self.suggestionsView == nil { self.configureViews() }
        self.delegateModernSearchBar?.searchBarTextDidEndEditing?(searchBar)
    }
    
    open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarTextDidEndEditing?(searchBar)
    }
    
    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarSearchButtonClicked?(searchBar)
        self.endEditing(true)
    }
    
    open func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarCancelButtonClicked?(searchBar)
        self.endEditing(true)
    }
    
    open func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if let shouldEndEditing = self.delegateModernSearchBar?.searchBarShouldEndEditing?(searchBar) {
            return shouldEndEditing
        } else {
            return true
        }
    }
    
    open func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let shouldBeginEditing = self.delegateModernSearchBar?.searchBarShouldBeginEditing?(searchBar) {
            return shouldBeginEditing
        } else {
            return true
        }
    }
    
    
    // --------------------------------
    // ACTIONS
    // --------------------------------
    
    ///Handle click on shadow view
    func onClickShadowView(_ sender:UITapGestureRecognizer){
        self.delegateModernSearchBar?.onClickShadowView?(self.suggestionsShadow)
        self.closeSuggestionsView()
    }
    
    ///Remove focus when you tap outside the searchbar
    func removeFocus(_ sender:UITapGestureRecognizer){
        if (!isSuggestionsViewOpened){ self.endEditing(true) }
    }
    
    // --------------------------------
    // DELEGATE METHODS TABLE VIEW
    // --------------------------------
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.choice {
        case .normal:
            return self.suggestionListFiltred.count
        case .withUrl:
            return self.suggestionListWithUrlFiltred.count
        }
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:ModernSearchBarCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ModernSearchBarCell
        
        var title = ""
        
        switch self.choice {
        case .normal:
            title = self.suggestionListFiltred[indexPath.row]
            break
        case .withUrl:
            title = self.suggestionListWithUrlFiltred[indexPath.row].title
            break
        }
        
        ///Configure label
        cell.labelModelSearchBar.text = title
        if let font = self.searchLabel_font { cell.labelModelSearchBar.font = font }
        if let textColor = self.searchLabel_textColor { cell.labelModelSearchBar.textColor = textColor }
        if let backgroundColor = self.searchLabel_backgroundColor { cell.labelModelSearchBar.backgroundColor = backgroundColor }
        
        ///Configure content
        if let contentColor = suggestionsView_contentViewColor { cell.contentView.backgroundColor = contentColor }
        cell.selectionStyle = self.suggestionsView_selectionStyle
        
        ///Configure Image
        cell.configureImage(self.choice, searchImage: self.searchImage, suggestionsListWithUrl: self.suggestionListWithUrlFiltred, position: indexPath.row, isImageRound: self.suggestionsView_searchIcon_isRound, heightImage: self.suggestionsView_searchIcon_height)
        //self.fetchImageFromUrl(model: self.suggestionListWithUrlFiltred[indexPath.row], cell: cell, indexPath: indexPath)
        
        ///Configure max width label size
        cell.configureWidthMaxLabel(self.suggestionsView.frame.width, searchImageWidth: self.suggestionsView_searchIcon_width)
        
        ///Configure Constraints
        cell.configureConstraints(self.suggestionsView_searchIcon_height, widthImage: self.suggestionsView_searchIcon_width)
        
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.choice {
        case .normal:
            self.delegateModernSearchBar?.onClickItemSuggestionsView?(self.suggestionListFiltred[indexPath.row])
        case .withUrl:
            self.delegateModernSearchBar?.onClickItemWithUrlSuggestionsView?(self.suggestionListWithUrlFiltred[indexPath.row])
        }
    }
    
    // --------------------------------
    // SEARCH FUNCTION
    // --------------------------------
    
    ///Main function that is called when user searching
    fileprivate func searchWhenUserTyping(_ caracters: String){
        
        switch self.choice {
        
        ///Case normal (List of string)
        case .normal:
            
            var suggestionListFiltredTmp = Array<String>()
            DispatchQueue.global(qos: .background).async {
                for item in self.suggestionList {
                    if (self.researchCaracters(caracters, stringQueried: item)){
                        suggestionListFiltredTmp.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.suggestionListFiltred.removeAll()
                    self.suggestionListFiltred.append(contentsOf: suggestionListFiltredTmp)
                    self.updateAfterSearch(caracters)
                }
            }
            
            break
        
        ///Case with URL (List of ModernSearchBarModel)
        case .withUrl:
            
            var suggestionListFiltredWithUrlTmp = Array<ModernSearchBarModel>()
            DispatchQueue.global(qos: .background).async {
                for item in self.suggestionListWithUrl {
                    if (self.researchCaracters(caracters, stringQueried: item.title)){
                        suggestionListFiltredWithUrlTmp.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.suggestionListWithUrlFiltred.removeAll()
                    self.suggestionListWithUrlFiltred.append(contentsOf: suggestionListFiltredWithUrlTmp)
                    self.updateAfterSearch(caracters)
                }
            }
            
            break
        }
    }
    
    fileprivate func researchCaracters(_ stringSearched: String, stringQueried: String) -> Bool {
        
        var searched = stringSearched.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        var queried = stringQueried.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        
        return queried.contains(searched)
    }
    
    fileprivate func updateAfterSearch(_ caracters: String){
        self.suggestionsView.reloadData()
        self.updateSizeSuggestionsView()
        caracters.isEmpty ? self.closeSuggestionsView() : self.openSuggestionsView()
    }
    
    // --------------------------------
    // SUGGESTIONS VIEW UTILS
    // --------------------------------
    
    fileprivate func haveToOpenSuggestionView() -> Bool {
        switch self.choice {
        case .normal:
            return !self.suggestionListFiltred.isEmpty
        case .withUrl:
            return !self.suggestionListWithUrlFiltred.isEmpty
        }
    }
    
    fileprivate func openSuggestionsView(){
        if (self.haveToOpenSuggestionView()){
            if (!self.isSuggestionsViewOpened){
                self.animationOpening()
                
                self.addViewToParent(self.suggestionsShadow)
                self.addViewToParent(self.suggestionsView)
                self.isSuggestionsViewOpened = true
                self.suggestionsView.reloadData()
            }
        }
    }
    
    fileprivate func closeSuggestionsView(){
        if (self.isSuggestionsViewOpened == true){
            self.animationClosing()
            self.isSuggestionsViewOpened = false
        }
    }
    
    fileprivate func animationOpening(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.suggestionsView.alpha = 1.0
            self.suggestionsShadow.alpha = 1.0
        }, completion: nil)
    }
    
    fileprivate func animationClosing(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.suggestionsView.alpha = 0.0
            self.suggestionsShadow.alpha = 0.0
        }, completion: nil)
    }
    
    // --------------------------------
    // VIEW UTILS
    // --------------------------------
    
    fileprivate func getSuggestionsViewX() -> CGFloat {
        return self.getGlobalPointEditText().x
    }
    
    fileprivate func getSuggestionsViewY() -> CGFloat {
        return self.getShadowY().subtracting(self.suggestionsView_verticalSpaceWithSearchBar)
    }
    
    fileprivate func getSuggestionsViewWidth() -> CGFloat {
        return self.getEditText().frame.width
    }
    
    fileprivate func getSuggestionsViewHeight() -> CGFloat {
        return self.getEditText().frame.height
    }
    
    fileprivate func getShadowX() -> CGFloat {
        return 0
    }
    
    fileprivate func getShadowY() -> CGFloat {
        return self.getGlobalPointEditText().y.adding(self.getEditText().frame.height)
    }
    
    fileprivate func getShadowHeight() -> CGFloat {
        return (self.getTopViewController()?.view.frame.height)!
    }
    
    fileprivate func getShadowWidth() -> CGFloat {
        return (self.getTopViewController()?.view.frame.width)!
    }
    
    fileprivate func updateSizeSuggestionsView(){
        var frame: CGRect = self.suggestionsView.frame
        frame.size.height = self.getExactMaxHeightSuggestionsView(self.suggestionsView.contentSize.height)
        
        UIView.animate(withDuration: 0.3) {
            self.suggestionsView.frame = frame
            self.suggestionsView.layoutIfNeeded()
            self.suggestionsView.sizeToFit()
        }
    }
    
    fileprivate func getExactMaxHeightSuggestionsView(_ newHeight: CGFloat) -> CGFloat {
        var estimatedMaxView: CGFloat!
        if self.suggestionsView_maxHeight != nil {
            estimatedMaxView = self.suggestionsView_maxHeight
        } else {
            estimatedMaxView = self.getEstimateHeightSuggestionsView()
        }
        
        if (newHeight > estimatedMaxView) {
            return estimatedMaxView
        } else {
            return newHeight
        }
    }
    
    fileprivate func getEstimateHeightSuggestionsView() -> CGFloat {
        return self.getViewTopController().frame.height
            .subtracting(self.getShadowY())
            .subtracting(self.keyboardHeight)
            .subtracting(self.suggestionsView_spaceWithKeyboard)
    }    
    
    // --------------------------------
    // UTILS
    // --------------------------------
    
    fileprivate func clearCacheOfList(){
        ///Clearing cache
        for suggestionItem in self.suggestionListWithUrl {
            suggestionItem.imgCache = nil
        }
        ///Clearing cache
        for suggestionItem in self.suggestionListWithUrlFiltred {
            suggestionItem.imgCache = nil
        }
        self.suggestionsView.reloadData()
    }
    
    fileprivate func addViewToParent(_ view: UIView){
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(view)
        }
    }
    
    fileprivate func getViewTopController() -> UIView{
        return self.getTopViewController()!.view
    }
    
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    fileprivate func getEditText() -> UITextField {
        return self.value(forKey: "searchField") as! UITextField
    }
    
    fileprivate func getText() -> String{
        if let text = self.getEditText().text {
            return text
        } else {
            return ""
        }
    }
    
    fileprivate func getGlobalPointEditText() -> CGPoint {
        return self.getEditText().superview!.convert(self.getEditText().frame.origin, to: nil)
    }
    
    // --------------------------------
    // OBSERVERS CHANGES
    // --------------------------------
    
    fileprivate func interceptOrientationChange(){
        self.getEditText().addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "frame"){
            self.closeSuggestionsView()
            self.configureViews()
        }
    }
    
    // ---------------
    
    fileprivate func interceptKeyboardChange(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: NSObject] as NSDictionary
        let keyboardFrame = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! CGRect
        let keyboardHeight = keyboardFrame.height
        
        self.keyboardHeight = keyboardHeight
        self.updateSizeSuggestionsView()
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        self.keyboardHeight = 0
        self.updateSizeSuggestionsView()
    }
    
    // ---------------
    
    private func interceptMemoryWarning(){
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning(notification:)), name: NSNotification.Name.UIApplicationDidReceiveMemoryWarning, object: nil)
    }
    
    @objc private func didReceiveMemoryWarning(notification: NSNotification) {
        self.clearCacheOfList()
    }
    
    // --------------------------------
    // PUBLIC ACCESS
    // --------------------------------
    
    public func getSuggestionsView() -> UITableView {
        return self.suggestionsView
    }
    
}
