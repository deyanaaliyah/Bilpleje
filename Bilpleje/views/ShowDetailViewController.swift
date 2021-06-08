//
//  ShowDetailViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/16/21.
//

import UIKit

class ShowDetailViewController: UIViewController {
    // ATTRIBUTES
    var rowSelectedFromSegue:Int?
    var text:String?
    @IBOutlet weak var idLabel: UILabel!
    var customerName:String?
    @IBOutlet weak var nameField: UITextField!
    var plate:String?
    @IBOutlet weak var plateField: UITextField!
    var size:String?
    @IBOutlet weak var sizeField: UITextField!
    var dateAdded:String?
    @IBOutlet weak var dateAddedField: UITextField!
    var dateFinished:String?
    @IBOutlet weak var dateFinishedField: UITextField!
    var phone:String?
    @IBOutlet weak var phoneField: UITextField!
    var isClean:String?
    @IBOutlet weak var isCleanField: UITextField!
    var price:String?
    @IBOutlet weak var priceField: UITextField!
    var note:String?
    @IBOutlet weak var noteField: UITextField!
    @IBOutlet weak var editButton:UIButton!
    @IBOutlet weak var isFinishImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.multilineTextfield(noteField)
        Utilities.styleFilledButton(editButton)
        
        firebaseService.storageRef = firebaseService.storage.reference()
        firebaseService.startListener()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let text = text,
           let customerName = customerName,
           let plate = plate,
           let size = size,
           let dateAdded = dateAdded,
           let dateFinished = dateFinished,
           let phone = phone,
           let isClean = isClean,
           let price = price,
           let note = note {
            idLabel.text?               = text
            nameField.text?             = customerName
            plateField.text?            = plate
            sizeField.text?             = size
            dateAddedField.text?        = dateAdded
            dateFinishedField.text?     = dateFinished
            phoneField.text?            = phone
            isCleanField.text?          = isClean
            priceField.text?            = price
            noteField.text?             = note
            
            if isCleanField.text == "Færdig" || isCleanField.text == "færdig"  {
                isFinishImage.tintColor! = UIColor.green
            }
        }
    }
    
    @IBAction func editPressed(_ sender: UIButton) {
        if let newName = nameField.text,
           let newPlate = plateField.text,
           let newSize = sizeField.text,
           let newDateAdded = dateAddedField.text,
           let newDateFinished = dateFinishedField.text,
           let newPhone = phoneField.text,
           let newClean = isCleanField.text,
           let newPrice = priceField.text,
           let newNote = noteField.text {
            //fS.editNote(index: currentEditIndex, text: txt)
            fS.editJob(index: rowSelectedFromSegue!,
                       nameOfCustomer: newName,
                       plates: newPlate,
                       price: newPrice,
                       size: newSize,
                       dateAdded: newDateAdded,
                       dateFinished: newDateFinished,
                       note: newNote,
                       isClean: newClean,
                       phoneNumber: newPhone)
        } 
    }
    @IBAction func callCustomerPressed(_ sender: Any) {
        callNumber(phoneNumber: phoneField.text ?? "KAN IKKE FINDE NUMMER")
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
}
