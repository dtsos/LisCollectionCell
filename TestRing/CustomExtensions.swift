//
//  CustomExtensions.swift
//  TestRing
//
//  Created by David Trivian S on 3/29/17.
//  Copyright © 2017 David Trivian S. All rights reserved.
//

import UIKit
public let UserDefaultKey_ListReditPagingAfter = "ListRedit_Paging_After"
extension UIImageView {
    
    func loadURL(_ url: URL?,completionHandler:  @escaping (Bool,Data?) -> Swift.Void) {
        guard let url = url else {
            completionHandler(false,nil)
            return
        }
        let urlRequest = URLRequest(url: url)
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            if let response = response, let data = data, response.isHTTPResponseValid() {
                DispatchQueue.main.async(execute: { () -> Void in
                    if UIImage(data: data) == nil {
                        self.image = UIImage(named: "standardCat")
                        completionHandler(false,nil)
                    } else {
                        
                        self.image = UIImage(data: data)
                        completionHandler(true,data)
                    }
                })
            }else{
                completionHandler(false,nil)
            }
        }) .resume()
    }
    
}
extension String {
    //convert day ago
    func dateDiff() -> String {
        let df: DateFormatter = DateFormatter()
        df.formatterBehavior = .behavior10_4
        df.locale = Locale(identifier:"id")
        df.dateFormat = "EEEE, dd/MM/yyyyy HH:mm:ss"
        
        if let convertedDate: Date = df.date(from: self){
            
            let todayDate: Date = Date()
            var ti: Double = convertedDate.timeIntervalSince(todayDate)
            ti = ti * -1
            if ti < 1 {
                return "now"
            }
            else if ti < 60 {
                return "less than a minute ago"
            }
            else if ti < 3600 {
                let diff: Int = Int(round(ti / 60))
                return "\(diff) minutes ago"
            }
            else if ti < 86400 {
                let diff: Int = Int(round(ti / 60 / 60))
                return "\(diff) hours ago"
            }
            else if ti < 2629743 {
                let diff: Int = Int(round(ti / 60 / 60 / 24))
                return "\(diff) days ago"
            }
            else {
                return "never"
            }
        }else{
            
            return "problem"
        }
        
        
    }

}


