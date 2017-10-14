//
//  HitAirplanViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/14.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

class HitAirplanViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.orange
        
        configBackButton()
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
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.default) { (_) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        
        alertVC.addAction(beginAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    private func configBackButton(){
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("退出", for: .normal)
        backBtn.setTitleColor(UIColor.lightGray, for: .normal)
        backBtn.frame = CGRect(x: 20, y: 10, width: 0, height: 0)
        backBtn.sizeToFit()
        backBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    @objc private func btnClick(){
        dismiss(animated: true, completion: nil)
    }
    
}








