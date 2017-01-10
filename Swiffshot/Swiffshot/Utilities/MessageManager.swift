//
//  MessageManager.swift
//  Swiffshot
//
//  Created by Dmitry Kuklin on 10.01.17.
//  Copyright © 2017 Dmitry Kuklin. All rights reserved.
//

import UIKit
import TwilioChatClient

class MessageManager: NSObject, TwilioChatClientDelegate  {
    
    static let shared = MessageManager()
    var client = TwilioChatClient()
    
    func getAccessToken(userId: Int, channelName: String, success:(String) -> Void, failure: NSError? -> Void) {
        ApiManager.shared.getAccessTokenToChat("\(userId)", success: { (result) in
                self.client = TwilioChatClient(token: result, properties: nil, delegate: self)
                self.createChannel(channelName, isPublic: true)
                success(result)
            }) { (error) in
                failure(error)
        }
    }
    
    func createChannel(channelName: String, isPublic: Bool){
        let chatType = isPublic ? "public" : "private"
        let options = [
            TCHChannelOptionFriendlyName: channelName,
            TCHChannelOptionType: chatType
        ]
        client.channelsList().createChannelWithOptions(options, completion: { channelResult, channel in
            if (channelResult?.isSuccessful())! {
                print("Channel created.")
            } else {
                print("Channel NOT created.")
            }
        })
    }
    
    func joinChannel(channelName: String){
        client.channelsList().channelWithSidOrUniqueName(channelName, completion: { channelResult in
            if let channel = channelResult.1 {
                channel.joinWithCompletion({ channelResult in
                    if channelResult.isSuccessful() {
                        print("Channel joined.")
                    } else {
                        print("Channel NOT joined.")
                    }
                })
            }
        })
    }
    
    func sendMessage(text: String, channel: TCHChannel){
        if let messages = channel.messages {
            let message = messages.createMessageWithBody(text)
            messages.sendMessage(message, completion:{ result in
                if result.isSuccessful() {
                    print("Message sent.")
                } else {
                    print("Message NOT sent.")
                }
            })
        }
    }
    
    func getPreviousMessagesinChannel(channel: TCHChannel, fromIndex: Int, count: Int){
        channel.messages.getMessagesAfter(UInt(fromIndex), withCount: UInt(count)) { (result, allMessages) in
            if result.isSuccessful() {
                for message in allMessages{
                    print("\(message.author) and \(message.body)")
                }
            } else {
                print("NO messages")
            }
        }
    }
    
    func closeChannel(channel: TCHChannel){
        channel.destroyWithCompletion { result in
            if result.isSuccessful() {
                print("Channel destroyed.")
            } else {
                print("Channel NOT destroyed.")
            }
        }
    }
}
