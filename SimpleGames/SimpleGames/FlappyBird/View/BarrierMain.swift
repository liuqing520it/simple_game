//
//  BarrierMain.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class BarrierMain: UIImageView {

    ///往左移动
    func moveToLeft(){
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: -2, y: 0)
        }
    }

}
