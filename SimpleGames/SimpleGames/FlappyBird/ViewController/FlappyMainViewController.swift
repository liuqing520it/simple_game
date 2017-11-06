//
//  FlappyMainViewController.swift
//  SimpleGames
//
//  Created by liuqing on 2017/11/5.
//  Copyright © 2017年 liuqing. All rights reserved.
//

import UIKit

//游戏主界面
class FlappyMainViewController: UIViewController {

    var dyAnimator : UIDynamicAnimator?
    
    var redView = UIView(frame: CGRect(x: 100, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        redView.backgroundColor = UIColor.red
        redView.center = view.center
        view.addSubview(redView)
        
        dyAnimator = UIDynamicAnimator(referenceView: view);
        let gravityBehavior = UIGravityBehavior(items: [redView])
        gravityBehavior.gravityDirection = CGVector(dx: 0, dy: 1)
        gravityBehavior.magnitude = 2
        dyAnimator!.addBehavior(gravityBehavior)
        let dyBehavior = UIDynamicItemBehavior(items: [redView])
        dyBehavior.elasticity = 0.8
        dyAnimator?.addBehavior(dyBehavior)
        let collision = UICollisionBehavior(items: [redView])// [[UICollisionBehavior alloc] initWithItems:@[self.boxView]];
        // 让碰撞的行为生效
        collision.translatesReferenceBoundsIntoBoundary = true;
        
        collision.collisionDelegate = self;
        
        let bezierPath = UIBezierPath.init(rect: redView.frame)
        collision.addBoundary(withIdentifier: "bound" as NSCopying, for: bezierPath)
        dyAnimator?.addBehavior(collision)
       
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
       let pushBehavior = UIPushBehavior(items: [redView], mode: UIPushBehaviorMode.continuous)
        pushBehavior.pushDirection = CGVector(dx: 0, dy: -20)
        pushBehavior.magnitude = 2.0;
        dyAnimator?.addBehavior(pushBehavior)
        
    }
}


extension FlappyMainViewController : UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        
    }
}

















