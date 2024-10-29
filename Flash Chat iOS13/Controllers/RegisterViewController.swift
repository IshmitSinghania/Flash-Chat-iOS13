//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var usernamField: UITextField!
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text ,let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let e = error{
                    print(e)
                    self.emailTextfield.text = ""
                    self.passwordTextfield.text = ""
                    self.emailTextfield.placeholder = "Account Already Exists"
                }else{
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
//        let user = Auth.auth().currentUser
//           if let user = user {
//               let changeRequest = user.createProfileChangeRequest()
//
//               changeRequest.displayName = usernamField.text
//               changeRequest.commitChanges { error in
//                if let error = error {
//                  print("Error")
//                } else {
//
//                }
//              }
//            }
    }
    
   
}
