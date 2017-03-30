//
//  ManagerShared.swift
//  TestRing
//
//  Created by David Trivian S on 3/28/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import Foundation
class ManagerShared {
    static let sharedInstance = ManagerShared()
    fileprivate let fileName = "arrayArticle"
    var listArticle = [Article]()
    init() {
        unarchiceArticles()
    }
    func addArticle(_ article:Article?){
        guard let article = article else {
            return
        }
        listArticle.append(article)
    }
    
    func articleForId(_ id: String) -> Article? {
        for article in listArticle {
            if article.id == id {
                return article
            }
        }
        
        return nil
    }
    func unarchiceArticles(){
        let dirPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as String
        let pathArray = [dirPath, fileName]
        let fileURL =  NSURL.fileURL(withPathComponents: pathArray)!
        
        let path = fileURL.path
        let articles = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        if articles != nil {
            debugPrint(articles as! [Article])
            listArticle = articles as! [Article]
        }
    }
    func archivedArtilces(){
        if listArticle.count <= 50 {
            
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0] as String
            let pathArray = [dirPath, fileName]
            let fileURL =  NSURL.fileURL(withPathComponents: pathArray)!
            
            NSKeyedArchiver.archiveRootObject(listArticle, toFile: fileURL.path)
        }
    }
}
