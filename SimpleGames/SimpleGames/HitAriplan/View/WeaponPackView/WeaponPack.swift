//
//  Magazine.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class WeaponPack: UIImageView {

    ///下落
    func dropDown(){
        transform = transform.translatedBy(x: 0, y: 2)
    }
}
