//
//  EnemyAirplanSmall.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/22.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class EnemyAirplanSmall: EnemyAirplan {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named:"enemy1")
    }
    
    override func dropDown() {
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: 0, y: 5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
