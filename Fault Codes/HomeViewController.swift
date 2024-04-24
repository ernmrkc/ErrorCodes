//  HomeViewController.swift
//  Fault Codes
//
//  Created by Muhammed Eren Morkoç on 23.08.2022.
//

import UIKit
import LocalAuthentication                      // This has been added to use face id and other authentication

/**
        This class was created for authentication.
        It has segue to go to application screen when it performs successful authorization.
 */
class HomeViewController: UIViewController, UIPageViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = LAContext()
        var error: NSError? = nil
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Please authorize with touch id!"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) {
                [weak self] success, error in DispatchQueue.main.async {
                    guard success, error == nil else {
                        // Authorization failed
                        let alert = UIAlertController(title: "Failed to Authenticate", message: "Please try again.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    // Authorization successful - Show other screen with segue
                    self!.performSegue(withIdentifier: "toMainVC", sender: self)
                }
            }
        }
        else{
            // Unavailable this feature
            let alert = UIAlertController(title: "Unavailable", message: "You can't use this feature", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
    }

}
