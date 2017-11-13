//
//  FlappyMainViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/5.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

///小鸟的高
let kBirdWidth : CGFloat = 80
///小鸟的宽
let kBirdHeight = kBirdWidth
///障碍物的宽度
let kBarrierWidth : CGFloat = 100
///障碍物的高度
let kBarrierHeight : CGFloat = 512

//游戏主界面
class FlappyMainViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.white
        
        initTimer()
        
        configUI()
        
    }
    
    private func configUI(){
        
        view.addSubview(birdView)
        
        if birdView.isAnimating == false{
            birdView.startAnimating()
        }
        
    }
    
    //屏幕点击
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(">>>>>>")
    }
    
    ///记录小鸟是上升还是下降 是否点击默认是未点击
    private lazy var isTap = false
    ///顶部障碍物
    private lazy var topArray = [TopBarrier]()
    ///底部障碍物
    private lazy var bottomArray = [BottomBarrier]()
    ///bird
    private lazy var birdView = BirdImageView(frame: CGRect(x: 30, y: SCREEN_HEIGHT * 0.5, width: kBirdWidth, height: kBirdHeight))
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
            view.insertSubview(topBarrier, belowSubview: birdView)
            topArray.append(topBarrier)
            
            let bottomBarrier = BottomBarrier(frame: CGRect(x: SCREEN_WIDTH, y: SCREEN_HEIGHT - 100, width: kBarrierWidth, height: kBarrierHeight))
            view.insertSubview(bottomBarrier, belowSubview: birdView)
            bottomArray.append(bottomBarrier)
            
        }
        
        moves()
        
        FlappyMainViewController.i += 1
      
    }
    
//    开始移动
    private func moves(){
        for top in topArray{
            top.moveToLeft()
            if top.frame.maxX < 0{
                removeBarriers(top)
            }
            
        }
        
        for bottom in bottomArray{
            bottom.moveToLeft()
            if bottom.frame.maxX < 0{
                removeBarriers(bottom)
            }
        }
    }
    
//    超出部分删除
    private func removeBarriers(_ barrier : BarrierMain){
    
        var index : Int?
        
        if barrier.isMember(of: TopBarrier.self){
            index = topArray.index(of: barrier as! TopBarrier)
            topArray.remove(at: index!)
        }else if barrier.isMember(of: BottomBarrier.self){
            index = bottomArray.index(of: barrier as! BottomBarrier)
            bottomArray.remove(at: index!)
        }
        ///从父控件中移除
        barrier.removeFromSuperview()
    }
}


