//
//  BottomBarrier.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class BottomBarrier: BarrierMain {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImage(named:"BottomLog")
        
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
