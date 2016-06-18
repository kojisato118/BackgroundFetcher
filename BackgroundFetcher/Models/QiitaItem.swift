//
//  QiitaItem.swift
//  BackgroundFetcher
//
//  Created by 佐藤 康次 on 2016/06/18.
//  Copyright © 2016年 佐藤 康次. All rights reserved.
//

import UIKit

class QiitaItem: NSObject, NSCoding {
    private(set) var title = ""
    private(set) var url = ""
    
    init(param : NSDictionary) {
        self.title = param["title"] as! String
        self.url = param["url"] as! String
    }
    
    // MARK: - Implements NSCoding protocol
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.url, forKey: "url")
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init()
        
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.url = aDecoder.decodeObjectForKey("url") as! String
    }
}
