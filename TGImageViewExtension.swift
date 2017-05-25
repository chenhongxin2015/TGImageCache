//
//  TGImageViewExtension.swift
//  TJSwift
//
//  Created by 蔡国龙 on 2017/5/9.
//  Copyright © 2017年 TG. All rights reserved.
//

import Foundation
import UIKit
extension UIImageView{
    func getImage(urlStr : String,placeholder : String) {
        TGCacheImage.shareInstance.getImage(urlStr: urlStr, placeholder:placeholder ) { (image, error) in
            if error == nil{
                self.image = image
            }else{
                print("网络错误")
            }
        }
    }
}
