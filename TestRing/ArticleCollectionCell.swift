//
//  ArticleCollectionCell.swift
//  TestRing
//
//  Created by David Trivian S on 3/29/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import Foundation
import UIKit
class ArticleCollectionCell : UICollectionViewCell {
    
    var actionOpenURLTap: ((UICollectionViewCell) -> Void)?
    @IBAction func buttonTap(_ sender: UIButton) {
        actionOpenURLTap!(self)
        
    }
    @IBOutlet weak var buttonGallery: UIButton!
    
    @IBAction func actionSaveGallery(_ sender: UIButton) {
        actionSaveGalleryTap!(self)
    }
    
    var actionSaveGalleryTap: ((UICollectionViewCell) -> Void)?
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAuthor: UILabel!
    
    @IBOutlet weak var labelTotalComment: UILabel!
    @IBOutlet weak var imageArticleThumbnail: UIImageView!
    
    var article:Article?
    fileprivate var currentArticle: Article!
    
    
    fileprivate var currentArticleId = ""
    
    var articleId: String {
        get {
            return currentArticleId
        }
        set(newArticleId) {
            currentArticleId = newArticleId
            currentArticle = ManagerShared.sharedInstance.articleForId(articleId)!
            if currentArticle != nil && currentArticle.thumbNail != ""{
                if let data:Data = currentArticle.imageData {
                    
                    imageArticleThumbnail.image = UIImage(data: data)
                    
                }else{
                    self.imageArticleThumbnail.loadURL(URL(string:currentArticle!.thumbNail)) { (success,data) in
                        if success {
                            
                            self.currentArticle.imageData = data!
                        }else{
                            
                        }
                    }
                }
            }
        }
    }
    func config() {
        if currentArticle.imageData != nil {
            
            imageArticleThumbnail.image = UIImage(data: currentArticle.imageData!)
        }else{
            
            imageArticleThumbnail.image = UIImage(named: "defaultImage")
        }
        
    }
    override func prepareForReuse() {
        config()
    }
    
    override func layoutSubviews() {
        config()
        
    }
    
    
}
