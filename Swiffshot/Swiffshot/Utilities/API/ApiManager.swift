//
//  ApiManager.swift
//  underdog
//
//  Created by Дмитрий on 27.01.16.
//  Copyright © 2016 underdog. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ApiManager {
    static let shared = ApiManager()
    static let apiURL = "http://54.191.249.83"
    
    // MARK: - common send request method
    
    private func sendRequest(request: NSMutableURLRequest, failure: NSError? -> Void, resultHandler: [String: AnyObject] -> Void) {
        #if !TEST
        request.timeoutInterval = 20.0
        #endif
        NSURLSession.sharedSession().dataTaskWithRequest(request) {(data, response, error) in
            if (data != nil) {
                let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                print("****** response data = \(responseString!)")
                
                if let json = try?  NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String: AnyObject] {
                    if let result = json!["result"] as? [String : AnyObject] {
                        resultHandler(result)
                    } else if let _ = json!["result"] as? NSArray {
                        resultHandler(json!)
                    } else if let errorDict = json!["error"] as? [String : AnyObject] {
                        dispatch_async(dispatch_get_main_queue()) {
                            let response = ErrorModel(json: errorDict)
                            let error = NSError(domain: "Underdog", code: response.code, userInfo: ["Description" : response.text])
                            failure(error)
                        }
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        print(error)
                        failure(error)
                    }
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    failure(error)
                }
            }
        }.resume()
    }
    
    // MARK: - POST requests
    
    //получить документ html
//    func getDocument(documentType: DocumentType, success:(DocumentModel) -> Void, failure: NSError? -> Void) {
//        var documentID = ""
//        let methodName = "stat/export/underdog/get_doc.json?id=\(documentID)"
//        let urlString = "\(ApiManager.russianBaseURL)\(methodName)"
//        let url = NSURL(string: urlString)!
//        
//        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
//        request.HTTPMethod = "GET"
//        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
//        sendRequest(request, failure: failure) { json in
//            if json["error"] == nil {
//                dispatch_async(dispatch_get_main_queue()) {
//                    let dict = json as [String:AnyObject]
//                    let response = DocumentModel(json: dict)
//                    success(response)
//                }
//            }
//        }
//    }
    
    // MARK: - GET requests
    
    //получить информацию о профиле пользователя
//    func getCodeToAuth(userId: String, success:(ProfileModel) -> Void, failure: NSError? -> Void) {
//        getToken({ (tokenModel) in
//            let methodName = "stat/export/underdog/user/profile.json?auth_token=\(self.token!.token)&cache_timestamp=\(Settings.betTimeStamp)"
//            let urlString = "\(self.apiURL)\(methodName)"
//            let url = NSURL(string: urlString)!
//            
//            let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
//            request.HTTPMethod = "GET"
//            request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
//            self.sendRequest(request, failure: failure) { json in
//                if json["error"] == nil {
//                    dispatch_async(dispatch_get_main_queue()) {
//                        self.profileUpdate(json, success: success)
//                    }
//                }
//            }
//        }) { (error) in
//            failure(error)
//        }
//    }
    

}