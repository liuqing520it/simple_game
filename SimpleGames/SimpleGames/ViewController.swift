//
//  ViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/10/12.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

enum BtnTag : Int{
    case hitAirplane = 222
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
   
        addBtn()
    }
    
    private func addBtn(){
        let btnArray = ["打飞机小游戏"]
        let btnWidth = (UIScreen.main.bounds.size.width - 40)
        let btnHeight : CGFloat = 50
        for i in 0..<btnArray.count {
            let btn = UIButton(type: .custom)
            btn.backgroundColor = UIColor.orange
            btn.frame = CGRect(x: 20.0 , y: 20.0 + (btnHeight + 10) * CGFloat(i) , width: btnWidth, height: btnHeight)
            btn.setTitle(btnArray[i], for: .normal)
            btn.tag = BtnTag.hitAirplane.rawValue + i
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            view.addSubview(btn)
        }
    }
    
    @objc private func btnClick(btn : UIButton){
        if btn.tag == BtnTag.hitAirplane.rawValue {
            present(HitAirplanViewController(), animated: true, completion: nil)
        }
    }
    
}

