//
//  CreateViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/4/21.
//

import UIKit
import Firebase

let firebaseService = FirebaseService()

class CreateViewController: UIViewController {
    // ATTRIBUTES
    private var db = Firestore.firestore()
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var nameOfCustomer: UITextField!
    @IBOutlet weak var plates: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var size: UISegmentedControl!
    @IBOutlet weak var chosenDate: UITextField!
    @IBOutlet weak var dogHair: UISwitch!
    @IBOutlet weak var wax: UISwitch!
    @IBOutlet weak var vacuum: UISwitch!
    @IBOutlet weak var isClean: UISegmentedControl!
    @IBOutlet weak var phoneNumber: UITextField!
    
    var notes:[String] = ["","",""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Database conn
        firebaseService.storageRef = firebaseService.storage.reference()
        firebaseService.startListener()
        
        // Styling
        createDatePicker()
        Utilities.styleFilledButton(sendButton)
        
        // Hides keyboard, inherits from ViewController
        self.hideKeyboardWhenTappedAround()
    }

    // SAVE BUTTON()
    @IBAction func saveToFirebase(_ sender: Any) {
        
        // TODAY'S DATE
        let date            = Date()
        let format          = DateFormatter()
        format.dateFormat   = "yyyy-MM-dd"
        let dateInit        = format.string(from: date)
        
        // CAR SIZE + ISCLEAN FROM SEGMENTCTRL
        let carSize         = size.titleForSegment(at: size.selectedSegmentIndex)
        let isItClean       = isClean.titleForSegment(at: isClean.selectedSegmentIndex)
        
        // NOTE
        let note = notes.joined()
        
        // SEND TO FIREBASE
        if let name         = nameOfCustomer.text,
           let plate        = plates.text,
           let thePrice     = price.text,
           let carSize      = carSize,
           let dateFinish   = chosenDate.text,
           let isItClean    = isItClean,
           let phone        = phoneNumber.text {
            firebaseService.addJob(nameOfCustomer: name,
                                   plates: plate,
                                   price: thePrice,
                                   size: carSize,
                                   dateAdded: dateInit,
                                   dateFinished: dateFinish,
                                   note: note,
                                   isClean: isItClean,
                                   phoneNumber: phone)
            
            // ALERT
            let successful = UIAlertController(title: "Legende", message: "\(name) kan nu ses i databasen!", preferredStyle: .alert)
            // OKBtn
            let okAction = UIAlertAction(title: "Yes sir!", style: .default) { (action) in
                print(action)
                self.nameOfCustomer.text    = ""
                self.plates.text            = ""
                self.price.text             = ""
                self.chosenDate.text        = ""
                self.phoneNumber.text       = ""
            }
            successful.addAction(okAction)
            
            // Present the alert
            present(successful, animated: true, completion: nil)
        }
        
        else {
            print("could not create job")
            let unsuccessful = UIAlertController(title: "Fejl", message: "Kunne ikke oprette job, prøv igen", preferredStyle: .alert)
            // OKBtn / Closure
            let okAction = UIAlertAction(title: "Ok :/", style: .default) { (action) in
                print(action)
            }
            unsuccessful.addAction(okAction)
            
            present(unsuccessful, animated: true, completion: nil)
        }
    }
    
    // DATE TOOLBAR
    let datePicker = UIDatePicker()
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        // assign toolbar
        chosenDate.inputAccessoryView = toolbar
        
        // assign date picker to the text field
        chosenDate.inputView = datePicker
        
        // date picker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        chosenDate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    // UISWITCHES
    @IBAction func vacuumSwitch(_ sender: UISwitch) {
        // Get first UISwitch current status
        let switchStatus:Bool = sender.isOn
        
        if(switchStatus){
            notes.insert("HUSK : Støvsugning ", at: 0)
        }else{
            notes.remove(at: 0)
        }
    }
    @IBAction func waxSwitch(_ sender: UISwitch) {
        // Get first UISwitch current status
        let switchStatus:Bool = sender.isOn
        
        if(switchStatus){
            notes.insert("HUSK : Polering ", at: 1)
        }else{
            notes.remove(at: 1)
        }
    }
    @IBAction func dogHairSwitch(_ sender: UISwitch) {
        // Get first UISwitch current status
        let switchStatus:Bool = sender.isOn
        
        if(switchStatus){
            notes.insert("HUSK : Hundehår ", at: 2)
        }else{
            notes.remove(at: 2)
        }
    }
}
