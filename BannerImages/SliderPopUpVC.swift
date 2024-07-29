//
//  SliderPopUpVC.swift
//  BannerImages
//
//  Created by Shivanshu Verma on 10/07/24.
//

import UIKit


class SliderPopUpVC: UIViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 0
        slider.maximumValue = 99
        slider.value = 0
        return slider
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    // List of 100 system image names
    let systemImages: [String] = [
        "airplane", "ant", "applelogo", "archivebox", "arrow.up", "arrow.down",
        "arrow.left", "arrow.right", "at.circle", "bag", "bandage", "barcode",
        "battery.100", "bell", "bicycle", "binoculars", "bookmark", "book",
        "brain.head.profile", "briefcase", "calendar", "camera", "capsule",
        "car", "cart", "chart.bar", "checkmark", "circle", "clock", "cloud",
        "creditcard", "cube", "doc", "dollarsign.circle", "drop", "ear",
        "envelope", "eyeglasses", "eye", "flame", "folder", "gamecontroller",
        "gift", "globe", "graduationcap", "hammer", "hand.thumbsup", "heart",
        "house", "key", "leaf", "lightbulb", "link", "location", "lock",
        "magnifyingglass", "map", "megaphone", "mic", "moon", "music.note",
        "newspaper", "paperclip", "pencil", "phone", "photo", "pin", "printer",
        "puzzlepiece", "questionmark.circle", "radio", "scissors", "shield",
        "smiley", "snowflake", "sparkles", "speedometer", "star", "stethoscope",
        "sun.max", "tortoise", "trash", "tray", "trophy", "umbrella", "video",
        "wifi", "wind", "wrench", "xmark", "zzz", "bolt", "bell", "car",
        "envelope", "camera", "gift", "key", "lock", "magnifyingglass"
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        view.addSubview(imageView)
        view.addSubview(slider)
        view.addSubview(closeButton)
        
        setupConstraints()
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        updateImage()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            slider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            slider.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            slider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 20),
            closeButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        updateImage()
    }
    
    private func updateImage() {
        let index = Int(slider.value)
        let imageName = systemImages[index]
        imageView.image = UIImage(systemName: imageName)
    }
    
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
