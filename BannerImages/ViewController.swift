//
//  ViewController.swift
//  BannerImages
//
//  Created by Manisha Kumari on 02/07/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var slidView: UIView!
    @IBOutlet weak var slideLabelView: UILabel!
    ///Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    /// -- - -  ---
    @IBOutlet weak var swipeContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var imageContainerWidthConstraint: NSLayoutConstraint!
    
    /// --- --- ---
    @IBOutlet weak var secondContainerView: UIView!
    @IBOutlet weak var secondimageContainerView: UIView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondImageContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondimageContainerLeadingConstraint: NSLayoutConstraint!
    
    let showPopUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Slider Pop-Up", for: .normal)
        return button
    }()

    /// Variables
    let imageArr = ["image1", "image2","image1", "image2"]
    let priceArr = ["34", "67", "99", "65"]
    var timer: Timer?
    var currentCellIndex = 0
    var labelTextSliderTimer: Timer?

    /// ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.openWebPage(webUrl: "https://example.com/")
        
        sliderButton()
        addSwipeGesture()
        secondAddSwipeGesture()
        startAutoSlideAnimation()
        //animateViewChange()
        /// Delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = imageArr.count
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(slideToNext), userInfo: nil, repeats: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.round()
            self.swipeContainerView.roundCorners(corners: .allCorners, radius: 12.0)
//            self.leftView.roundCorners(corners: .allCorners, radius: 12.0)
//            self.rightView.roundCorners(corners: .allCorners, radius: 12.0)
//            self.leftView.isHidden = true
//            self.rightView.isHidden = true
            self.imageContainerView.roundCorners(corners: .allCorners, radius: self.imageContainerView.bounds.width / 2)
            //self.secondimageContainerView.roundCorners(corners: .allCorners, radius: self.secondimageContainerView.bounds.width / 2)
        }
    }

    func startAutoSlideAnimation() {
        labelTextSliderTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(performSlideAnimation), userInfo: nil, repeats: true)
    }

    @objc func performSlideAnimation() {
        slideLabelView.slideIn(from: .fromLeft, duration: 1.0) {
            // print("Animation completed")
        }
    }

    deinit {
        labelTextSliderTimer?.invalidate()
    }

    @objc func slideToNext() {
        if currentCellIndex < imageArr.count - 1 {
            currentCellIndex += 1
        } else {
            currentCellIndex = 0
        }
        
        pageControl.currentPage = currentCellIndex
        
        let indexPath = IndexPath(item: currentCellIndex, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

///Delegate and data source methods of UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = UIImage(named: imageArr[indexPath.row])
        cell.priceLabel.text = priceArr[indexPath.row]
        cell.imageView.layer.cornerRadius = 10
        cell.imageView.layer.masksToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

extension ViewController {
    func sliderButton() {
        view.backgroundColor = .white
        view.addSubview(showPopUpButton)
        
        showPopUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        showPopUpButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        showPopUpButton.addTarget(self, action: #selector(showSliderPopUp), for: .touchUpInside)
    }
    
    @objc func showSliderPopUp() {
        let sliderPopUpVC = SliderPopUpViewController() //SliderPopUpVC()
        sliderPopUpVC.modalPresentationStyle = .popover
        sliderPopUpVC.modalTransitionStyle = .crossDissolve
        present(sliderPopUpVC, animated: true, completion: nil)
    }
}

extension ViewController {
    private func round() {
        firstView.roundCorners(corners: [.bottomRight, .topRight], radius: firstView.bounds.width / 2)
        //        firstView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 12.0)
        secondView.roundCorners(corners: [.bottomLeft, .topLeft], radius: secondView.bounds.width / 2)
        //secondView.roundCorners(corners: [.bottomRight, .topRight], radius: 12.0)
    }
}

// MARK: - Second Animaton wala code h be
extension ViewController {
    private func secondAddSwipeGesture() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        let views: [UIView] = [secondImageView, secondimageContainerView]
        
        views.forEach { view in
            view.isUserInteractionEnabled = true
            directions.forEach { direction in
                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(secondHandleSwipe(_:)))
                swipeGesture.direction = direction
                view.addGestureRecognizer(swipeGesture)
            }
        }
    }
    @objc func secondHandleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var newWidth: CGFloat
        var newLeading: CGFloat
        var leftViewColor: UIColor = .clear
        var rightViewColor: UIColor = .clear
        var swipeDirection: UISwipeGestureRecognizer.Direction
        
        switch gesture.direction {
            case .left:
                newWidth = secondContainerView.bounds.width / 2
                newLeading = secondContainerView.bounds.width / 2 - newWidth
                leftViewColor = .systemBlue
                swipeDirection = .left
            case .right:
                newWidth = secondContainerView.bounds.width / 2
                newLeading = secondContainerView.bounds.width / 2
                rightViewColor = .systemBlue
                swipeDirection = .right
            default:
                return
        }
        
        // Define the animation duration and spring parameters
        let duration: TimeInterval = 1.0
        let dampingRatio: CGFloat = 0.5
        let initialVelocity: CGFloat = 0.2
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
            self.secondImageView.alpha = 0
            self.secondImageContainerWidthConstraint.constant = newWidth
            self.secondimageContainerLeadingConstraint.constant = newLeading
            self.secondContainerView.layoutIfNeeded()
//            self.leftView.backgroundColor = leftViewColor
//            self.rightView.backgroundColor = rightViewColor
        }) { _ in
            // Action to be performed immediately after reaching the target position
            self.performPostSwipeAction(direction: swipeDirection)
            
            // Animate back to the original size and position
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
                self.secondImageView.alpha = 1
                self.secondImageContainerWidthConstraint.constant = 60 // or the original width
                self.secondimageContainerLeadingConstraint.constant = (self.secondContainerView.bounds.width - 60) / 2
                self.secondContainerView.layoutIfNeeded()
//                self.leftView.backgroundColor = .clear
//                self.rightView.backgroundColor = .clear
            }, completion: nil)
        }
    }
}

extension ViewController {
    private func addSwipeGesture() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        let views: [UIView] = [imageView, imageContainerView]
        
        views.forEach { view in
            view.isUserInteractionEnabled = true
            directions.forEach { direction in
                let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
                swipeGesture.direction = direction
                view.addGestureRecognizer(swipeGesture)
            }
        }
    }
    
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        var leftViewColor: UIColor = .clear
        var rightViewColor: UIColor = .clear
        var swipeDirection: UISwipeGestureRecognizer.Direction
        
        switch gesture.direction {
            case .left:
                leftViewColor = .systemBlue
                swipeDirection = .left
                self.leftView.roundCorners(corners: .allCorners, radius: leftView.bounds.width / 2)
                
            case .right:
                rightViewColor = .systemBlue
                swipeDirection = .right
                self.rightView.roundCorners(corners: .allCorners, radius: rightView.bounds.width / 2)
            default:
                return
        }
        
        // Define the animation duration
        let duration: TimeInterval = 0.5
        
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseInOut], animations: {
            self.imageView.alpha = 0
            self.imageContainerView.alpha = 0
            print(self.imageContainerView.frame)
            self.leftView.backgroundColor = leftViewColor
            self.rightView.backgroundColor = rightViewColor
        }) { _ in
            // Action to be performed immediately after reaching the target position
            self.performPostSwipeAction(direction: swipeDirection)
            
            // Animate back to the original size and position
            UIView.animate(withDuration: duration, delay: 1.0, options: [.curveEaseInOut], animations: {
                self.imageView.alpha = 1
                self.imageContainerView.alpha = 1
                self.leftView.backgroundColor = .clear
                self.rightView.backgroundColor = .clear
            }, completion: nil)
        }
    }
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        var newCenter: CGPoint
//        var leftViewColor: UIColor = .clear
//        var rightViewColor: UIColor = .clear
//        var swipeDirection: UISwipeGestureRecognizer.Direction
//        
//        switch gesture.direction {
//            case .left:
//                newCenter = CGPoint(x: imageContainerView.frame.width / 2, y: imageContainerView.center.y)
//                leftViewColor = .systemBlue
//                swipeDirection = .left
//            case .right:
//                newCenter = CGPoint(x: containerView.bounds.width - imageContainerView.frame.width / 2, y: imageContainerView.center.y)
//                rightViewColor = .systemBlue
//                swipeDirection = .right
//            default:
//                return
//        }
//        
//        // Define the animation duration and spring parameters
//        let duration: TimeInterval = 1.0
//        let dampingRatio: CGFloat = 0.5
//        let initialVelocity: CGFloat = 0.2
//        
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
//            self.imageContainerView.alpha = 0
//            self.imageContainerView.center = newCenter
//            self.leftView.backgroundColor = leftViewColor
//            self.rightView.backgroundColor = rightViewColor
//        }) { _ in
//            /// Action to be performed immediately after reaching the target position
//            self.performPostSwipeAction(direction: swipeDirection)
//
//            /// Animate back to the center
//            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
//                self.imageContainerView.alpha = 1
//                self.imageContainerView.center = self.containerView.center
//                self.leftView.backgroundColor = .clear
//                self.rightView.backgroundColor = .clear
//            }, completion: { _ in
//               // self.performPostSwipeAction(direction: swipeDirection)
//            })
//        }
//    }
    
    private func performPostSwipeAction(direction: UISwipeGestureRecognizer.Direction) {
        if direction == .left {
            print("Left swipe action completed")
        } else if direction == .right {
            print("Right swipe action completed")
        }
    }
}
//extension ViewController {
//    private func addSwipeGesture() {
//        //        // Add pan gesture recognizer
//        //        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        //        imageView.isUserInteractionEnabled = true
//        //        imageView.addGestureRecognizer(panGesture)
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeLeft.direction = .left
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeRight.direction = .right
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(swipeLeft)
//        imageView.addGestureRecognizer(swipeRight)
//    }
//    
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        var newCenter: CGPoint
//        
//        switch gesture.direction {
//            case .left:
//                newCenter = CGPoint(x: imageView.frame.width / 2, y: imageView.center.y)
//            case .right:
//                newCenter = CGPoint(x: containerView.bounds.width - imageView.frame.width / 2, y: imageView.center.y)
//            default:
//                return
//        }
//        
//        //        // Define the animation duration and spring parameters
//        //        let duration: TimeInterval = 1.0 // Longer duration for smoother animation
//        //        let dampingRatio: CGFloat = 0.5 // Lower damping ratio for more spring effect
//        //        let initialVelocity: CGFloat = 0.2 // Lower initial velocity for slower start
//        //
//        //        let moveAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) {
//        //            self.imageView.center = newCenter
//        //        }
//        //
//        //        moveAnimator.addCompletion { _ in
//        //            let returnAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: dampingRatio) {
//        //                self.imageView.center = self.containerView.center
//        //            }
//        //            returnAnimator.startAnimation()
//        //        }
//        //
//        //        moveAnimator.startAnimation()
//        
//        // MARK: - Second way -
//        /// Define the animation duration and spring parameters
//        let duration: TimeInterval = 1.0
//        let dampingRatio: CGFloat = 0.5
//        let initialVelocity: CGFloat = 0.2
//        
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: .curveEaseInOut, animations: {
//            self.imageView.center = newCenter
//            self.imageView.alpha = 0
//        }) { _ in
//            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: .curveEaseInOut, animations: {
//                self.imageView.center = self.containerView.center
//                self.imageView.alpha = 1.0
//            }, completion: nil)
//        }
//    }
//    
//    
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: containerView)
//        
//        switch gesture.state {
//            case .began, .changed:
//                // Move the image view with the pan gesture
//                let newX = imageView.center.x + translation.x
//                imageView.center = CGPoint(x: newX, y: imageView.center.y)
//                gesture.setTranslation(.zero, in: containerView)
//            case .ended:
//                // Animate back to the center
//                UIView.animate(withDuration: 0.3) {
//                    self.imageView.center = self.containerView.center
//                }
//            default:
//                break
//        }
//    }
//    
//    //    @objc private func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
//    //        switch gesture.direction {
//    //            case .left:
//    //                print("Left Side Swipe Gesture")
//    //                UIView.animate(withDuration: 0.3) {
//    //                    self.containerView.backgroundColor = .green
//    //                    self.imageView.transform = CGAffineTransform(translationX: -100, y: 0)
//    //                }
//    //            case .right:
//    //                print("Right Side Swipe Gesture")
//    //                UIView.animate(withDuration: 0.3) {
//    //                    self.containerView.backgroundColor = .blue
//    //                    self.imageView.transform = CGAffineTransform(translationX: 100, y: 0)
//    //                }
//    //            default:
//    //                break
//    //        }
//    
//    //        switch gesture.state {
//    //            case .began:
//    //                // You can add any logic needed when the gesture begins, if necessary.
//    //                break
//    //            case .changed:
//    //                UIView.animate(withDuration: 0.3) {
//    //                    self.viewToColor.backgroundColor = .green
//    //                    self.imageView.transform = CGAffineTransform(translationX: 0, y: 100)
//    //                }
//    //            case .ended:
//    //                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut], animations: {
//    //                    self.imageView.transform = CGAffineTransform(translationX: -100, y: 0)
//    //                }) { _ in
//    //                    // Reset the color and transformation after animation completes
//    //                    UIView.animate(withDuration: 0.3) {
//    //                        self.viewToColor.backgroundColor = .white
//    //                        self.imageView.transform = .identity
//    //                    }
//    //                }
//    //            default:
//    //                break
//    //        }
//    //    }
//    
//}



//@objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//    var newFrame: CGRect
//    var leftViewColor: UIColor = .clear
//    var rightViewColor: UIColor = .clear
//    var swipeDirection: UISwipeGestureRecognizer.Direction
//    
//    switch gesture.direction {
//        case .left:
//            newFrame = CGRect(x: imageContainerView.center.x - containerView.bounds.width / 2,
//                              y: imageContainerView.frame.origin.y,
//                              width: containerView.bounds.width / 2,
//                              height: imageContainerView.frame.height)
//            leftViewColor = .systemBlue
//            swipeDirection = .left
//            self.leftView.roundCorners(corners: .allCorners, radius: leftView.bounds.width / 2)
//            
//        case .right:
//            newFrame = CGRect(x: imageContainerView.center.x,
//                              y: imageContainerView.frame.origin.y,
//                              width: containerView.bounds.width / 2,
//                              height: imageContainerView.frame.height)
//            rightViewColor = .systemBlue
//            swipeDirection = .right
//            self.rightView.roundCorners(corners: .allCorners, radius: rightView.bounds.width / 2)
//        default:
//            return
//    }
//    
//    // Define the animation duration and spring parameters
//    let duration: TimeInterval = 1.0
//    let dampingRatio: CGFloat = 0.5
//    let initialVelocity: CGFloat = 0.2
//    
//    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
//        self.imageView.alpha = 0
//        self.imageContainerView.frame = newFrame
//        self.imageContainerView.alpha = 0
//        print(newFrame)
//        print(self.imageContainerView.frame)
//        self.leftView.backgroundColor = leftViewColor
//        self.rightView.backgroundColor = rightViewColor
//    }) { _ in
//        // Action to be performed immediately after reaching the target position
//        self.performPostSwipeAction(direction: swipeDirection)
//        
//        // Animate back to the original size and position
//        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: dampingRatio, initialSpringVelocity: initialVelocity, options: [.curveEaseInOut], animations: {
//            self.imageView.alpha = 1
//            self.imageContainerView.frame = CGRect(x: (self.containerView.bounds.width - self.imageContainerView.frame.width) / 2,
//                                                   y: self.imageContainerView.frame.origin.y,
//                                                   width: self.imageContainerView.frame.width,
//                                                   height: self.imageContainerView.frame.height)
//            self.imageContainerView.alpha = 1
//            print("Back place - ", self.imageContainerView.frame)
//            self.leftView.backgroundColor = .clear
//            self.rightView.backgroundColor = .clear
//        }, completion: nil)
//    }
//    }
