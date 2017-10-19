//
//  MyAirplan.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/15.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class MyAirplan: UIImageView {

    ///攻击等级 默认是1
    var maxAttck : Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ///设置图片
        image = UIImage(named:"airplan")
        ///打开用户交互
        isUserInteractionEnabled = true
    }
    
    //MARK: - 外部控制方法
    //创建炮弹
    func createShell() -> [Shell]{
        if maxAttck > 5 {
            return [Shell]()
        }
        var shellsArray = [Shell]()
        ///火力等级数组
        ///等级1 一发炮弹
        ///等级2 两发炮弹
        ///等级3 三发炮弹
        ///等级4 五发炮弹
        let xMoveArray = [[0],[-1,1],[-1,0,1],[-2,-1,0,1,2]]
        for attck in 0..<maxAttck{
            shellsArray.append(singleShellCreate(CGFloat(xMoveArray[maxAttck-1][attck])))
        }
        if maxAttck == 4 {//火力等级为4 则使用5发炮弹
            shellsArray.append(singleShellCreate(CGFloat(xMoveArray[maxAttck-1][maxAttck])))
        }
        return shellsArray
    }
    
    ///单个炮弹
    private func singleShellCreate(_ xMove : CGFloat) -> Shell{
        let singleShell = Shell(frame: CGRect(x: frame.origin.x, y: frame.origin.y - airplanHeight, width: airplanWidth, height: airplanHeight))
        singleShell.xMove = xMove
        return singleShell
    }
    
    //MARK: - 内部控制
    //拖动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if frame.origin.x <= 0 {
            frame.origin.x = 0
        }
        if frame.origin.y <= 0 {
            frame.origin.y = 0
        }
        if frame.maxX >= SCREEN_WIDTH{
            frame.origin.x = SCREEN_WIDTH - airplanWidth
        }
        if frame.maxY >= SCREEN_HEIGHT{
            frame.origin.y = SCREEN_HEIGHT - airplanHeight
        }
        
        let touch = (touches as NSSet).allObjects.last
        // 获取当前点
        let curP = (touch as! UITouch).location(in: self)
        // 获取上一个点
        let preP = (touch as! UITouch).previousLocation(in: self)
        
        transform = self.transform.translatedBy(x: curP.x - preP.x, y: curP.y - preP.y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
