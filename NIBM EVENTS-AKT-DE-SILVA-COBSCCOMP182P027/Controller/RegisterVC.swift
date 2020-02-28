//
//  RegisterVC.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/26/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterVC: UIViewController  {
    
    //Outlets
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPassTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet weak var passCheckImg: UIImageView!
    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    //    @IBOutlet weak var usernameTxt: UITextField!
//    @IBOutlet weak var emailTxt: UITextField!
//    @IBOutlet weak var passwordTxt: UITextField!
//    @IBOutlet weak var confirmPassTxt: UITextField!
//    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//
//    @IBOutlet weak var passCheckImg: UIImageView!
//    @IBOutlet weak var confirmPassCheckImg: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        passwordTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        confirmPassTxt.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        guard let passTxt = passwordTxt.text else { return }
        
        //If we have started typing in the confirm pass text field.
        if textField == confirmPassTxt {
            passCheckImg.isHidden = false
            confirmPassCheckImg.isHidden = false
        } else {
            if passTxt.isEmpty {
                passCheckImg.isHidden = true
                confirmPassCheckImg.isHidden = true
                confirmPassTxt.text = ""
            }
            
        }
        
        // Make it when the passwords match, the checkmarks turn green
        if passwordTxt.text == confirmPassTxt.text {
            passCheckImg.image = UIImage(named: AppImages.GreenCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.GreenCheck)
        }else {
            passCheckImg.image = UIImage(named: AppImages.RedCheck)
            confirmPassCheckImg.image = UIImage(named: AppImages.RedCheck)
            
        }
    }
    
//    @IBAction func registerClicked(_ sender: Any) {
    
    @IBAction func registerClicked(_ sender: Any) {
        
                guard let email = emailTxt.text , email.isNotEmpty ,
                    let username = usernameTxt.text , username.isNotEmpty ,
                    let password = passwordTxt.text , password.isNotEmpty else { return }
        
                activityIndicator.startAnimating()
        
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    // ...
                    if let error = error {
                        Auth.auth().handleFireAuthError(error: error, vc: self)
                        debugPrint(error)
                        self.activityIndicator.startAnimating()
                        return
                    }
        
                    self.activityIndicator.stopAnimating()
        
                    self.dismiss(animated: true, completion: nil)
                }
        
        
        }
    
}
