//
//  ViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/3/21.
//

import UIKit
import FirebaseAuth
//import AppCenter
//import AppCenterCrashes

class ViewController: UIViewController {

    // ATTRIBUTES
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        AppCenter.start(withAppSecret: "9e38018d-4dc0-480c-ac23-669f1a6eff09", services:[
//          Crashes.self
//        ])

        Utilities.styleFilledButton(loginButton)
        Utilities.styleTextField(passwordField)
        Utilities.passwordField(passwordField)
        Utilities.styleTextField(emailField)
        
        self.hideKeyboardWhenTappedAround()
    }

    // BUTTON
    @IBAction func loginPressed(_ sender: Any) {
        print("loging : tapped")
        
        // validate user / text fields
        
        // instanciate a clean version of input
        // check text field contains non-whitespace
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                // Couldn't sign in
                print("login : unsuccessful")
                
                self.errorLabel.text = "Prøv igen..."
                self.passwordField.text = ""
            }
            else {
                print("login : successfully")
                
                // redirect user to new "home"
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController
                
                // showing homeViewController instead when logged in
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
        return false
    }
    
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
