//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Sergey Petrosyan on 11/8/19.
//  Copyright © 2019 Sergey Petrosyan. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    lazy var collisionBehavior: UICollisionBehavior = {
        let collisionBehaviour = UICollisionBehavior()
        collisionBehaviour.translatesReferenceBoundsIntoBoundary = true
        return collisionBehaviour
    }()
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let dynamicItemBehavior = UIDynamicItemBehavior()
        dynamicItemBehavior.allowsRotation = false
        dynamicItemBehavior.elasticity = 1.0
        dynamicItemBehavior.resistance = 0
        return dynamicItemBehavior
    }()
    private func push(_ item: UIDynamicItem) {
        let pushBehavior = UIPushBehavior(items: [item], mode: .instantaneous)
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x, y) where x < center.x && y < center.y:
                pushBehavior.angle = (CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y < center.y:
                pushBehavior.angle = CGFloat.pi-(CGFloat.pi/2).arc4random
            case let (x, y) where x < center.x && y > center.y:
                pushBehavior.angle = (-CGFloat.pi/2).arc4random
            case let (x, y) where x > center.x && y > center.y:
                pushBehavior.angle = CGFloat.pi+(CGFloat.pi/2).arc4random
            default:
                pushBehavior.angle = (CGFloat.pi*2).arc4random
            }
        }
        pushBehavior.magnitude = CGFloat(1.0) + CGFloat(2.0).arc4random
        pushBehavior.action = { [unowned pushBehavior, weak self] in
            self?.removeChildBehavior(pushBehavior)
        }
        addChildBehavior(pushBehavior)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisionBehavior)
        addChildBehavior(itemBehavior)
    }
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}


extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(Int(arc4random_uniform(UInt32(self))))
        } else if self < 0 {
            return CGFloat(-Int(arc4random_uniform(UInt32(abs(self)))))
        } else {
            return 0
        }
    }
}
