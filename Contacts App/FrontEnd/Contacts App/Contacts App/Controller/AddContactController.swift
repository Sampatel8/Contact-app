//
//  AddContactController.swift
//  Contacts App
//
//  Created by Smit Patel on 2022-04-06.
//

import UIKit

class AddContactController: UIViewController {
    
    
    @IBOutlet weak var addContactFname: UITextField!
    @IBOutlet weak var addContactLname: UITextField!
    @IBOutlet weak var addContactEmail: UITextField!
    @IBOutlet weak var addContactPhone: UITextField!
    
    var currentUser: Contact?
    var isReloadData: Bool = false
    
    var dataHandler = DataHandler()
    
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.setTitle(isReloadData ? "UPDATE" : "SAVE", for: .normal)
        if isReloadData{
            if let userData = currentUser{
                reloadData(userInfo: userData)
            }
        }
    }
    
    func reloadData(userInfo: Contact){
        addContactFname.text = userInfo.firstName
        addContactLname.text = userInfo.lastName
        addContactEmail.text = userInfo.email
        addContactPhone.text = userInfo.phone
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if isReloadData{
            if let id = currentUser?.cid{
                let updatedContact = Contact(cid: id, firstName: addContactFname.text!, lastName: addContactLname.text!, email: addContactEmail.text!, phone: addContactPhone.text!)
                self.dataHandler.updateContacts(contact: updatedContact, id: id)
                makeAlert(message: "Contact Updated successfully")
            }else{
                makeAlert(message: "Something went Wrong...!")
            }
        }else{
            
            guard let phone = addContactPhone.text else {return}
            guard let email = addContactEmail.text else {return}
            if validate(value: phone) && isValidEmail(email: email)
            {
                let newContact = Contact(cid: nil, firstName: addContactFname.text!, lastName: addContactLname.text!, email: addContactEmail.text!, phone: addContactPhone.text!)
                self.dataHandler.addContacts(contact: newContact)
                makeAlert(message: "Contact added successfully")
                
                addContactFname.text = ""
                addContactLname.text = ""
                addContactEmail.text = ""
                addContactPhone.text = ""
            }
            else{
                makeAlert(message: "Email or Phone number is incorrect..!")
            }
            
            
        }
    }
    
    func makeAlert(message : String){
        
        let dialogMessage = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            dialogMessage.dismiss(animated: true, completion: nil)
        }
        dialogMessage.addAction(okAction)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func validate(value: String) -> Bool {
        if value.count == 10 {
            return true
        }else{
            return false
        }
    }
    func isValidEmail(email: String) -> Bool {
        
        if email.contains("@"){
            if email.contains("."){
                return true
            }else { return false}
        } else {return false}
    }
    
}
