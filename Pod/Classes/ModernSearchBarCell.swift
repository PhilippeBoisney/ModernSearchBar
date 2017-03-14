//
//  ModernSearchBarCell.swift
//  SearchBarCompletion
//
//  Created by Philippe on 06/03/2017.
//  Copyright © 2017 CookMinute. All rights reserved.
//

import UIKit

public class ModernSearchBarCell: UITableViewCell {
    
    public static let defaultMargin: CGFloat = 10
    
    let imgModernSearchBar = UIImageView()
    var labelModelSearchBar = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }   
    
    private func setup(){
        ///Setup image
        self.imgModernSearchBar.translatesAutoresizingMaskIntoConstraints = false
        self.imgModernSearchBar.contentMode = .scaleAspectFill
        
        ///Setup label
        self.labelModelSearchBar.translatesAutoresizingMaskIntoConstraints = false
        self.labelModelSearchBar.numberOfLines = 0
        self.labelModelSearchBar.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        self.contentView.addSubview(imgModernSearchBar)
        self.contentView.addSubview(labelModelSearchBar)
    }
    
    ///Configure constraint for each row of suggestionsView
    public func configureConstraints(heightImage: CGFloat, widthImage: CGFloat){
        
        ///Image constraints
        let verticalImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.centerYWithinMargins, relatedBy: .equal, toItem: self.contentView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0)
        let topImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.top, relatedBy: .greaterThanOrEqual, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant: ModernSearchBarCell.defaultMargin)
        topImageConstraint.priority = UILayoutPriorityDefaultLow
        let bottomImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant: ModernSearchBarCell.defaultMargin)
        bottomImageConstraint.priority = UILayoutPriorityDefaultLow
        let leftImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        leftImageConstraint.priority = UILayoutPriorityDefaultHigh
        let heightImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: heightImage)
        let widthImageConstraint = NSLayoutConstraint(item: self.imgModernSearchBar, attribute:.width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthImage)        
        
        
        ///Label constraints
        let topLabelConstraint = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.top, relatedBy: .greaterThanOrEqual, toItem: self.contentView, attribute: .top, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        topLabelConstraint.priority = UILayoutPriorityDefaultHigh
        let bottomLabelConstraint = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.bottom, relatedBy: .lessThanOrEqual, toItem: self.contentView, attribute: .bottom, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        bottomLabelConstraint.priority = UILayoutPriorityDefaultHigh
        let verticalLabelConstraint = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.centerYWithinMargins, relatedBy: .equal, toItem: self.contentView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0)
        let leftLabelConstraint = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.left, relatedBy: .equal, toItem: self.imgModernSearchBar, attribute: .right, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        leftLabelConstraint.priority = UILayoutPriorityDefaultHigh
        let leftLabelConstraintIfImageNil = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.left, relatedBy: .equal, toItem: self.contentView, attribute: .left, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        leftLabelConstraintIfImageNil.priority = UILayoutPriorityDefaultLow
        let rightLabelConstraint = NSLayoutConstraint(item: self.labelModelSearchBar, attribute:.right, relatedBy: .equal, toItem: self.contentView, attribute: .right, multiplier: 1.0, constant:  ModernSearchBarCell.defaultMargin)
        rightLabelConstraint.priority = UILayoutPriorityDefaultLow
        

        NSLayoutConstraint.activate([verticalImageConstraint, topImageConstraint, bottomImageConstraint, leftImageConstraint,heightImageConstraint, widthImageConstraint,
                                     verticalLabelConstraint, leftLabelConstraint, rightLabelConstraint, topLabelConstraint, bottomLabelConstraint, leftLabelConstraintIfImageNil])
    }
    
    ///Configure image of suggestionsView
    public func configureImage(choice: ModernSearchBar.Choice, searchImage: UIImage, suggestionsListWithUrl: Array<ModernSearchBarModel>, position: Int, isImageRound: Bool, heightImage: CGFloat){
        switch choice {
        ///Show image from asset
        case .normal:
            self.imgModernSearchBar.image = searchImage
            break
        ///Show image from URL
        case .withUrl:
            let model = suggestionsListWithUrl[position]
            if (model.imgCache != nil){
                self.imgModernSearchBar.image = model.imgCache
            } else {
                self.downloadImage(model: model)
            }
            break
        }
        
        if (isImageRound){
            self.imgModernSearchBar.layer.cornerRadius = heightImage.divided(by: 2)
            self.imgModernSearchBar.clipsToBounds = true
        }
    }
    
    ///Otherwise constaint on label doesn't works...
    public func configureWidthMaxLabel(suggestionsViewWidth: CGFloat, searchImageWidth: CGFloat) {
        var widthMax: CGFloat = suggestionsViewWidth
        widthMax.subtract(ModernSearchBarCell.defaultMargin.multiplied(by: 3))
        widthMax.subtract(searchImageWidth)
        self.labelModelSearchBar.preferredMaxLayoutWidth = widthMax
    }
    
    //----------------------------
    
    private func downloadImage(model: ModernSearchBarModel) {
        DispatchQueue.global(qos: .background).async {
            self.getDataFromUrl(url: model.url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async() { () -> Void in
                    model.imgCache = image
                    self.imgModernSearchBar.image = image
                }
            }
        }
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            completion(data, response, error)
        }.resume()
    }    
}
