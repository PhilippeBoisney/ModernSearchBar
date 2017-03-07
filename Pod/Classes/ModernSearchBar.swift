//
//  SearchBarCompletion.swift
//  SearchBarCompletion
//
//  Created by Philippe on 03/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit
import Foundation

public class ModernSearchBar: UISearchBar, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public enum Choice {
        case normal
        case withUrl
    }
    
    //MARK: DATAS
    private var isSuggestionsViewOpened: Bool!
    
    private var suggestionList: Array<String> = Array<String>()
    private var suggestionListFiltred: Array<String> = Array<String>()
    
    private var suggestionListWithUrl: Array<ModernSearchBarModel> = Array<ModernSearchBarModel>()
    private var suggestionListWithUrlFiltred: Array<ModernSearchBarModel> = Array<ModernSearchBarModel>()
    
    private var choice: Choice = .normal
    
    //MARKS: VIEWS
    private var suggestionsView: UITableView!
    private var suggestionsShadow: UIView!
    
    //MARK: DELEGATE
    var delegateModernSearchBar: ModernSearchBarDelegate?
    
    //PUBLICS OPTIONS
    public var shadowView_alpha: CGFloat = 0.3
    
    public var searchImage: UIImage! = ModernSearchBarIcon.Icon.search.image
    
    public var searchLabel_font: UIFont?
    public var searchLabel_textColor: UIColor?
    public var searchLabel_backgroundColor: UIColor?
    
    public var suggestionsView_maxHeight: CGFloat = UIScreen.main.bounds.height.divided(by: 2.5)
    public var suggestionsView_backgroundColor: UIColor?
    public var suggestionsView_contentViewColor: UIColor?
    public var suggestionsView_separatorStyle: UITableViewCellSeparatorStyle = .none
    public var suggestionsView_selectionStyle: UITableViewCellSelectionStyle = UITableViewCellSelectionStyle.none
    
    public var suggestionsView_searchIcon_height: CGFloat = 17
    public var suggestionsView_searchIcon_width: CGFloat = 17
    public var suggestionsView_searchIcon_isRound = true
    
  
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
    
    
    private func setup(){
        self.delegate = self
        self.isSuggestionsViewOpened = false
        self.interceptOrientationChange()
    }
    
    private func configureViews(){
        
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
    
    public func setDatas(datas: Array<String>){
        if (!self.suggestionListWithUrl.isEmpty) { fatalError("You have already filled 'suggestionListWithUrl' ! You can fill only one list. ") }
        self.suggestionList = datas
        self.choice = .normal
    }
    
    public func setDatasWithUrl(datas: Array<ModernSearchBarModel>){
        if (!self.suggestionList.isEmpty) { fatalError("You have already filled 'suggestionList' ! You can fill only one list. ") }
        self.suggestionListWithUrl = datas
        self.choice = .withUrl
    }
    
    // --------------------------------
    // DELEGATE METHODS SEARCH BAR
    // --------------------------------
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.closeSuggestionsView()
        } else {
            self.searchWhenUserTyping(caracters: searchText)
            self.openSuggestionsView()
        }
        self.delegateModernSearchBar?.searchBar?(searchBar, textDidChange: searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if self.suggestionsView == nil { self.configureViews() }
        self.delegateModernSearchBar?.searchBarTextDidEndEditing?(searchBar)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarTextDidEndEditing?(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarSearchButtonClicked?(searchBar)
        self.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.closeSuggestionsView()
        self.delegateModernSearchBar?.searchBarCancelButtonClicked?(searchBar)
        self.endEditing(true)
    }
    
    
    // --------------------------------
    // ACTIONS
    // --------------------------------
    
    ///Handle click on shadow view
    func onClickShadowView(_ sender:UITapGestureRecognizer){
        self.delegateModernSearchBar?.onClickShadowView?(shadowView: self.suggestionsShadow)
        self.closeSuggestionsView()
    }
    
    ///Remove focus when you tap outside the searchbar
    func removeFocus(_ sender:UITapGestureRecognizer){
        if (!isSuggestionsViewOpened){ self.endEditing(true) }
    }
    
    // --------------------------------
    // DELEGATE METHODS TABLE VIEW
    // --------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.choice {
        case .normal:
            return self.suggestionListFiltred.count
        case .withUrl:
            return self.suggestionListWithUrlFiltred.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        cell.configureImage(choice: self.choice, searchImage: self.searchImage, suggestionsListWithUrl: self.suggestionListWithUrlFiltred, position: indexPath.row, isImageRound: self.suggestionsView_searchIcon_isRound, heightImage: self.suggestionsView_searchIcon_height)
        //self.fetchImageFromUrl(model: self.suggestionListWithUrlFiltred[indexPath.row], cell: cell, indexPath: indexPath)
        
        ///Configure max width label size
        cell.configureWidthMaxLabel(suggestionsViewWidth: self.suggestionsView.frame.width, searchImageWidth: self.suggestionsView_searchIcon_width)
        
        ///Configure Constraints
        cell.configureConstraints(heightImage: self.suggestionsView_searchIcon_height, widthImage: self.suggestionsView_searchIcon_width)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.choice {
        case .normal:
            self.delegateModernSearchBar?.onClickItemSuggestionsView?(item: self.suggestionListFiltred[indexPath.row])
        case .withUrl:
            self.delegateModernSearchBar?.onClickItemWithUrlSuggestionsView?(item: self.suggestionListWithUrlFiltred[indexPath.row])
        }
    }
    
    // --------------------------------
    // SEARCH FUNCTION
    // --------------------------------
    
    ///Main function that is called when user searching
    private func searchWhenUserTyping(caracters: String){
        
        switch self.choice {
        
        ///Case normal (List of string)
        case .normal:
            
            var suggestionListFiltredTmp = Array<String>()
            DispatchQueue.global(qos: .background).async {
                for item in self.suggestionList {
                    if (self.researchCaracters(stringSearched: caracters, stringQueried: item)){
                        suggestionListFiltredTmp.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.suggestionListFiltred.removeAll()
                    self.suggestionListFiltred.append(contentsOf: suggestionListFiltredTmp)
                    self.updateAfterSearch()
                }
            }
            
            break
        
        ///Case with URL (List of ModernSearchBarModel)
        case .withUrl:
            
            var suggestionListFiltredWithUrlTmp = Array<ModernSearchBarModel>()
            DispatchQueue.global(qos: .background).async {
                for item in self.suggestionListWithUrl {
                    if (self.researchCaracters(stringSearched: caracters, stringQueried: item.title)){
                        suggestionListFiltredWithUrlTmp.append(item)
                    }
                }
                DispatchQueue.main.async {
                    self.suggestionListWithUrlFiltred.removeAll()
                    self.suggestionListWithUrlFiltred.append(contentsOf: suggestionListFiltredWithUrlTmp)
                    self.updateAfterSearch()
                }
            }
            
            break
        }
    }
    
    private func researchCaracters(stringSearched: String, stringQueried: String) -> Bool {
        return ((stringQueried.range(of: stringSearched, options: String.CompareOptions.caseInsensitive, range: nil, locale: nil)) != nil)
    }
    
    private func updateAfterSearch(){
        self.suggestionsView.reloadData()
        self.updateSizeSuggestionsView()
    }
    
    // --------------------------------
    // SUGGESTIONS VIEW UTILS
    // --------------------------------
    
    private func openSuggestionsView(){
        if (!self.isSuggestionsViewOpened){
            self.animationOpening()
            
            self.addViewToParent(view: self.suggestionsShadow)
            self.addViewToParent(view: self.suggestionsView)
            self.isSuggestionsViewOpened = true
        }
    }
    
    private func closeSuggestionsView(){
        if (self.isSuggestionsViewOpened){
            self.animationClosing()
            self.isSuggestionsViewOpened = false
        }
    }
    
    private func animationOpening(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.suggestionsView.alpha = 1.0
            self.suggestionsShadow.alpha = 1.0
        }, completion: nil)
    }
    
    private func animationClosing(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.suggestionsView.alpha = 0.0
            self.suggestionsShadow.alpha = 0.0
        }, completion: { (finished) -> Void in
            self.suggestionsView.removeFromSuperview()
            self.suggestionsShadow.removeFromSuperview()
        })
    }
    
    // --------------------------------
    // VIEW UTILS
    // --------------------------------
    
    private func getSuggestionsViewX() -> CGFloat {
        return self.getEditText().frame.origin.x
    }
    
    private func getSuggestionsViewY() -> CGFloat {
        return self.frame.origin.y.adding(self.getEditText().frame.height).adding((self.frame.height.subtracting(self.getEditText().frame.height)).divided(by: 2)).subtracting(4)
    }
    
    private func getSuggestionsViewWidth() -> CGFloat {
        return self.getEditText().frame.width
    }
    
    private func getSuggestionsViewHeight() -> CGFloat {
        return self.getEditText().frame.height
    }
    
    private func getShadowX() -> CGFloat {
        return self.frame.origin.x
    }
    
    private func getShadowY() -> CGFloat {
        return self.frame.origin.y.adding(self.frame.height)
    }
    
    private func getShadowHeight() -> CGFloat {
        return (self.getTopViewController()?.view.frame.height)!
    }
    
    private func getShadowWidth() -> CGFloat {
        return self.frame.width
    }
    
    private func updateSizeSuggestionsView(){
        var frame: CGRect = self.suggestionsView.frame
        frame.size.height = self.getMaxHeightSuggestionsView(newHeight: self.suggestionsView.contentSize.height)
        self.suggestionsView.frame = frame
        UIView.animate(withDuration: 0.0) {
            self.suggestionsView.layoutIfNeeded()
            self.suggestionsView.sizeToFit()
        }
    }
    
    private func getMaxHeightSuggestionsView(newHeight: CGFloat) -> CGFloat {
        if (newHeight > self.suggestionsView_maxHeight) {
            return self.suggestionsView_maxHeight
        } else {
            return newHeight
        }
    }
    
    // --------------------------------
    // UTILS
    // --------------------------------
    
    private func addViewToParent(view: UIView){
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(view)
        }
    }
    
    private func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    private func getEditText() -> UITextField {
        return self.value(forKey: "searchField") as! UITextField
    }
    
    private func getText() -> String{
        if let text = self.getEditText().text {
            return text
        } else {
            return ""
        }
    }
    
    private func interceptOrientationChange(){
        self.getEditText().addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "frame"){
            self.closeSuggestionsView()
            self.configureViews()
        }
    }
    
    // --------------------------------
    // PUBLIC ACCESS
    // --------------------------------
    
    public func getSuggestionsView() -> UITableView {
        return self.suggestionsView
    }
}
