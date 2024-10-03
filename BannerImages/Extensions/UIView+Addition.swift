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

/// Enabled the zooming
extension UIView {
    func enableZoomForImageView(imageView: UIImageView) {
        /// Create a UIScrollView
        let scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        /// Add UIScrollView to the UIView
        self.addSubview(scrollView)
        
        /// Add constraints to UIScrollView to fill the parent view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        /// Add UIImageView to the UIScrollView
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        /// Add constraints to UIImageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
        
        /// Set the content size of the UIScrollView based on the UIImageView's size
        scrollView.contentSize = imageView.frame.size
    }
}

/// Extend the class where you want to add zooming functionality to adopt UIScrollViewDelegate
extension UIView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        /// Return the UIImageView for zooming
        if let imageView = scrollView.subviews.first as? UIImageView {
            return imageView
        }
        return nil
    }
}
