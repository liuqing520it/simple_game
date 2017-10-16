//
//  HitAirplanViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

let airplanWidth : CGFloat = 40.0

let airplanHeight = airplanWidth

class HitAirplanViewController: UIViewController {
    
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         alertTips()
    }
    
    //隐藏状态栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    deinit {
       print("销毁了")
    }
    
    //MARK: - 内部控制方法
    ///弹出提示框
    private func alertTips(){
        let alertVC = UIAlertController(title: "开始游戏", message: "", preferredStyle: UIAlertControllerStyle.alert);
        let beginAction = UIAlertAction(title: "开始", style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
            
            self.initTimer()
            
//            self.backgroundImageAnimate()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(beginAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    ///添加子控件
    private func configUI(){
        
        view.addSubview(backgroundImageView)
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("exit", for: .normal)
        backBtn.setTitleColor(UIColor.red, for: .normal)
        backBtn.frame = CGRect(x: 20, y: 10, width: 0, height: 0)
        backBtn.sizeToFit()
        backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(backBtn)
        
        view.addSubview(myAirplan)
//        myAirplan.maxAttck = 3
        
        view.addSubview(scoreLabel)
        scoreLabel.frame.origin.x = view.frame.maxX - scoreLabel.frame.size.width - 20
        scoreLabel.frame.origin.y = 20
    }
    
    ///退出游戏按钮点击
    @objc private func btnClick(){
        ///退出后将定时器 销毁
        timer?.invalidate()
        timer = nil
        dismiss(animated: true, completion: nil)
    }
    ///背景图片循环动画
    private func backgroundImageAnimate(){
        UIView.animate(withDuration: 2) {
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.backgroundImageView.frame.origin.y = 0
        }
    }

    
    ///MARK: - 懒加载
    ///背景图片
    fileprivate lazy var backgroundImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named:"map"))
        imageV.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return imageV
    }()
    ///积分label
    fileprivate lazy var scoreLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor.red
        label.text = "00000"
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    
    ///存放敌机数组
    private lazy var enemyAirplanes = [EnemyAirplan]()
    
    ///存放炮弹数组
    fileprivate lazy var shellsArray = [Shell]()
    
    private lazy var myAirplan = MyAirplan(frame: CGRect(x: (SCREEN_WIDTH - airplanWidth) * 0.5, y: SCREEN_HEIGHT - airplanWidth - 20, width: airplanWidth, height: airplanHeight))
    
}


//MARK: - 开启定时器后续操作
extension HitAirplanViewController {
    
    ///开启定时器
    fileprivate func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.08, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    static var i : Int = 0
    @objc private func startTimer(){
        ///创建敌机
        if HitAirplanViewController.i%80 == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
            let enamyAirplan = EnemyAirplan(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth, height: airplanHeight))
            view.insertSubview(enamyAirplan, belowSubview: scoreLabel)
            enemyAirplanes.append(enamyAirplan)
        }
        //敌机下落
        dropEnemyAirplan()
        
        ///创建炮弹
        if HitAirplanViewController.i%50 == 0 {
            for shells in myAirplan.createShell(){
                view.insertSubview(shells, belowSubview: scoreLabel)
                shellsArray.append(shells)
            }
        }
        ///发射炮弹
        sendShell()
        
        ///判断是否击中
        isHitEnemyAirplan()
        
//        print(">>>>>>>>>>>>")
//        print("敌机数量\(enemyAirplanes.count)")
//        print("---------")
//        print("子弹数量\(shellsArray.count)")
//        print("<<<<<<<<<<<<")
        
        HitAirplanViewController.i += 1
    }
    
    //MARK: - 下落敌机
    private func dropEnemyAirplan(){
        for enemy in enemyAirplanes{
            enemy.dropDown()
            ///如果超出了屏幕 从父控件移除还要从数组中移除
            if view.frame.contains(enemy.frame) == false {
               removeEnemyAirplan(enemy)
            }
        }
    }
    
    //MARK: - 发射炮弹
    private func sendShell(){
        for shells in shellsArray{
            shells.fireShell()
            ///如果超出了父控件需要移除
            if view.frame.contains(shells.frame) == false {
                removeShells(shells)
            }
        }
    }
    
    //MARK: - 判断是否被击中
    static var score : Int = 0
    private func isHitEnemyAirplan(){
        ///遍历敌机数组
        for enemyAp in enemyAirplanes{
            ///遍历炮弹数组
            for shells in shellsArray{
                ///取出炮弹顶部的中心点
                let shellsOrigin = CGPoint(x: shells.frame.origin.x + shells.frame.width * 0.5, y: shells.frame.origin.y)
                ///如果敌机的frame包含炮弹的顶部中心点则需要移除
                if enemyAp.frame.contains(shellsOrigin){
                    removeEnemyAirplan(enemyAp)
                    removeShells(shells)
                    ///没击中后计分
                    HitAirplanViewController.score += 100
                    scoreLabel.text = String(format:"%05d",HitAirplanViewController.score)
                }
            }
        }
    }
    
    //MARK: - 移除操作
    ///移除敌机
    private func removeEnemyAirplan(_ enemyAirPlan : EnemyAirplan){
        ///从父控件中移除
        enemyAirPlan.removeFromSuperview()
        ///从敌机数组中移除
        enemyAirplanes.remove(at: enemyAirplanes.index(of: enemyAirPlan)!)
    }
    
    ///移除子弹
    private func removeShells(_ shells : Shell){
        ///从父控件中移除
        shells.removeFromSuperview()
        ///从炮弹数组中移除
        shellsArray.remove(at: shellsArray.index(of: shells)!)
    }
    
}







