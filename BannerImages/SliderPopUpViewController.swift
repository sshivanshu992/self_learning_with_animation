//
//  SliderPopUpViewController.swift
//  BannerImages
//
//  Created by Shivanshu Verma on 10/07/24.
//

import UIKit
import AVFoundation

class SliderPopUpViewController: UIViewController {
 
    @IBOutlet weak var firstSwipeButtonView: SwipeButtonView!
    @IBOutlet weak var secondSwipeButtonView: SwipeButtonView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.swipeViewConfiguration()
    }
    
    @IBAction func didTapFlashlightButton(_ sender: UIButton) {
        print(TorchController.shared.isTorchActive)
        TorchController.shared.toggleTorch { result in
            switch result {
                case .success():
                    print("Torch toggled successfully.")
                case .failure(let error):
                    print("Failed to toggle torch: \(error.localizedDescription)")
            }
        }
    }
    
    private func swipeViewConfiguration() {
        firstSwipeButtonView.swipeCompletion = { resetAnimationComplation in
            
            resetAnimationComplation()
        }
        
        secondSwipeButtonView.swipeCompletion = { resetAnimationComplation in
            
            resetAnimationComplation()
        }
        
        // Update SwipeButtonView with new properties
        firstSwipeButtonView.configureView(
            swipView: .systemIndigo.withAlphaComponent(0.4),
            shadowView: .systemGray.withAlphaComponent(0.2),
            image: UIImage(systemName: "heart"),
            title:  "Example Title"
        )

        // Update SwipeButtonView with new properties
        secondSwipeButtonView.configureView(
            swipView: .systemPurple.withAlphaComponent(0.4),
            shadowView: .systemMint.withAlphaComponent(0.2),
            image: UIImage(systemName: "paperplane")
        )
    }
}


/// Ref - https://www.hackingwithswift.com/example-code/media/how-to-turn-on-the-camera-flashlight-to-make-a-torch
import AVFoundation

enum TorchError: Error {
    case deviceUnavailable
    case torchUnavailable
    case configurationFailed
    var localizedDescription: String {
        switch self {
            case .deviceUnavailable:
                return NSLocalizedString("Torch device is not available on this device.", comment: "Device Unavailable Error")
            case .torchUnavailable:
                return NSLocalizedString("This device does not have a torch.", comment: "Torch Unavailable Error")
            case .configurationFailed:
                return NSLocalizedString("Failed to configure the torch. Please try again.", comment: "Configuration Failed Error")
        }
    }
}

import AVFoundation

class TorchController {
    static let shared = TorchController()
    
    private var device: AVCaptureDevice?
    private var isTorchOn = false
    
    private init() {
        /// Initialize the AVCaptureDevice
        device = AVCaptureDevice.default(for: .video)
    }

    /// Returns whether the torch is currently on.
    /// - Returns: `true` if the torch is on, `false` otherwise.
    public var isTorchActive: Bool {
        return isTorchOn
    }
    
    private func configureTorch(on: Bool, completion: @escaping (Result<Void, TorchError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let device = self.device else {
                DispatchQueue.main.async {
                    completion(.failure(.deviceUnavailable))
                }
                return
            }
            
            guard device.hasTorch else {
                DispatchQueue.main.async {
                    completion(.failure(.torchUnavailable))
                }
                return
            }
            
            do {
                try device.lockForConfiguration()
                
                if device.isTorchActive != on {
                    device.torchMode = on ? .on : .off
                    self.isTorchOn = on
                }
                
                device.unlockForConfiguration()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.configurationFailed))
                }
            }
        }
    }
    
    /// Toggles the torch state. If the torch is off, it will be turned on, and vice versa.
    /// - Parameter completion: A closure to handle the result of the operation.
    func toggleTorch(completion: @escaping (Result<Void, TorchError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let device = self.device, device.hasTorch else {
                DispatchQueue.main.async {
                    completion(.failure(.torchUnavailable))
                }
                return
            }
            
            // Toggle the torch based on its current state
            let newTorchState = !device.isTorchActive
            self.configureTorch(on: newTorchState, completion: completion)
        }
    }
    
    /// Turns the torch off if it's currently on.
    /// - Parameter completion: A closure to handle the result of the operation.
    func turnTorchOff(completion: @escaping (Result<Void, TorchError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if self.isTorchOn {
                self.configureTorch(on: false, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            }
        }
    }
}
