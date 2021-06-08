//
//  Cleaning.swift
//  Bilpleje
//
//  Created by Dejan Love on 3/4/21.
//

import Foundation

class Cleaning {
    
    var id:String,
        nameOfCustomer: String,
        plates: String,
        price:String,
        size:String,
        dateAdded:String,
        dateFinished:String,
        note:String,
        isClean:String,
        phoneNumber:String
    
    // init means preparing this class for use
    init(id:String, nameOfCustomer:String, plates: String, price:String,size:String, dateAdded:String, dateFinished:String, note:String, isClean:String, phoneNumber:String) {
        self.id = id
        self.nameOfCustomer = nameOfCustomer
        self.plates = plates
        self.price = price
        self.size = size
        self.dateAdded = dateAdded
        self.dateFinished = dateFinished
        self.note = note
        self.isClean = isClean
        self.phoneNumber = phoneNumber
    }
}
