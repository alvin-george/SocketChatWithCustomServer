//
//  SocketIOMangerForOneToOneChat.swift
//  SampleSockerIOChat
//
//  Created by apple on 11/09/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import SocketIO

class SocketIOMangerForOneToOneChat: NSObject {
    static let sharedInstance = SocketIOMangerForOneToOneChat()
    
    var receiverCivilId:String?
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "https://eyalzayed.com")!,config: [.log(true), .connectParams(["civilId" : "CIV1T111"]),.reconnects(true),.reconnectAttempts(2),.reconnectWait(2000),.forceWebsockets(true)])
    
    override init() {
        super.init()
    }
    func establishConnection() {
            self.socket.connect()
    }
    func closeConnection() {
        socket.disconnect()
    }
    func connectToServerWithNickname(_ nickname: String, completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
        
        socket.emit("connectUser", nickname)
        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(dataArray[0] as? [[String: AnyObject]])
        }
        listenForOtherMessages()
    }
    func exitChatWithNickname(_ nickname: String, completionHandler: () -> Void) {
        
        socket.emit("exitUser", nickname)
        completionHandler()
    }
    func getChatMessage(_ completionHandler: @escaping (_ messageInfo: [String: AnyObject]) -> Void) {
   
        socket.on("new message") { (dataArray, socketAck) -> Void in
            
            print("dataArray : \(dataArray)")
            var messageDictionary = [String: AnyObject]()
            
            messageDictionary["nickname"] = "Alvin" as AnyObject
            messageDictionary["message"] = "Sample" as AnyObject
            messageDictionary["date"] = "7th August" as AnyObject
            
//            messageDictionary["nickname"] = dataArray[0] as! String as AnyObject
//            messageDictionary["message"] = dataArray[1] as! String as AnyObject
//            messageDictionary["date"] = dataArray[2] as! String as AnyObject
            
            completionHandler(messageDictionary)
        }
    }
    
    
    fileprivate func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasConnectedNotification"), object: dataArray[0] as! [String: AnyObject])
        }
        
        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userWasDisconnectedNotification"), object: dataArray[0] as! String)
        }
        
        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userTypingNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    
    func sendStartTypingMessage(_ nickname: String) {
        //socket.emit("startType", nickname)
    }
    
    
    func sendStopTypingMessage(_ nickname: String) {
        //socket.emit("stopType", nickname)
    }
}
