//
//  ViewController.swift
//  Contacts App
//
//  Created by Smit Patel on 2022-04-06.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contactsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    var contactArray = [Contact]()
    var dataHandler = DataHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        dataHandler.delegate = self
        self.contactsActivityIndicator.startAnimating()
        self.contactsActivityIndicator.isHidden = false
        dataHandler.fetchContacts()
    }
    
    
    @IBAction func addNewContactButton(_ sender: UIBarButtonItem) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddContactController else { return }
        vc.isReloadData = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func sortContactsButton(_ sender: UIBarButtonItem) {
        contactArray = contactArray.sorted(by: { $0.firstName > $1.firstName })
        mainTableView.reloadData()
    }
    
    func makeAlert(message : String){
        
        let dialogMessage = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dataHandler.fetchContacts()
            self.mainTableView.reloadData()
        }
        dialogMessage.addAction(okAction)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        cell.nameLabel.text = "\(contactArray[indexPath.row].firstName) \(contactArray[indexPath.row].lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            guard let id = contactArray[indexPath.row].cid else {return}
            dataHandler.deleteContacts(id: id)
            makeAlert(message: "Contact Deleted Successfully..!")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddNewContactViewController") as? AddContactController else { return }
        vc.isReloadData = true
        vc.currentUser = contactArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ViewController : DataHandlerDelegate{
    func didUpdateContacts(_ dataHandler: DataHandler, contacts: [Contact]) {
        contactArray = contacts
        
        DispatchQueue.main.async {
            self.contactsActivityIndicator.isHidden = true
            self.contactsActivityIndicator.stopAnimating()
            self.mainTableView.reloadData()
        }
    }
    
    func didfailwitherror(error: Error) {
        print(error)
    }
    
}

