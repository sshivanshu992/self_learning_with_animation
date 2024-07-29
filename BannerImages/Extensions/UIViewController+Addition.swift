//
//  UIViewController+Addition.swift
//  BannerImages
//
//  Created by Shivanshu Verma on 24/07/24.
//


import SafariServices
import UIKit


extension UIViewController: SFSafariViewControllerDelegate {
    
    /// Opens a web page for the given URL with enhanced customizations for iOS 15 and above.
    ///
    /// - Parameter url: The URL of the web page to open.
    public func openWebPage(url: URL) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = true
            configuration.barCollapsingEnabled = false
            
            let controller = SFSafariViewController(url: url, configuration: configuration)
            controller.preferredBarTintColor = .systemBackground
            controller.preferredControlTintColor = .systemBlue
            controller.dismissButtonStyle = .close
            
            controller.delegate = self
            controller.modalPresentationStyle = .overCurrentContext
            controller.modalTransitionStyle = .crossDissolve
            
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    /// Handle the Safari view controller dismissal.
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    /// Handle opening URLs with error handling and logging.
    ///
    /// - Parameter webUrl: The URL string to open.
    public func openWebPage(webUrl: String) {
        guard let url = URL(string: webUrl) else {
            print("Invalid URL: \(webUrl)")
            return
        }
        openWebPage(url: url)
    }
}
extension UIViewController {
    
    /// Presents an alert with a given title and message on the view controller.
    /// - Parameters:
    ///   - title: The title of the alert.
    ///   - message: The message of the alert.
    ///   - buttonTitle: The title of the button (default is "OK").
    func showAlert(title: String, message: String, buttonTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
