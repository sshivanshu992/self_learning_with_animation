//
//  SwipeButtonView.swift
//  BannerImages
//
//  Created by Shivanshu Verma on 27/07/24.
//

import UIKit

class SwipeButtonView: UIView {
    
    @IBOutlet private weak var swipView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    /// Define a callback closure type with an additional completion block
    typealias SwipeCompletion = ((@escaping () -> Void) -> Void)
    
    /// Store the completion callback
    public var swipeCompletion: SwipeCompletion?

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeCircular(view: swipView)
        makeCircular(view: shadowView)
        makeCircular(view: imageView)
        
    }

    private func loadNib() {
        if let view = Bundle.main.loadNibNamed("SwipeButtonView", owner: self, options: nil)?.first as? UIView {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                view.topAnchor.constraint(equalTo: self.topAnchor),
                view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
            self.setupGestureRecognizers()
        }
    }

    private func makeCircular(view: UIView) {
        let minDimension = min(view.frame.size.width, view.frame.size.height)
        view.layer.cornerRadius = minDimension / 2
        view.clipsToBounds = true
    }
    
    /// Public method to update UI elements
    public func configureView(
        swipView swipColor: UIColor,
        shadowView shadowColor: UIColor,
        image: UIImage?,
        tintColor: UIColor? = nil,
        title: String? = nil,
        textColor: UIColor? = nil,
        font: UIFont? = nil
    ) {
        swipView.backgroundColor = swipColor
        shadowView.backgroundColor = shadowColor
        
        if let image = image {
            imageView.image = image
        }
        
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        
        if let title =  title {
            titleLabel.text = title
        }

        if let textColor = textColor {
            titleLabel.textColor = textColor
        }
        if let font = font {
            titleLabel.font = font
        }
    }
}

// MARK: - Animation
extension SwipeButtonView {
    private func setupGestureRecognizers() {
        addSwipeGesture(to: shadowView, direction: .right)
        addSwipeGesture(to: imageView, direction: .right)
    }
    
    private func addSwipeGesture(to view: UIView, direction: UISwipeGestureRecognizer.Direction) {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = direction
        view.addGestureRecognizer(swipeGesture)
        view.isUserInteractionEnabled = true
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        /// Trigger animation when swipe is detected
        self.animateSwipeWithCompletion { [weak self] completion in
            /// Call the completion callback if it is set
            self?.swipeCompletion?(completion)
        }
    }

    /// Animates a swipe action with a completion handler to execute custom actions before resetting the view to its original state.
    /// - Parameter beforeResetAction: A closure to be executed before the reset animation starts. This closure receives another closure as its parameter, which should be called once the custom actions are complete.
    private func animateSwipeWithCompletion(beforeResetAction: @escaping (_ completion: @escaping () -> Void) -> Void) {
        /// Define the frame for the shadow view at the end of the swipe animation
        let shadowViewEndFrame: CGRect
        
        /// Padding between elements during animation
        let padding: CGFloat = 18
        
        /// Store the original frames and centers to reset them later
        let originalShadowViewFrame = shadowView.frame
        let originalTitleLabelCenter = titleLabel.center
        
        /// Calculate the end frame for the shadow view based on the background view's width and shadow view's width, including padding
        shadowViewEndFrame = CGRect(
            x: swipView.bounds.width - shadowView.bounds.width + padding,
            y: shadowView.frame.origin.y,
            width: shadowView.bounds.width,
            height: shadowView.bounds.height
        )
        
        /// Animate the swipe action
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: {
            /// Move the shadow view to the calculated end frame
            self.shadowView.frame = shadowViewEndFrame
            
            /// Move the unit label to be just left of the shadow view, including padding
            self.titleLabel.frame.origin.x = self.shadowView.frame.origin.x - self.titleLabel.frame.width - (padding - 5)
        }) { _ in
            /// Execute the custom actions before resetting the views
            beforeResetAction { [weak self] in
                guard let self = self else { return }
                
                /// Animate the reset action
                UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
                    /// Reset the shadow view to its original frame
                    self.shadowView.frame = originalShadowViewFrame
                    
                    /// Reset the unit label to its original center
                    self.titleLabel.center = originalTitleLabelCenter
                })
            }
        }
    }
}
