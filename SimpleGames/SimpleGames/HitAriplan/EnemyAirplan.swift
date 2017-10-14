//
//  EnemyAirplan.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class EnemyAirplan: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named:"enemyplane")
        sizeToFit()
    }
    
    
    func dropDown(){
        center = CGPoint(x: center.x, y: center.y + 2)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
