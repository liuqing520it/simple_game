//
//  Bullet.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/15.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class Shell: UIImageView {

    var xMove : CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        image = UIImage(named:"shell")
        
    }
    
    ///发射炮弹
    func fireShell(){
        center = CGPoint(x: center.x + xMove, y: center.y - 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
