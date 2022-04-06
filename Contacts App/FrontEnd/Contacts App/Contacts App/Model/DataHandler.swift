//
//  DataHandler.swift
//  Contacts App
//
//  Created by Smit Patel on 2022-04-06.
//

import UIKit

protocol DataHandlerDelegate {
    func didUpdateContacts(_ dataHandler : DataHandler, contacts : [Contact])
    func didfailwitherror(error : Error)
}

struct DataHandler{
    
    let url = "http://localhost:8080/"
    var delegate : DataHandlerDelegate?
    
    func fetchContacts()
    {
        let urlString = "\(url)allcontacts"
        performRequest(urlString: urlString)
    }
    
    func addContacts(contact : Contact){
        
        let Url = URL(string: "\(url)addcontact")
        let parameters = " {\"firstName\":\"\(contact.firstName)\",\"lastName\":\"\(contact.lastName)\",\"email\":\"\(contact.email)\",\"phone\":\"\(contact.phone)\"}"
        
        print(parameters)
        let postData = parameters.data(using: .utf8)
        
        
        var request = URLRequest(url: Url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = postData
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            if let safeData = data {
                
                parseData(response: safeData)
            }
        }
        task.resume()
    }
    
    func updateContacts(contact : Contact, id: Int){
        
        let Url = URL(string: "\(url)updatecontact?cid=\(id)")
        let parameters = " {\"firstName\":\"\(contact.firstName)\",\"lastName\":\"\(contact.lastName)\",\"email\":\"\(contact.email)\",\"phone\":\"\(contact.phone)\"}"
        
        print(parameters)
        let postData = parameters.data(using: .utf8)
        
        
        var request = URLRequest(url: Url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = postData
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error!)
            }
            if let safeData = data {
                parseData(response: safeData)
            }
        }
        task.resume()
    }
    
    func deleteContacts(id : Int){
        
        let Url = URL(string: "\(url)deletecontact")
        let parameters = " {\"cid\":\"\(id)\"}"
        
        print(parameters)
        let postData = parameters.data(using: .utf8)
        
        
        var request = URLRequest(url: Url!)
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = postData
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
            }
            if let safeData = data {
                parseData(response: safeData)
            }
        }
        task.resume()
    }
    
    func parseData(response: Data){
        do{
            
            let jsonData = try JSONSerialization.jsonObject(with: response, options: .fragmentsAllowed) as? [String: Any]
            if let data = jsonData{
                print(data["message"])
            }
        }
        catch{
            print("error")
        }
        
    }
    
    func performRequest(urlString : String){
        
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didfailwitherror(error: error!)
                    return
                }
                if let safeData = data {
                    if let contacts = self.parseJSON(contactData: safeData){
                        self.delegate?.didUpdateContacts(self, contacts: contacts)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(contactData: Data ) -> [Contact]? {
        
        var arrContacts = [Contact]()
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(ContactData.self, from: contactData)
            
            for contact in decodedData.contacts{
                let u = Contact(cid: contact.cid, firstName: contact.firstName, lastName: contact.lastName, email: contact.email, phone: contact.phone)
                arrContacts.append(u)
            }
            return arrContacts
        } catch
        {
            delegate?.didfailwitherror(error: error)
            return nil
        }
        
    }
    
    
}
