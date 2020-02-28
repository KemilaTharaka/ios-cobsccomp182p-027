//
//  ForgotPasswordVC.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/27/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTxt: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

     }

    @IBAction func cancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resetClicked(_ sender: Any) {
        guard let email = emailTxt.text, email.isNotEmpty else{
            simpleAlert(title: "Error", msg: "Please enter email. ")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                debugPrint(error)
                Auth.auth().handleFireAuthError(error: error, vc: self)
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
}
