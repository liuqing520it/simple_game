//
//  HitAirplanViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit
import SpriteKit
let airplanWidth : CGFloat = 80.0

let airplanHeight = airplanWidth

class HitAirplanViewController: UIViewController {
    ///定时器
    private var timer : Timer?
    ///'我机'的frame
    private var myAirplanFrame = CGRect(x: (SCREEN_WIDTH - airplanWidth) * 0.5, y: SCREEN_HEIGHT - airplanWidth - 20, width: airplanWidth, height: airplanHeight)
    ///控制timer duration 速度
    private var gameSpeed : Int = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initTimer()
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

        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(myAirplan)
        
        menuView.dismissCallBack = { (index) in
            if index == ClickIndex.ClickContinue{//继续
                self.timer?.fireDate = Date.distantPast
            }
            else if index == ClickIndex.ClickRestart{//重新开始
                self.timer?.fireDate = Date.distantPast
                self.resetGame()
            }
            else{//退出
                self.timer?.invalidate()
                self.timer = nil
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        view.addSubview(unclearButton)
        unclearButton.frame = CGRect(x: 10, y: SCREEN_HEIGHT - 50, width: 50, height: 40)
        unclearButton.addTarget(self, action: #selector(unclearClick), for: .touchUpInside)
    }
    
    ///游戏暂停 按钮点击
    @objc private func btnClick(){
        //先停止定时器
        timer?.fireDate = Date.distantFuture

        menuView.menuViewShow(nil)
    }
    
    ///核弹点击
    @objc private func unclearClick(){
        if myAirplan.unclearCount > 0{
            myAirplan.unclearCount -= 1
            unclearButton.setTitle(String(myAirplan.unclearCount), for: .normal)
            unclearClickCalculateScoreAndExplode()
        }
    }
    
    ///核弹点击处理积分和爆炸
    private func unclearClickCalculateScoreAndExplode(){
        //清除敌机
        for enemyAp in enemyAirplanes{
            if enemyAp.isMember(of: EnemyAirplanSmall.self) {
                afterHitDo(enemyAp, 100)
            }
            else if enemyAp.isMember(of: EnemyAirplanNormal.self) {
                afterHitDo(enemyAp, 200)
            }
            else if enemyAp.isMember(of: EnemyAirplanBig.self) {
                afterHitDo(enemyAp, 500)
            }
        }
        ///清除炮弹
        for shells in shellsArray{
            removeShells(shells)
        }
    }
    
    ///MARK: - 懒加载
    ///背景图片
    private lazy var backgroundScrollView = BackgroundMapScrollView(frame: UIScreen.main.bounds)
    ///暂停按钮
    private lazy var backButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"pause"), for: .normal)
        btn.setTitle("000000", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.sizeToFit()
        return btn
    }()
    
    ///核弹按钮
    private lazy var unclearButton : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"skillSmall"), for: .normal)
        btn.setTitle("0", for: .normal)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0)
        return btn
    }()
    ///存放敌机的数组 大中小
    private lazy var enemyAirplanes = [EnemyAirplan]()
    ///存放敌机发射的子弹
    private lazy var enemyShellsArray = [EnemyShell]()
    ///存放击中爆炸的数组
    private lazy var explodeAnimationViews = [ExplodeImageView]()
    ///存放炮弹的数组
    private lazy var shellsArray = [Shell]()
    ///武器包 数组
    private lazy var weaponPacksArray = [WeaponPack]()
    ///"用户飞机"
    private lazy var myAirplan = MyAirplan(frame: myAirplanFrame)
    ///菜单选项
    private lazy var menuView = MenuView(frame: CGRect.zero)
}

//MARK: - 开启定时器后续操作
extension HitAirplanViewController {
    ///开启定时器
    fileprivate func initTimer(){
        timer = Timer.init(fire: Date(), interval: 0.02, repeats: true, block: { (_) in
            self.startTimer()
        })
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
    }
    
    static var i : Double = 0
    @objc private func startTimer(){
        ///背景图片移动
        UIView.animate(withDuration: 0.25) {
            self.backgroundScrollView.contentOffset.y -= CGFloat(self.gameSpeed)
        }
        ///创建敌机
        //的值越小 敌机越多
        //小
        if HitAirplanViewController.i.truncatingRemainder(dividingBy: 100) == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth * 0.8)))))
            let enamyAirplanSmall = EnemyAirplanSmall(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth * 0.8, height: airplanHeight * 0.6))
            view.insertSubview(enamyAirplanSmall, belowSubview: backButton)
            enemyAirplanes.append(enamyAirplanSmall)
        }
        
        ///中
        if HitAirplanViewController.i.truncatingRemainder(dividingBy: 200) == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
            let enamyAirplan = EnemyAirplanNormal(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth, height: airplanHeight))
            view.insertSubview(enamyAirplan, belowSubview: backButton)
            enemyAirplanes.append(enamyAirplan)
        }
        ///大
        if HitAirplanViewController.i.truncatingRemainder(dividingBy: 300) == 0 && HitAirplanViewController.i != 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth*1.5)))))
            let enamyAirplanBig = EnemyAirplanBig(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth * 1.5, height: airplanHeight * 1.5))
//            enamyAirplanBig.sendShellsCount = 2
            view.insertSubview(enamyAirplanBig, belowSubview: backButton)
            enemyAirplanes.append(enamyAirplanBig)
            
            //敌机发射子弹
            for enemyButtle in enamyAirplanBig.createBattle(){
                view.insertSubview(enemyButtle, belowSubview: self.backButton)
                enemyShellsArray.append(enemyButtle)
            }
        }
        ///敌机子弹下落
        dropEnemyShell()
        //敌机下落
        dropEnemyAirplan()
        
        ///创建技能包
        if HitAirplanViewController.i != 0{
             //两发子弹
            if HitAirplanViewController.i.truncatingRemainder(dividingBy: 1500) == 0{
                let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - 20)))))
                let weaponPackTwo = WeaponPackAttackTwo(frame: CGRect(x: CGFloat(randowY), y: 0, width:20, height:40))
                view.insertSubview(weaponPackTwo, belowSubview: backButton)
                weaponPacksArray.append(weaponPackTwo)
            }
             //三发子弹
            if HitAirplanViewController.i.truncatingRemainder(dividingBy: 2000) == 0{
                let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
                let weaponPackThree = WeaponPackAttackThree(frame: CGRect(x: CGFloat(randowY), y: 0, width:airplanWidth * 0.4, height:airplanHeight * 0.4))
                view.insertSubview(weaponPackThree, belowSubview: backButton)
                weaponPacksArray.append(weaponPackThree)
            }
            //核弹
            if HitAirplanViewController.i.truncatingRemainder(dividingBy: 3000) == 0{
                let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - airplanWidth)))))
                let weaponPackUnclear = WeaponPackAttackUnclear(frame: CGRect(x: CGFloat(randowY), y: 0, width: airplanWidth * 0.4, height: airplanHeight * 0.4))
                view.insertSubview(weaponPackUnclear, belowSubview: backButton)
                weaponPacksArray.append(weaponPackUnclear)
            }
        }
        
        //武器装备下落
        weaponPackDropdown()
        
        ///创建炮弹
        //%的值越小 炮弹越多
        if HitAirplanViewController.i.truncatingRemainder(dividingBy: 80) == 0 {
            for shells in myAirplan.createShell(){
                view.insertSubview(shells, belowSubview: self.backButton)
                shellsArray.append(shells)
            }
        }
        ///发射炮弹
        sendShell()
        
        ///判断是否击中
        isHitEnemyAirplan()
        
        //判断是否捡到武器包
        isTakeWeaponPack()
        
        ///判断是否游戏结束
        isGameover()
        
//        print(">>>>>>>>>>>>")
//        print("敌机数量\(enemyAirplanes.count)")
//        print("---------")
//        print("子弹数量\(shellsArray.count)")
//        print("<<<<<<<<<<<<")
        
        //加得越多 走的越快
        HitAirplanViewController.i += Double(gameSpeed)
        
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
    //MARK: - 敌机子弹下落
    private func dropEnemyShell(){
        
        for enemyShells in enemyShellsArray{
            
            enemyShells.dropDown()
            ///超出屏幕删除
            let topPoint = CGPoint(x: enemyShells.frame.origin.x, y: enemyShells.frame.origin.y)
            if view.frame.contains(topPoint) == false{
                removeEnemyShell(enemyShells)
            }
        }
    }
    
    //MARK: - 武器包下落
    private func weaponPackDropdown(){
        for weapon in weaponPacksArray{
            weapon.dropDown()
            let topPoint = CGPoint(x: weapon.frame.origin.x, y: weapon.frame.origin.y)
            if view.frame.contains(topPoint) == false{
                removeWeaponPack(weapon)
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
                ///如果敌机的frame包含炮弹的顶部中心点
                if enemyAp.frame.contains(shellsOrigin){
                    //击中次数加1
                    enemyAp.hitNumber += 1
                    //删除子弹
                    removeShells(shells)
                    if enemyAp.isMember(of: EnemyAirplanSmall.self) {//小, 击中一次爆炸
                        if enemyAp.hitNumber == 1{
                            afterHitDo(enemyAp, 100)
                        }
                    }
                    else if enemyAp.isMember(of: EnemyAirplanNormal.self){//中, 击中两次爆炸
                        if enemyAp.hitNumber == 2{
                            afterHitDo(enemyAp, 200)
                        }
                    }else{//大,击中三次爆炸
                        if enemyAp.hitNumber == 3{
                            afterHitDo(enemyAp, 500)
                        }
                    }
                }
            }
        }
    }

    //MARK: - 击中后的操作
    private func afterHitDo(_ enemyAp : EnemyAirplan, _ score : Int){
        //删除敌机
        removeEnemyAirplan(enemyAp)
        //展示击中动画
        explodeAnimation(enemyAp.frame)
        ///击中后计分
        HitAirplanViewController.score += score
        backButton.setTitle(String(format:"%06d",HitAirplanViewController.score), for: .normal)
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
    
    //MARK: - 判断是否捡到技能包
    private func isTakeWeaponPack(){
        ///遍历武器包
        for weapons in weaponPacksArray{
            ///武器的中心点
            let centerPoint = weapons.center
            //武器的中心点在我机的范围 代表捡到了
            if myAirplan.frame.contains(centerPoint){
                if weapons.isMember(of: WeaponPackAttackTwo.self){//2发子弹
                    myAirplan.maxAttck = 2
                }
                else if weapons.isMember(of: WeaponPackAttackThree.self){//三发子弹
                    myAirplan.maxAttck = 3
                }
                else{//核弹
                    if myAirplan.unclearCount <= 10{
                        myAirplan.unclearCount += 1
                    }
                    ///设置核弹个数
                    unclearButton.setTitle(String(myAirplan.unclearCount), for: .normal)
                }
                //移除武器包
                removeWeaponPack(weapons)
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
                ///敌机爆炸
                removeEnemyAirplan(enemyAP)
                explodeAnimation(enemyAP.frame)
                gameOver()
            }
        }
        
        // 判断是否被敌机的子弹击中
        for enemyShells in enemyShellsArray{
            ///敌机子弹的中心点
            let centerPoint = enemyShells.center
            if myAirplan.frame.contains(centerPoint){
                ///删除子弹
                removeEnemyShell(enemyShells)
                gameOver()
            }
        }
    }
    
    private func gameOver(){
        ///我机爆炸
        explodeAnimation(myAirplan.frame)
        //我机隐藏
        myAirplan.isHidden = true
        ///1.停止定时器
        timer?.invalidate()
        timer = nil
        
        ///2.弹窗提示
        sleep(UInt32(0.5))
        menuView.menuViewShow(HitAirplanViewController.score)
        return
    }
    
    //MARK: - 重新开始 清除一些操作
    private func resetGame(){
        ///清空i
        HitAirplanViewController.i = 0
        ///清空分数
        HitAirplanViewController.score = 0
        backButton.setTitle("000000", for: .normal)
        ///清除敌机
        for enemyAP in enemyAirplanes{
            removeEnemyAirplan(enemyAP)
        }
        //清除敌机子弹
        for enemyShells in enemyShellsArray{
            removeEnemyShell(enemyShells)
        }
        ///清除炮弹
        for shells in shellsArray{
            removeShells(shells)
        }
        ///清除武器包
        for weaponPack in weaponPacksArray{
            removeWeaponPack(weaponPack)
        }
        ///初始化timer重新开始
        if timer == nil{
            initTimer()
        }
        //将我机 移到最初位置
        myAirplan.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.myAirplan.frame = self.myAirplanFrame
        }
        //攻击火力清空
        myAirplan.maxAttck = 1
        myAirplan.unclearCount = 0
        unclearButton.setTitle("0", for: .normal)
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
    
    ///移除武器包
    private func removeWeaponPack(_ weapon : WeaponPack){
        guard let index = weaponPacksArray.index(of: weapon) else {
            return
        }
        ///从武器包组中移除
        weaponPacksArray.remove(at: index)
        ///从父控件中移除
        weapon.removeFromSuperview()
    }
    
    private func removeEnemyShell(_ enemyShell : EnemyShell){
        guard let index = enemyShellsArray.index(of: enemyShell) else {
            return
        }
        ///从武器包组中移除
        enemyShellsArray.remove(at: index)
        ///从父控件中移除
        enemyShell.removeFromSuperview()
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
