//
//  BackgroundMapScrollView.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/16.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class BackgroundMapScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isScrollEnabled = false
        
        configUI()
    }
    
    //MARK: - 内部控制方法
    private func configUI(){
        for i in 0..<2{
            let imageView = UIImageView(image: UIImage(named:"map3"))
            imageView.frame = CGRect(x: 0, y: SCREEN_HEIGHT * CGFloat(i), width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            addSubview(imageView)
        }
        contentSize = CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
