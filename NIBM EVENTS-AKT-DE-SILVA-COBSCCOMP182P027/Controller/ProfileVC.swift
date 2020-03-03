//
//  ProfileVC.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 3/3/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import LocalAuthentication
import BiometricAuthentication

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        accessTouchIDOrFaceId()
        // Do any additional setup after loading the view.
    }
    
    
    func handleError(error: Error, msg: String) {
        debugPrint(error.localizedDescription)
        self.simpleAlert(title: "Error", msg: msg)
    }
    
    
    func accessTouchIDOrFaceId(){
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "

        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in

                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            return
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            self.simpleAlert(title: "Error", msg: "User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                simpleAlert(title: "Error", msg:  "Sorry!!.. Could not evaluate policy.")
            }
        } else {
            // Fallback on earlier versions

            simpleAlert(title: "Error", msg:  "Ooops!!.. This feature is not supported.")
        }
    }

 

}
