//
//  ContactsManager.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 10.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit
import Contacts

class ContactsManager {
    static let shared = ContactsManager()
    private var usersContacts = [CNContact]()
    
//    private func getContacts(){
//        let store = CNContactStore()
//        
//        if CNContactStore.authorizationStatusForEntityType(.Contacts) == .NotDetermined {
//            store.requestAccessForEntityType(.Contacts, completionHandler: { (authorized: Bool, error: NSError?) -> Void in
//                if authorized {
//                    self.retrieveContactsWithStore(store)
//                }
//            })
//        } else if CNContactStore.authorizationStatusForEntityType(.Contacts) == .Authorized {
//            self.retrieveContactsWithStore(store)
//        }
//    }
//    
//    private func retrieveContactsWithStore(store: CNContactStore) {
//        do {
////            let groups = try store.groupsMatchingPredicate(nil)
//            let predicate = CNContact.predicateForContactsMatchingName("")
//            //let predicate = CNContact.predicateForContactsMatchingName("John")
//            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName), CNContactEmailAddressesKey]
//            
//            let contacts = try store.unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
//            self.usersContacts = contacts
//        } catch {
//            print(error)
//        }
//    }
    
    func findContactsOnBackgroundThread ( completionHandler:(contacts:[CNContact]?)->()) {
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),CNContactPhoneNumbersKey] //CNContactIdentifierKey
            let fetchRequest = CNContactFetchRequest( keysToFetch: keysToFetch)
            var contacts = [CNContact]()
            CNContact.localizedStringForKey(CNLabelPhoneNumberiPhone)
            
            fetchRequest.mutableObjects = false
            fetchRequest.unifyResults = true
            fetchRequest.sortOrder = .UserDefault
            
            let contactStoreID = CNContactStore().defaultContainerIdentifier()
            print("\(contactStoreID)")
            
            
            do {
                
                try CNContactStore().enumerateContactsWithFetchRequest(fetchRequest) { (contact, stop) -> Void in
                    //do something with contact
                    if contact.phoneNumbers.count > 0 {
                        contacts.append(contact)
                    }
                    
                }
            } catch let e as NSError {
                print(e.localizedDescription)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(contacts: contacts)
                
            })
        })
    }
    
    func checkMyFriends(){
        findContactsOnBackgroundThread { (contacts) in
            var allPhones = [String]()
            for contact in contacts!{
                for phone in contact.phoneNumbers{
                    let number  = phone.value as! CNPhoneNumber
                    allPhones.append(number.stringValue)
                }
            }
            //TODO: send to server
        }
    }
}
