//
//  FlappyMainViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/5.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

///障碍物的宽度
let kBarrierWidth : CGFloat = 100
///障碍物的高度
let kBarrierHeight : CGFloat = 512

//游戏主界面
class FlappyMainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        configUI()
        
        initTimer()
    }
    
    private func configUI(){
  
    }
    
    ///顶部障碍物
    private var topArray = [TopBarrier]()
    
    ///底部障碍物
    private var bottomArray = [BottomBarrier]()
    
    ///定时器
    private var timer : Timer?
}


//MARK: - 定时器开启
extension FlappyMainViewController  {
    
/// 初始化定时器
    private func initTimer(){
        timer = Timer.init(timeInterval: 0.02, repeats: true, block: { (timer) in
            self.startGame()
        });
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    static var i : Int = 0
    private func startGame(){
        
        if FlappyMainViewController.i % 150 == 0 {
            let topBarrier = TopBarrier(frame: CGRect(x: SCREEN_WIDTH  , y: 0, width: kBarrierWidth, height: kBarrierHeight))
            view.addSubview(topBarrier)
            topArray.append(topBarrier)
            
            let bottomBarrier = BottomBarrier(frame: CGRect(x: SCREEN_WIDTH, y: SCREEN_HEIGHT - 100, width: kBarrierWidth, height: kBarrierHeight))
            view.addSubview(bottomBarrier)
            bottomArray.append(bottomBarrier)
            
        }
        
        moves()
        
        FlappyMainViewController.i += 1
      
    }
    
    private func moves(){
        for top in topArray{
            top.moveToLeft()
        }
        for bottom in bottomArray{
            bottom.moveToLeft()
        }
    }
    
}














