//
//  LoginViewController.swift
//  Chatter
//
//  Created by Ashwin Gupta on 2/28/17.
//  Copyright © 2017 Ashwin Gupta. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    var signUpAlertController: UIAlertController!
    var logInAlertController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpAlertController = UIAlertController(title: "Error Signing Up", message: "Sign in failed. Please try again.", preferredStyle: .alert)
        logInAlertController = UIAlertController(title: "Error Logging In", message: "Incorrect username or password", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
            
        }
        signUpAlertController.addAction(OKAction)
        logInAlertController.addAction(OKAction)
    }
    
    @IBAction func signUp(_ sender: Any) {
        var user = PFUser()
        user.username = emailTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground(block: {
            (succeeded: Bool, error: Error?) -> Void in
            if let error = error {
                let errorString = error.localizedDescription as? String
                print(errorString)
                self.present(self.signUpAlertController, animated: true){
                    
                }
            }
            else {
                print("Sign up successful")
            }
        })
    }
    
    @IBAction func login(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                self.present(self.signUpAlertController, animated: true){
                    
                }
            }
            else {
                print("Logged in successfully")
                self.performSegue(withIdentifier: "enterChatRoom", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
