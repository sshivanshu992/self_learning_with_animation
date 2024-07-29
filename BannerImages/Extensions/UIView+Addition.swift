//
//  UIView+Addition.swift
//  BannerImages
//
//  Created by Shivanshu Verma on 15/07/24.
//

import UIKit

extension UIView {
    /// Ref-  https://www.andrewcbancroft.com/2014/09/24/slide-in-animation-in-swift/
    enum SlideDirection {
        case fromLeft
        case fromRight
        case fromTop
        case fromBottom
        
        var caTransitionSubtype: CATransitionSubtype {
            switch self {
                case .fromLeft: return .fromLeft
                case .fromRight: return .fromRight
                case .fromTop: return .fromTop
                case .fromBottom: return .fromBottom
            }
        }
    }

    func slideIn(from direction: SlideDirection = .fromLeft, duration: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        let slideTransition = CATransition()
        
        slideTransition.type = .push
        slideTransition.subtype = direction.caTransitionSubtype
        slideTransition.duration = duration
        slideTransition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        slideTransition.fillMode = .removed

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.layer.add(slideTransition, forKey: "slideTransition")
        CATransaction.commit()
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.masksToBounds = true
        self.layer.mask = mask
    }
}



extension UIView {
    func fillWithColorAnimated(fromColor startColor: UIColor, toColor endColor: UIColor, duration: TimeInterval) {
        // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, startColor.cgColor] // Start color initially
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5) // Horizontal gradient from left to right
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.mask = gradientLayer
        
        // Create color animation
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = [startColor.cgColor, startColor.cgColor]
        animation.toValue = [endColor.cgColor, endColor.cgColor]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        // Add animation to gradient layer
        gradientLayer.add(animation, forKey: "colorFillAnimation")
    }
}
