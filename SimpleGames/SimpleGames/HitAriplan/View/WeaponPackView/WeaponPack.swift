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
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: 0, y: 5)
        }
    }
}
