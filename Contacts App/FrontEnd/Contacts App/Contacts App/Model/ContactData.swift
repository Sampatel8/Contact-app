//
//  ContactData.swift
//  Contacts App
//
//  Created by Smit Patel on 2022-04-06.
//

import UIKit

struct ContactData: Codable {
    
    var error : Bool
    var message : String
    var contacts : [Contact]
    
}

struct Contact: Codable {
    
    var cid : Int?
    var firstName : String
    var lastName : String
    var email : String
    var phone : String
    //var photo : String
}


