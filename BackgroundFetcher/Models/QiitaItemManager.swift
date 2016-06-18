//
//  QiitaItemManager.swift
//  BackgroundFetcher
//
//  Created by 佐藤 康次 on 2016/06/18.
//  Copyright © 2016年 佐藤 康次. All rights reserved.
//

import UIKit
import Alamofire

class QiitaItemManager: NSObject {
    private(set) var items : [QiitaItem] = []
    
    func reloadDataFromLocalWithHandler(handler : ([QiitaItem]) -> Void){
        if let filePath = self.filePath(){
            if let data = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? [QiitaItem]{
                self.items = data
                
                handler(self.items)
                return
            }else{
                handler([])
            }
        }else{
            handler([])
        }
    }
    
    func reloadDataFromServerWithHandler(handler : ([QiitaItem]) -> Void){
        self.items = []
        let url = "https://qiita.com/api/v2/items"
        
        Alamofire.request(.GET, url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success:
                    if let JSON = response.result.value as? [NSDictionary] {
                        for item in JSON{
                            let qiita = QiitaItem(param: item)
                            self.items.append(qiita)
                        }
                        self.save()
                        handler(self.items)
                        return
                    }
                case .Failure(let error):
                    print(error)
                }
                handler([])
        }
    }
    
    func deleteItems(){
        self.items = []
        
        guard let filePath = self.filePath() else{
            return
        }
        
        let manager = NSFileManager()
        do {
            try manager.removeItemAtPath(filePath)
        }
        catch let error{
            print(error)
        }
    }
    
    private func save(){
        if let filePath = self.filePath(){
            if NSKeyedArchiver.archiveRootObject(self.items, toFile: filePath) {
                print("file save success!")
            } else {
                print("file save failured!")
            }
        }
    }
    
    private func filePath() -> String?{
        // /Documentsまでのパス取得
        if let dir : NSString = NSSearchPathForDirectoriesInDomains( .DocumentDirectory, .UserDomainMask, true ).first {
            
            return dir.stringByAppendingPathComponent("qiita_items.dat")
        }
        
        return nil
    }

}
