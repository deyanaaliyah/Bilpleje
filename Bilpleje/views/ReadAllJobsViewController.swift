//
//  ReadAllJobsViewController.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/5/21.
//

import UIKit
import Firebase

let fSReadAll = FirebaseService()
class ReadAllJobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Updateable {
    // ATTRIBUTES
    private var db = Firestore.firestore()
    private var currentEditIndex = -1 // initialized as invalid
    private var allJobsCollectionRef: CollectionReference!
    private var readAllJobs = [Cleaning]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var btnPressed: UIButton!
    var searchCustomer = [String]()
    var jobsInArray = [String]()
    var searching = false
    
    @IBAction func btnPressed(_ sender: Any) {
        print("user clicked")
    }
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        fSReadAll.startListener()
        fSReadAll.parent = self

        tableView.delegate = self
        tableView.dataSource = self
        
        fSReadAll.storageRef = fSReadAll.storage.reference()
        allJobsCollectionRef = Firestore.firestore().collection("allJobs")
        
        self.hideKeyboardWhenTappedAround()
        
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView.alpha = 0
    }
    
    // FETCHING
    override func viewWillAppear(_ animated: Bool) {
        allJobsCollectionRef.getDocuments { (snapshot, error) in
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
                    let price1 = data["price"]                   as? String ?? "N/A"
                    let documentId1 = document.documentID

                    let readAllJobs = Cleaning(id: documentId1,
                                               nameOfCustomer: name1,
                                               plates: plate1,
                                               price: price1,
                                               size: size1,
                                               dateAdded: dateAdded1,
                                               dateFinished: dateFinished1,
                                               note: note1,
                                               isClean: isClean1,
                                               phoneNumber: phone1)

                    self.readAllJobs.append(readAllJobs)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    // UPDATEABLE()
    func update() {
        tableView.reloadData()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // TABLE VIEW()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchCustomer.count
        } else {
            return fSReadAll.jobArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        
        if searching {
            tableView.alpha = 1
            spinner.stopAnimating()
            
            cell.textLabel?.text = searchCustomer[indexPath.row]
        }else {
            spinner.stopAnimating()
            tableView.alpha = 1
            
            cell.textLabel?.text = String(fSReadAll.jobArray[indexPath.row].nameOfCustomer.prefix(25))
        }
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // EDIT NOTE()
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print("edit called at index: \(indexPath.row)")
        
        // DELETE()
        fSReadAll.delete(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade) // this requires the underlying data source also gets updated
    }
    // SEGUE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentEditIndex = indexPath.row
        
        performSegue(withIdentifier: "showDetail", sender: indexPath)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let rowSelected = (sender as! NSIndexPath).row
        
        if let destinationVC = segue.destination as? ShowDetailViewController {
            destinationVC.rowSelectedFromSegue = rowSelected
            
            let find = fSReadAll.jobArray[rowSelected]
            
            destinationVC.text          = find.nameOfCustomer
            destinationVC.customerName  = find.nameOfCustomer
            destinationVC.plate         = find.plates
            destinationVC.size          = find.size
            destinationVC.dateAdded     = find.dateAdded
            destinationVC.dateFinished  = find.dateFinished
            destinationVC.phone         = find.phoneNumber
            destinationVC.isClean       = find.isClean
            destinationVC.price         = find.price
            destinationVC.note          = find.note
        }
    }
}

















// MARK: EXTENSIONS
extension ReadAllJobsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        db.collection("allJobs").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let name = data["nameOfCustomer"] as? String ?? "N/A"
                    self.jobsInArray.append("\(name)")
                    
                    self.jobsInArray = Array(Set(self.jobsInArray))
                    
                    self.searchCustomer = self.jobsInArray.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
                    // $0 means that it'll find each and every elemnt in array
                    self.searching = true
                }
                self.tableView.reloadData() 
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}
