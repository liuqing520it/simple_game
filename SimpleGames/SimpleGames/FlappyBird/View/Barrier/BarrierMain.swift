//
//  BarrierMain.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/9.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class BarrierMain: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("233")
    }
    
    ///往左移动
    func moveToLeft(){
        UIView.animate(withDuration: 0.25) {
            self.transform = self.transform.translatedBy(x: -1, y: 0)
        }
    }

}
