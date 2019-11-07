//
//  UIButtonEffect.swift
//  Lights
//
//  Created by Trent Davis on 1/11/19.
//  Copyright © 2019 Trent Davis. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func pulsate(){
    
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.5
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = false
    pulse.repeatCount = 1
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    
    layer.add(pulse, forKey: nil)
    
    
    }
}
