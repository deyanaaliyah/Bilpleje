//
//  SettingsViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/17/21.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    // ATTRIBUTES
    @IBOutlet weak var logoutButton: UIButton!
    var leonard = "27848171"
    var nikolas = "12345678"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Utilities.styleFilledButton(logoutButton)
    }
    
    // BUTTON()
    @IBAction func logoutPressed(_ sender: UIButton) {
        signOut()
    }
    @IBAction func leoPressed(_ sender: Any) {
        callNumber(phoneNumber: leonard)
    }
    @IBAction func nikolasPressed(_ sender: Any) {
        callNumber(phoneNumber: nikolas)
    }
    
    // CALL()
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    // SIGN OUT()
    private func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
//            let viewCtrl = ViewController()
//            self.present(viewCtrl, animated: true, completion: nil)
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "myVCID") as! ViewController
            self.present(vc, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            let unsuccessful = UIAlertController(title: "Fejl", message: "Prøv igen", preferredStyle: .alert)
            // OKBtn
            let okAction = UIAlertAction(title: "Ok :/", style: .default) { (action) in
                print(action)
            }
            unsuccessful.addAction(okAction)
        }
    }
}
