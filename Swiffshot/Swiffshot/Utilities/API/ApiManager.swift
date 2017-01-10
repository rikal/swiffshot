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
    static let apiURL = "http://35.164.86.162"
    
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
                    if let errorDict = json!["error"] as? [String : AnyObject] {
                        dispatch_async(dispatch_get_main_queue()) {
                            let response = ErrorModel(json: errorDict)
                            let error = NSError(domain: "Underdog", code: response.code, userInfo: ["Description" : response.text])
                            failure(error)
                        }
                    } else {
                        resultHandler(json!)
                    }
                } else if let httpResponse = response as? NSHTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        let response = ["answer": "Ok"]
                        resultHandler(response)
                    //TODO: REMOVE
                    } else {
                        let response = ["answer": "Ok"]
                        resultHandler(response)
                    }
                }else {
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
    
    //get user with ID
    func getUserWithId(user: ProfileModel, success:(ProfileModel) -> Void, failure: NSError? -> Void) {
        let methodName = ":1111/user"
        let urlString = "\(ApiManager.apiURL)\(methodName)"
        let url = NSURL(string: urlString)!
        
        let params = ["userName": user.userName, "userLastName": user.userLastName, "userNickName": user.userNickName, "userBirthday": user.userBirthday, "phoneNumber": user.phoneNumber, "userEmail": user.email]
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sendRequest(request, failure: failure) { json in
            if json["error"] == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    let dict = json as [String:AnyObject]
                    let response = ProfileModel(json: dict)
                    success(response)
                }
            }
        }
    }
    
    //check verification code
    func checkVerificationCode(code: String, userId: Int, success:(String) -> Void, failure: NSError? -> Void) {
        let methodName = ":3333/\(userId)/verifyCode"
        let urlString = "\(ApiManager.apiURL)\(methodName)"
        let url = NSURL(string: urlString)!
        
        let params = ["code": code]
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "POST"
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        sendRequest(request, failure: failure) { json in
            if json["error"] == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    success("Ok")
                }
            }
        }
    }
    
    // MARK: - GET requests
    
    // get verification code
    func getCodeToVerify(userId: String, success:(String) -> Void, failure: NSError? -> Void) {
        let methodName = ":3333/\(userId)/sendCode"
        let urlString = "\(ApiManager.apiURL)\(methodName)"
        let url = NSURL(string: urlString)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "GET"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        self.sendRequest(request, failure: failure) { json in
            if json["error"] == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    success("Ok")
                }
            }
        }
    }
    
    func getAccessTokenToChat(userId: String, success:(String) -> Void, failure: NSError? -> Void) {
        let methodName = ":3333/\(userId)/getAccessToken"
        let urlString = "\(ApiManager.apiURL)\(methodName)"
        let url = NSURL(string: urlString)!
        
        let request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        request.HTTPMethod = "GET"
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")
        self.sendRequest(request, failure: failure) { json in
            if json["error"] == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    success("Ok")
                }
            }
        }
    }

}