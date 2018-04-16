//
//  HelperClass.swift
//  myNotePad
//
//  Created by Mithun R on 16/04/18.
//  Copyright © 2018 Mithun R. All rights reserved.
//

import Foundation
import UIKit


class HelperClass {

}

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
