//
//  EnemyAirplan.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/24.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class EnemyAirplan: UIImageView {

    ///被炮弹击中的次数
    var hitNumber : Int = 0
    
    //下落方法
    func dropDown(){
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: 0, y: 4)
        }
    }

}
