//
//  GPLModels.swift
//  MyTool
//
//  Created by 顾鹏凌 on 2017/1/10.
//  Copyright © 2017年 顾鹏凌. All rights reserved.
//

import UIKit

class ListItemModel: NSObject {
    var name = ""
    var isShow = true


    init (name:String ,isShow:Bool) {
        super.init()
        self.name = name
        self.isShow = isShow
    }
    override init() {
        super.init()
    }
    
}


class GPLModels: NSObject {

}
