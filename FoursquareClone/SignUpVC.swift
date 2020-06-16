//
//  ViewController.swift
//  FoursquareClone
//
//  Created by Sefa Çelik on 14.05.2020.
//  Copyright © 2020 Sefa Celik. All rights reserved.
//

import UIKit
import Parse

class SignUpVC: UIViewController {
    
    // UI
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { (user, error) in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Bilinmeyen hata")
                } else {
                    // Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
        } else {
            makeAlert(messageInput: "Missing Username or Password")
        }
        
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if usernameText.text != "" && passwordText.text != ""{
            
            let user = PFUser()
            user.username = usernameText.text!
            user.password = passwordText.text!
            
            user.signUpInBackground { (success, error) in
                if error != nil {
                    self.makeAlert(messageInput: error?.localizedDescription ?? "Bilinmeyen Hata")
                } else {
                    //Segue
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)
                }
            }
            
            
        } else {
            makeAlert(messageInput: "Missing Username or Password")
        }
    }
    
    func makeAlert(messageInput: String){
        let alert = UIAlertController(title: "Error", message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert,animated: true,completion: nil)
    }
}

















