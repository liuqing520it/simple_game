//
//  FlappyMainViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/5.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

///障碍物的宽度
let kBarrierWidth : CGFloat = 80
///障碍物的高度
let kBarrierHeight : CGFloat = 500

//游戏主界面
class FlappyMainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        configUI()
        
        initTimer()
    }
    
    private func configUI(){
       configBarrier()
    }
    
    private func configBarrier(){
        let tall = CGFloat(arc4random() % 200) + SCREEN_WIDTH
        
        topBarrier = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH, y: -(kBarrierHeight - tall), width: kBarrierWidth, height: kBarrierHeight))
        
        topBarrier.image = UIImage(named:"TopLog")
        view.addSubview(topBarrier)
        
        bottomBarrier = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH, y: tall + 70, width: kBarrierWidth, height: kBarrierHeight))
        bottomBarrier.image = UIImage(named:"BottomLog")
        view.addSubview(bottomBarrier)
    }
    
    ///头部障碍物
    private lazy var topBarrier = UIImageView()
    ///底部障碍物
    private lazy var bottomBarrier = UIImageView()
    ///定时器
    private var timer : Timer?
}


//MARK: - 定时器开启
extension FlappyMainViewController  {
    
/// 初始化定时器
    private func initTimer(){
        timer = Timer.init(timeInterval: 0.01, repeats: true, block: { (timer) in
            self.startGame()
        });
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    private func startGame(){
        topBarrier.frame.origin.x -= 1
        bottomBarrier.frame.origin.x -= 1
      
        if topBarrier.frame.origin.x < -kBarrierWidth {
            configBarrier()
        }
        
    }
    
}














