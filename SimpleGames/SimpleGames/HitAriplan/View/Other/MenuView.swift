//
//  MenuView.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/23.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit
enum ClickIndex:Int {
    //继续
    case ClickContinue = 0
    //重新开始
    case ClickRestart = 1
    //退出
    case ClickExit = 2
}
///菜单选择
class MenuView: UIView {

    var dismissCallBack : ((_ clickIndex : ClickIndex)->())?
    //底层覆盖的view
    private lazy var maskBackView = UIView(frame: UIScreen.main.bounds)
    //记录分数
    private var resultScores : Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.lightGray
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    ///菜单展示
    func menuViewShow(_ gameScore : Int?){
        resultScores = gameScore
        
        let window = UIApplication.shared.keyWindow!
        maskBackView.backgroundColor = UIColor.init(white: 1.0, alpha: 0.5)
        window.addSubview(maskBackView)
        //如果分数为空则展示暂停画面
        if let score = gameScore {
            configUIOver(score)
        }
        else {
            configUIPause()
        }
        
        self.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: -SCREEN_HEIGHT*0.5)
        window.addSubview(self)
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_HEIGHT*0.5)
        }) { (_) in
            
        }
    }
    
    ///菜单消失
    func menuViewDissmiss(){
        maskBackView.removeFromSuperview()
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 10, options: UIViewAnimationOptions.allowAnimatedContent, animations: {
            self.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_WIDTH + SCREEN_HEIGHT * 0.5)
        }) { (_) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - 内部控制方法
    private func configUIPause(){
        configButton(["继续","重新开始","回到主页"])
    }
    
    private func configUIOver(_ score : Int){
        let scoreLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 200, height: 50))
        scoreLabel.textColor = UIColor.white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 25)
        scoreLabel.text = String(score)
        scoreLabel.textAlignment = .center
        addSubview(scoreLabel)
        configButton(["重新开始","回到主页"])
    }
    
    func configButton(_ btnTitle : [String]){
        //按钮宽
        let btnWidth : CGFloat = 150
        //按钮高
        let btnHeight : CGFloat = 30
        
        let topMargin :CGFloat = btnTitle.count == 3 ? 30 : 100
        
        for i in 0..<btnTitle.count{
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: 25, y: topMargin + (btnHeight + 20) * CGFloat(i), width: btnWidth, height: btnHeight)
            btn.setTitle(btnTitle[i], for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 15
            btn.layer.masksToBounds = true
            btn.tag = i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            addSubview(btn)
        }
    }
    
    @objc private func btnClick(btn:UIButton){
        if resultScores != nil{//暂停
            if (dismissCallBack != nil){
                dismissCallBack!(ClickIndex.init(rawValue:btn.tag + 1)!)
            }
            
        }else{//结束
            if (dismissCallBack != nil){
                dismissCallBack!(ClickIndex.init(rawValue:btn.tag)!)
            }
        }
        menuViewDissmiss()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
