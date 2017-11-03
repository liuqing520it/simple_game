//
//  EnemyShell.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/31.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class EnemyShell: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named:"Battle_Enemy")
    }
    
//    敌机发射子弹
    func dropDown(){
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: 1, y: 5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
