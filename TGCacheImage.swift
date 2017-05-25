//
//  TGCacheImage.swift
//  TJSwift
//
//  Created by 蔡国龙 on 2017/5/9.
//  Copyright © 2017年 TG. All rights reserved.
//

import UIKit

class TGCacheImage: NSObject {

   private var imageCache = NSCache<AnyObject, AnyObject>.init()
   private var operations = Dictionary<String, Any>.init()
   private var downloadQueue = OperationQueue.init()

    static let shareInstance : TGCacheImage = {
        let instance = TGCacheImage()
        return instance
    }()
    
    func getImage(urlStr : String,placeholder : String,compleHandler : @escaping ((_ image : UIImage?,_ error : NSError?) ->Void)) {
        let keyStr = urlStr.md5String()
        var  image = self.imageCache.object(forKey: keyStr as AnyObject)
        if image != nil {
            compleHandler(image as? UIImage,nil)
        }else
        {
            let cachesPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.picturesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
            
            let fullPath = cachesPath?.appending("\\\(keyStr)")
            let imageData = NSData.init(contentsOfFile: fullPath!)
            if imageData != nil {
                image = UIImage.init(data: imageData! as Data)
                self.imageCache.setObject(image!, forKey: keyStr as AnyObject)
                compleHandler(image as? UIImage,nil)
            }else
            {
                
                compleHandler(UIImage.init(named: placeholder),nil)
                let download = self.operations[keyStr]
                if  download != nil {//已经开始下载不需要重复下载
                    
                }else
                {
                   let  download = BlockOperation.init(block: {
                    if let imageData = NSData.init(contentsOf: URL.init(string: urlStr)!){
                        
                        if let image = UIImage.init(data: Data.init(referencing: imageData)){
                                //如果image存在
                          
//                            //回到主线程 传值
                            OperationQueue.main.addOperation {
//                                print(Thread.current)
                                compleHandler(image,nil)
                            }
//                            print(Thread.current)
                                //写入缓存
                                self.imageCache.setObject(image, forKey: keyStr as AnyObject)
                                //写入沙盒
                                imageData.write(toFile: fullPath!, atomically: true)
                                // 移除下载操作
                                self.operations.removeValue(forKey: keyStr)
                            }else{
                                self.operations.removeValue(forKey: keyStr)
                                //网络错误
                                let error = NSError.init(domain: "网络错误", code: 118, userInfo: nil)
                                //回到主线程 传值
                                OperationQueue.main.addOperation {
                                    compleHandler(nil,error)
                                }
                            
                            }
                    
                        }
                    })
                   
                    
                    self.operations[keyStr] = download
                    self.downloadQueue.addOperation(download)
                    
                }
            }
            
            
        }
    }
//
}
