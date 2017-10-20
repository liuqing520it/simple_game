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
    ///定时器
    private var timer : Timer?
    ///'我机'的frame
    private var myAirplanFrame = CGRect(x: (SCREEN_WIDTH - airplanWidth) * 0.5, y: SCREEN_HEIGHT - airplanWidth - 20, width: airplanWidth, height: airplanHeight)
    
    ///控制下落速度
    private var dropSpeed : Int = 200
    ///控制移动速度
    private var gameSpeed : Int = 1
    ///控制timer duration 速度
    private var durationSpeed : TimeInterval = 0.1
    
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

    //MARK: - 内部控制方法
    ///添加子控件
    private func configUI(){
        view.addSubview(backgroundScrollView)
        backgroundScrollView.contentOffset.y = SCREEN_HEIGHT
        
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("exit", for: .normal)
        backBtn.setTitleColor(UIColor.red, for: .normal)
        backBtn.frame = CGRect(x: 20, y: 10, width: 0, height: 0)
        backBtn.sizeToFit()
        backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(backBtn)
        
        view.addSubview(myAirplan)
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
    
    ///MARK: - 懒加载
    ///背景图片
    fileprivate lazy var backgroundScrollView = BackgroundMapScrollView(frame: UIScreen.main.bounds)
    ///积分label
    fileprivate lazy var scoreLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.text = "000000"
        label.textAlignment = .right
        label.sizeToFit()
        return label
    }()
    ///存放敌机的数组
    private lazy var enemyAirplanes = [EnemyAirplan]()
    ///存放击中爆炸的数组
    private lazy var explodeAnimationViews = [ExplodeImageView]()
    ///存放炮弹的数组
    private lazy var shellsArray = [Shell]()
    ///"用户飞机"
    private lazy var myAirplan = MyAirplan(frame: myAirplanFrame)
}

//MARK: - 开启定时器后续操作
extension HitAirplanViewController {
    ///开启定时器
    fileprivate func initTimer(){
        self.timer = Timer.scheduledTimer(timeInterval: durationSpeed, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    static var i : Int = 0
    @objc private func startTimer(){
        
        ///背景图片移动
        UIView.animate(withDuration: 0.25) {
            self.backgroundScrollView.contentOffset.y -= CGFloat(self.gameSpeed)
        }
        
        ///创建敌机
        //%的值越小 敌机越多
        if HitAirplanViewController.i%dropSpeed == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
            let enamyAirplan = EnemyAirplan(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth * 2, height: airplanHeight * 2))
            view.insertSubview(enamyAirplan, belowSubview: scoreLabel)
            enemyAirplanes.append(enamyAirplan)
        }
        //敌机下落
        dropEnemyAirplan()
        
        ///创建炮弹
        //%的值越小 炮弹越多
        if HitAirplanViewController.i%dropSpeed == 0 {
            for shells in myAirplan.createShell(){
                view.insertSubview(shells, belowSubview: self.scoreLabel)
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
        
        //加得越多 走的越快
        HitAirplanViewController.i += gameSpeed
        
        ///无限循环 背景图片
        if backgroundScrollView.contentOffset.y < 0 {
            backgroundScrollView.setContentOffset(CGPoint.init(x: 0, y: SCREEN_HEIGHT), animated: false)
        }
        
    }
    
    //MARK: - 下落敌机
    private func dropEnemyAirplan(){
        for enemy in enemyAirplanes{
            enemy.dropDown()
            ///如果超出了屏幕 从父控件移除还要从数组中移除
            ///敌机顶部任一点 超出屏幕
            let topPoint = CGPoint(x: enemy.frame.origin.x, y: enemy.frame.origin.y)
            if view.frame.contains(topPoint) == false {
               removeEnemyAirplan(enemy)
            }
        }
    }
    
    //MARK: - 发射炮弹
    private func sendShell(){
        for shells in shellsArray{
            shells.fireShell()
            ///如果超出了父控件需要移除
            if shells.frame.maxX < myAirplan.center.x{//在"我机"左边的子弹
                ///底部右下角超出屏幕
                let bottomRightPoint = CGPoint(x: shells.frame.maxX, y: shells.frame.maxY)
                if view.frame.contains(bottomRightPoint) == false {
                    removeShells(shells)
                }
            }
            else{//在"我机"右边的子弹
                ///底部左下角超出屏幕
                let bottomLeftPoint = CGPoint(x: shells.frame.maxX - shells.frame.width, y: shells.frame.maxY)
                if view.frame.contains(bottomLeftPoint) == false {
                    removeShells(shells)
                }
            }
        }
    }
    
    //MARK: - 判断是否被击中敌机
    static var score : Int = 0
    private func isHitEnemyAirplan(){
        ///遍历敌机数组
        for enemyAp in enemyAirplanes{
            ///遍历炮弹数组
            for shells in shellsArray{
                ///取出炮弹顶部的中心点
                let shellsOrigin = CGPoint(x: shells.frame.origin.x + shells.frame.width * 0.5, y: shells.frame.origin.y + 8)
                ///如果敌机的frame包含炮弹的顶部中心点则需要移除
                if enemyAp.frame.contains(shellsOrigin){
                    removeEnemyAirplan(enemyAp)
                    removeShells(shells)
                    //展示击中动画
                    explodeAnimation(enemyAp.frame)
                    ///击中后计分
                    HitAirplanViewController.score += 100
                    scoreLabel.text = String(format:"%06d",HitAirplanViewController.score)
                    exchangeGameLevel()
                }
            }
        }
    }
    
    //MARK: - 根据分数 增加游戏难度
    private func exchangeGameLevel(){
        let currentScore = HitAirplanViewController.score
        if currentScore == 1000 {
            dropSpeed -= 50
        }
        else if currentScore == 5000{
            dropSpeed -= 100
        }
        else if currentScore == 10000{
            dropSpeed -= 200
        }
    }
    
    //MARK: - 击中爆炸动图
    private func explodeAnimation(_ frame : CGRect){
        //创建爆炸动图
        let explodeIV = ExplodeImageView(frame: frame)
        view.addSubview(explodeIV)
        if explodeIV.isAnimating == false{
            //开始动画
            explodeIV.startAnimating()
            //添加到数组中
            explodeAnimationViews.append(explodeIV)
        }
        ///这里不知道动画什么时候执行完毕 所以添加到数组里 遍历判断 isAnimating为fasle的时候清除爆炸动画图片
        deleteExplodeAnimationViews()
    }
    
    //删除爆炸动图
    private func deleteExplodeAnimationViews(){
        for animationView in explodeAnimationViews {
            //如果动画执行完成
            if animationView.isAnimating == false{
                guard let index = explodeAnimationViews.index(of: animationView) else {
                    break
                }
                //从数组中删除
                explodeAnimationViews.remove(at: index)
                //从父控件中删除
                animationView.removeFromSuperview()
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
        HitAirplanViewController.score = 0
        scoreLabel.text = "000000"
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
        guard let index = enemyAirplanes.index(of: enemyAirPlan) else {
            return
        }
        ///从敌机数组中移除
        enemyAirplanes.remove(at: index)
        ///从父控件中移除
        enemyAirPlan.removeFromSuperview()
    }
    
    ///移除子弹
    private func removeShells(_ shells : Shell){
        guard let index = shellsArray.index(of: shells) else {
            return
        }
        ///从炮弹数组中移除
        shellsArray.remove(at: index)
        ///从父控件中移除
        shells.removeFromSuperview()
    }
}


//MARK: - 提示框封装
extension HitAirplanViewController{
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
}





