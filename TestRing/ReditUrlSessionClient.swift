//
//  ReditUrlSessionClient.swift
//  TestRing
//
//  Created by David Trivian S on 3/28/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import Foundation
class ReditUrlSessionClient {
    var limit:Int = 10
    
    enum LoadingState {
        case NotLoading
        case Loading
        
        
    }
    var loadingState:LoadingState = .NotLoading
    static let sharedInstance =  ReditUrlSessionClient()
    public func ListTopReddit(after: String = "", countMaxArticle:Int = 0,completionHandler:  @escaping ([Article]?) -> Swift.Void){
        let getString = "limit=\(limit)&after=\(after)"
        var urlRequest = URLRequest(url: URL(string: "https://www.reddit.com/top/.json?\(getString)")!)
        urlRequest.httpMethod = "GET"
        self.loadingState = .Loading
        if countMaxArticle <= 50 {
            
            
            if (countMaxArticle  <= ManagerShared.sharedInstance.listArticle.count  &&  ManagerShared.sharedInstance.listArticle.count != 0 && after != "")  {
                
                completionHandler(ManagerShared.sharedInstance.listArticle)
                self.loadingState = .NotLoading
            }else{
               
                if(ManagerShared.sharedInstance.listArticle.count < 50){
                    URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
                        
                        self.loadingState = .NotLoading
                        if let response = response, let data =  data , response.isHTTPResponseValid(){
                            DispatchQueue.main.async(execute: { () -> Void in
                                do{
                                    guard let json = try JSONSerialization.jsonObject(with: data, options:[]) as? [String: AnyObject]  else{
                                        completionHandler(nil)
                                        
                                        return
                                    }
                                    
                                    guard let jsonKeyData = json["data"] else{
                                        completionHandler(nil)
                                        return
                                    }
                                    
                                    let arrayChildrenKeyData: [[String:AnyObject]]
                                        = jsonKeyData["children"] as! [[String:AnyObject]]
                                    if after == ""  && arrayChildrenKeyData.count > 0{
                                        ManagerShared.sharedInstance.listArticle.removeAll()
                                    }
                                    for dictionary in arrayChildrenKeyData {
                                        
                                        guard let dictionaryData = dictionary["data"]  else{
                                            continue
                                        }
                                        let anArticle:Article = Article.article(dictionary: dictionaryData as? [String : AnyObject])!
                                        anArticle.stringDescription()
                                        ManagerShared.sharedInstance.addArticle(anArticle)
                                        
                                    }
                                    if let after =  jsonKeyData["after"]{
                                        UserDefaults.standard.set(after, forKey: "ListRedit_Paging_After")
                                        UserDefaults.standard.synchronize()
                                    }
                                    completionHandler(ManagerShared.sharedInstance.listArticle)
                                }catch{
                                    completionHandler(nil)
                                    return
                                }
                                
                            })
                            
                            
                        }
                        
                        
                    }).resume()
                }else{
                    completionHandler(nil)
                }
                
            }
        }else{
            completionHandler(nil)
        }
    }
}
extension URLResponse {
    func isHTTPResponseValid() -> Bool {
        guard let response = self as? HTTPURLResponse else {
            return false
        }
        
        return (response.statusCode >= 200 && response.statusCode <= 299)
    }
}
