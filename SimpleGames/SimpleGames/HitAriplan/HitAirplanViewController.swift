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
    
    fileprivate var myAirplanFrame = CGRect(x: (SCREEN_WIDTH - airplanWidth) * 0.5, y: SCREEN_HEIGHT - airplanWidth - 20, width: airplanWidth, height: airplanHeight)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertTips("开始游戏?", "开始", "退出") {
            self.initTimer()
        }
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
    fileprivate func alertTips(_ title : String , _ doActionTitle : String , _ cancelActionTitle :   String , doCallBack:@escaping ()->()){
        let alertVC = UIAlertController(title: title, message: "", preferredStyle: UIAlertControllerStyle.alert);
        let beginAction = UIAlertAction(title: doActionTitle, style: UIAlertActionStyle.default) { (_) in
            
            alertVC.dismiss(animated: true, completion: nil)
            
            doCallBack()
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)
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
        myAirplan.maxAttck = 4
        
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
    
    private lazy var myAirplan = MyAirplan(frame: myAirplanFrame)
    
}


//MARK: - 开启定时器后续操作
extension HitAirplanViewController {
    
    ///开启定时器
    fileprivate func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    }
    
    static var i : Int = 0
    @objc private func startTimer(){
        ///创建敌机
        if HitAirplanViewController.i%100 == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
            let enamyAirplan = EnemyAirplan(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth, height: airplanHeight))
            view.insertSubview(enamyAirplan, belowSubview: scoreLabel)
            enemyAirplanes.append(enamyAirplan)
        }
        //敌机下落
        dropEnemyAirplan()
        
        ///创建炮弹
        if HitAirplanViewController.i%30 == 0 {
            for shells in myAirplan.createShell(){
                view.insertSubview(shells, belowSubview: scoreLabel)
                shellsArray.append(shells)
            }
        }
        ///发射炮弹
        sendShell()
        
        ///判断是否击中
        isHitEnemyAirplan()
        
        ///判断是否游戏结束
        isGameover()
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
    
    //MARK: - 判断是否被敌机撞毁
    private func isGameover(){
        ///计算"我机"各个边的中心点
        let myAirplanTopCenter = CGPoint(x: myAirplan.frame.origin.x + myAirplan.frame.width * 0.5, y: myAirplan.frame.origin.y)
        let myAirplanBottomCenter = CGPoint(x: myAirplan.frame.maxX - myAirplan.frame.width * 0.5, y: myAirplan.frame.maxY)
        let myAirplanLeftCenter = CGPoint(x: myAirplan.frame.origin.x, y: myAirplan.frame.origin.y + myAirplan.frame.size.height * 0.5)
        let myAirplanRightCenter = CGPoint(x: myAirplan.frame.origin.x +  myAirplan.frame.size.width, y: myAirplan.frame.origin.y + myAirplan.frame.size.height * 0.5)
        
        for enemyAP in enemyAirplanes{
            //如果我机 撞毁 则弹窗提示
            if  enemyAP.frame.contains(myAirplanTopCenter) ||
                enemyAP.frame.contains(myAirplanBottomCenter) ||
                enemyAP.frame.contains(myAirplanLeftCenter) ||
                enemyAP.frame.contains(myAirplanRightCenter) {
                ///1.停止定时器
                timer?.invalidate()
                timer = nil
                ///2.弹窗提示
                alertTips("游戏结束!", "重新开始", "退出游戏", doCallBack: {
                    //重新开始
                    self.resetGame()
                })
            }
        }
    }
    
    //MARK: - 重新开始 清除一些操作
    private func resetGame(){
        ///清空分数
        scoreLabel.text = "00000"
        ///清除敌机
        for enemyAP in enemyAirplanes{
            removeEnemyAirplan(enemyAP)
        }
        ///清除炮弹
        for shells in shellsArray{
            removeShells(shells)
        }
        ///初始化timer重新开始
        initTimer()
        //将我机 移到最初位置
        UIView.animate(withDuration: 0.25) {
            self.myAirplan.frame = self.myAirplanFrame
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







