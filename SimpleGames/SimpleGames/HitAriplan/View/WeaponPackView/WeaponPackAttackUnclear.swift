//
//  WeaponPackAttackUnclear.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/25.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class WeaponPackAttackUnclear: WeaponPack {

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named:"skill-3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
