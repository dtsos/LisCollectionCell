//
//  Article.swift
//  TestRing
//
//  Created by David Trivian S on 3/28/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import Foundation

class Article : NSObject{
    var id: String =  ""
    var title: String =  ""
    var author: String =  ""
    var thumbNail: String = ""
    var entryDate: Date?
    var prettyDate:String? = ""
    var totalComment:Int = 0
    var heightCellPortait:Double = 0.0
    var heightCellLandsacpe:Double = 0.0
    var url : String = ""
    var imageData:Data?
    //    var preview : String = ""
    override init() {
        super.init()
    }
    required convenience init(coder decoder: NSCoder) {
        self.init()
        
        if let archivedId = decoder.decodeObject(forKey: "id") as? String {
            id = archivedId
        }
        if let archivedTitle = decoder.decodeObject(forKey: "title") as? String {
            title = archivedTitle
        }
        
        if let archiveAuthor = decoder.decodeObject(forKey: "author") as? String {
            author = archiveAuthor
        }
        
        if let archivedThumbnail = decoder.decodeObject(forKey: "thumbnail") as? String {
            thumbNail = archivedThumbnail
        }
        if let archivedUrl = decoder.decodeObject(forKey: "url") as? String {
            url = archivedUrl
        }
        if let archivedDate = decoder.decodeObject(forKey: "entryDate") as? Date {
            entryDate = archivedDate
        }
        if let archivedComment = decoder.decodeObject(forKey: "totalComment") as? Int {
            totalComment = archivedComment
        }
        if let archivedImageData = decoder.decodeObject(forKey: "imageData") as? Data {
            imageData =  archivedImageData
        }
        if let archivedHeightCellPortait = decoder.decodeObject(forKey: "heightCellPortait") as? Double {
            heightCellPortait =  archivedHeightCellPortait
        }
        if let archivedHeightCellLandscape = decoder.decodeObject(forKey: "heightCellLandsacpe") as? Double {
            heightCellLandsacpe =  archivedHeightCellLandscape
        }
        
    }
    class func article(dictionary:[String:AnyObject]?) ->Article?{
        let anArticle = Article()
        if let dictionary = dictionary  {
            
            
            anArticle.id = dictionary["id"] as! String
            anArticle.title = dictionary["title"] as? String ?? ""
            anArticle.author = dictionary["author"] as? String ?? ""
            anArticle.url  = dictionary["url"] as? String ?? ""
            anArticle.thumbNail  = dictionary["thumbnail"] as? String ?? ""
            anArticle.totalComment =  dictionary["num_comments"] as? Int ?? 0
            //        anArticle.imageData  = (dictionary["imageData"] as? Data)!
            if let doubleDate:Double = dictionary["created_utc"] as? Double {
                let timeInterval =  doubleDate
                let theDate = Date(timeIntervalSince1970:TimeInterval(timeInterval))
                anArticle.entryDate =  theDate
            }
            return anArticle
        }
        return nil
        
    }
    @objc func stringDescription(){
        print("title : \(self.title), author : \(self.author) ,thumbnail : \(self.thumbNail) ,url : \(self.url), date : \(String(describing: self.entryDate))")
    }
}
extension Article: NSCoding {
    func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(author, forKey: "author")
        coder.encode(title, forKey: "title")
        coder.encode(thumbNail, forKey: "thumbNail")
        coder.encode(entryDate, forKey: "entryDate")
        coder.encode(totalComment, forKey: "totalComment")
        coder.encode(url, forKey: "url")
        coder.encode(imageData, forKey:"imageData")
        coder.encode(heightCellPortait, forKey:"heightCellPortait")
        coder.encode(heightCellLandsacpe, forKey:"heightCellLandsacpe")
        
    }
    
}
