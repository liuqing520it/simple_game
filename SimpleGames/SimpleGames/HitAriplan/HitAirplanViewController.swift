//
//  HitAirplanViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class HitAirplanViewController: UIViewController {
    
    fileprivate var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        
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
    
    //MARK: - 内部控制方法
    ///弹出提示框
    private func alertTips(){
        let alertVC = UIAlertController(title: "开始游戏", message: "", preferredStyle: UIAlertControllerStyle.alert);
        let beginAction = UIAlertAction(title: "开始", style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
            
            self.initTimer()
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(beginAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    ///退出游戏按钮
    private func configUI(){
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("退出", for: .normal)
        backBtn.setTitleColor(UIColor.lightGray, for: .normal)
        backBtn.frame = CGRect(x: 20, y: 10, width: 0, height: 0)
        backBtn.sizeToFit()
        backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(backBtn)
        
        view.addSubview(backgroundImageView)
    }
    
    @objc private func btnClick(){
        dismiss(animated: true, completion: nil)
    }

    
    ///MARK: - 懒加载
    ///背景图片
    fileprivate lazy var backgroundImageView : UIImageView = {
        let imageV = UIImageView(image: UIImage(named:"map"))
        imageV.frame = UIScreen.main.bounds
        return imageV
    }()
    ///积分label
    fileprivate lazy var scoreLabel : UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.red
        return label
    }()
    
    ///存放敌机数组
    private lazy var enemyPlanes = [EnemyAirplan]()
    
    private lazy var myAirplan : UIButton = {
       let btn = UIButton(type: .custom)
        return btn
    }()
    
    
}


//MARK: - 开启定时器后续操作
extension HitAirplanViewController {
    
    ///开启定时器
    fileprivate func initTimer(){
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
    }
    
    
    static var i : Int = 0
    @objc private func startTimer(){
        
        if HitAirplanViewController.i%80 == 0{
            let randowY = Int(arc4random_uniform(UInt32(Int((SCREEN_WIDTH - 40)))))
            let enamyAirplan = EnemyAirplan(frame: CGRect(x: CGFloat(randowY), y: 0, width: 40, height: 40))
            view.addSubview(enamyAirplan)
            enemyPlanes.append(enamyAirplan)
        }
        //敌机下落
        dropEnemyAirplan()
        
        
        
        HitAirplanViewController.i += 1
    }
    
    ///下落敌机
    private func dropEnemyAirplan(){
        for enemy in enemyPlanes{
            enemy.dropDown()
        }
    }
    
}







