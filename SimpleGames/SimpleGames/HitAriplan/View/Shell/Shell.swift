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
        image = UIImage(named:"streak2")
    }
    
    ///发射炮弹
    func fireShell(){
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: self.xMove, y: -5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
