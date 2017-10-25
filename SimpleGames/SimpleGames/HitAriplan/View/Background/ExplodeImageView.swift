//
//  ExplodeImageView.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/17.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class ExplodeImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        ///动图数组
        var images = [UIImage]()
        for i in 0..<8{
            let animationImage = UIImage(named:String(format:"%d",i))
            images.append(animationImage!)
        }
        animationImages = images
        animationRepeatCount = 1
        animationDuration = 0.5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
