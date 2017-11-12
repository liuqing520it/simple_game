//
//  BirdImageView.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/12.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class BirdImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let images : [UIImage] = [UIImage(named:"Player0")!,UIImage(named:"Player1")!]
        
        animationImages = images
        animationRepeatCount = 0
        animationDuration = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
