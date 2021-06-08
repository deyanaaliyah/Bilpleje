//
//  EarningsViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/18/21.
//

import UIKit
import Firebase

let fSReadPrices = FirebaseService()
class EarningsViewController: UIViewController {
    // ATTRIBUTES
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var totalLabel: UILabel!
    
    private var db = Firestore.firestore()
    private var priceCollectionRef: CollectionReference!
    private var readAllPrices = [Cleaning]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fSReadPrices.storageRef = fSReadAll.storage.reference()
        priceCollectionRef = Firestore.firestore().collection("allJobs")

        spinner.startAnimating()
        
        getPricesFromDatabase()
    }
    
    func getPricesFromDatabase() {
        priceCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("error fetching data ------ \(err)")
            }else {
                guard let snap = snapshot else {return}
                
                for document in snap.documents {
                    let data = document.data()
                    
                    let name1 = data["nameOfCustomer"]           as? String ?? "N/A"
                    let plate1 = data["plates"]                  as? String ?? "N/A"
                    let phone1 = data["phoneNumber"]             as? String ?? "N/A"
                    let size1 = data["size"]                     as? String ?? "N/A"
                    let note1 = data["note"]                     as? String ?? "N/A"
                    let isClean1 = data["isClean"]               as? String ?? "N/A"
                    let dateAdded1 = data["dateAdded"]           as? String ?? "N/A"
                    let dateFinished1 = data["dateFinished"]     as? String ?? "N/A"
                    let price1 = data["price"]                   as? String ?? "0"
                    let documentId1 = document.documentID
                    
                    let readAllPrices = Cleaning(id: documentId1, nameOfCustomer: name1, plates: plate1, price: price1, size: size1, dateAdded: dateAdded1, dateFinished: dateFinished1, note: note1, isClean: isClean1, phoneNumber: phone1)
                    
                    self.readAllPrices.append(readAllPrices)
                    
//                    let arrayToInt = readAllPrices.price.compactMap { Int(String($0))!}
//
//                    let totalEarning = arrayToInt.reduce(0, {$0 + $1})
//
//                    self.totalLabel.text = "\(totalEarning)"
                }
                //self.viewDidLoad()
            }
        }
    }
}
