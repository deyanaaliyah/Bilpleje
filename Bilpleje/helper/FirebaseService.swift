//
//  FirebaseService.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/4/21.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseService {
    // ATTRIBUTES
    private var db = Firestore.firestore()
    private var allJobsCol = "allJobs"
    
    var storage = Storage.storage()
    var storageRef:StorageReference?
    var jobArray = [Cleaning]()
    var parent:Updateable?
    
    // LISTENER()
    func startListener(){ // will keep listening
        db.collection(allJobsCol).addSnapshotListener { (snap, error) in
            if let e = error {
                print("error fetching data \(e)")
            }
            else {
                if let s = snap {
                    self.jobArray.removeAll()
                    
                    for doc in s.documents {
                        if let theName          = doc.data()["nameOfCustomer"]  as? String,
                           let thePlates        = doc.data()["plates"]          as? String,
                           let theDateAdded     = doc.data()["dateAdded"]       as? String,
                           let theDateFinished  = doc.data()["dateFinished"]    as? String,
                           let isItClean        = doc.data()["isClean"]         as? String,
                           let theNote          = doc.data()["note"]            as? String,
                           let theNumber        = doc.data()["phoneNumber"]     as? String,
                           let thePrice         = doc.data()["price"]           as? String,
                           let theSize          = doc.data()["size"]            as? String{
                            
                            let jobs            = Cleaning(id: doc.documentID,
                                                           nameOfCustomer: theName,
                                                           plates: thePlates,
                                                           price: thePrice,
                                                           size: theSize,
                                                           dateAdded: theDateAdded,
                                                           dateFinished: theDateFinished,
                                                           note: theNote,
                                                           isClean: isItClean,
                                                           phoneNumber: theNumber)
                            self.jobArray.append(jobs)
                        }
                    }
                    self.parent?.update()
                }
            }
        }
    }
    
    // ADD A JOB()
    func addJob(nameOfCustomer:String, plates: String, price:String, size:String, dateAdded:String, dateFinished:String, note:String, isClean:String, phoneNumber:String) {
        print("add job is called")
        
        if nameOfCustomer.count > 0 {
            let doc = db.collection(allJobsCol).document() // will create new documet
            
            let data = ["nameOfCustomer":nameOfCustomer,
                        "plates": plates,
                        "phoneNumber": phoneNumber,
                        "price":price,
                        "size":size,
                        "dateAdded":dateAdded,
                        "dateFinished":dateFinished,
                        "note":note,
                        "isClean":isClean]
            doc.setData(data) // will save to Firebase
        }
    }
    
    // UPDATE()
    func editJob(index:Int,
                 nameOfCustomer:String,
                 plates: String,
                 price:String,
                 size:String,
                 dateAdded:String,
                 dateFinished:String,
                 note:String,
                 isClean:String,
                 phoneNumber:String) {
        
        if phoneNumber.count > 0 {
            
            let doc = db.collection(allJobsCol).document(jobArray[index].id)
            
            let data = ["nameOfCustomer":nameOfCustomer,
                        "plates": plates,
                        "phoneNumer": phoneNumber,
                        "price":price,
                        "size":size,
                        "dateAdded":dateAdded,
                        "dateFinished":dateFinished,
                        "note":note,
                        "isClean":isClean,
                        "phoneNumber": phoneNumber]
            doc.setData(data)
        }
    }
    
    // DELETE()
    func delete(index:Int) {
        if index < jobArray.count {
            let docId = jobArray[index].id
            db.collection(allJobsCol).document(docId).delete() { err in
                if let e = err {
                    print("error deleting \(docId) ---- \(e)")
                }else {
                    print("deleting")
                }
            }
            jobArray.remove(at: index)
        }
    }
}
