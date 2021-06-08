//
//  HomeViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/4/21.
//

import UIKit
import Firebase

let fS = FirebaseService()
class HomeViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fS.storageRef = fS.storage.reference() // Firebase initializing
        fS.startListener()
    }
}
