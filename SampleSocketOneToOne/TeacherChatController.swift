//
//  TeacherChatController.swift
//  SampleSockerIOChat
//
//  Created by apple on 31/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import SocketIO
import CoreData
import SwiftyJSON

class TeacherChatController:  UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    var socketManager = SocketIOMangerForOneToOneChat.sharedInstance
    var scoket = SocketIOMangerForOneToOneChat.sharedInstance.socket
    var socketChat: SocketIOClient!
    
    // var socket = SocketIOClient(socketURL: URL(string: "https://eyalzayed.com")!,config: [.log(true), .connectParams(["civilId" : "CIV1T111"]),.reconnects(true),.reconnectAttempts(2),.reconnectWait(2000),.forceWebsockets(true)])
    
    var query:String?
    var endpoint:String?
    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var lblOtherUserActivityStatus: UILabel!
    @IBOutlet weak var tvMessageEditor: UITextView!
    @IBOutlet weak var conBottomEditor: NSLayoutConstraint!
    @IBOutlet weak var lblNewsBanner: UILabel!
    
    var nickname: String!
    var parentName:String?
    var teacherCivilID:String?
    var parentCivilID:String?
    
    var senderChatMessages:[NSManagedObject]?
    var senderChats:[String : AnyObject]?
    
    var chatMessages = [[String: AnyObject]]()
    
    var bannerLabelTimer: Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addInitialUISetup()
        self.addNotificationObservers()
        self.addSwipeGestureToView()
        
        self.scoket.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addInitialUISetup()
        configureTableView()
        configureNewsBannerLabel()
        configureOtherUserActivityLabel()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //senderChats = (senderChatMessages?[0].value(forKey: "chat_messages") as? AnyObject as! [String : AnyObject])
//        print("senderChats: \(senderChats)")
//        self.chatMessages.append(senderChats!)
        
        
        //        self.tblChat.reloadData()
        //        self.scrollToBottom()
        
        self.socketManager.getChatMessage { (messageInfo) -> Void in
            DispatchQueue.main.async(execute: { () -> Void in
                self.chatMessages.append(messageInfo)
                //self.tblChat.reloadData()
                self.scrollToBottom()
            })
        }
        //        socket.on("new message") { (dataArray, socketAck) -> Void in
        //            print("dataArray : \(dataArray)")
        //            var messageDictionary = [String: AnyObject]()
        //        }
        
        print("chatMessages.count : \(chatMessages)")
        
    }
    
    func addInitialUISetup()
    {
        self.automaticallyAdjustsScrollViewInsets =  false
        self.configureAndConnectSocket()
        
        tvMessageEditor.layer.cornerRadius =  20.0
        tvMessageEditor.delegate = self
        
        nickname = "test Person"
        
        // senderChatMessages = coreDataManager.fetch(entity: COREDATA_ENTITY.SENDER_MESSAGES.rawValue)!
        //  print("senderChatMessages :\(senderChatMessages)")
    }
    func configureAndConnectSocket()
    {
        
        if(self.scoket.status == .connected) {
            print("socket connected")
        }
        else {
            print("socket not connected")
        }
    }
    
    func addNotificationObservers()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(TeacherChatController.handleKeyboardDidShowNotification(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TeacherChatController.handleKeyboardDidHideNotification(_:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TeacherChatController.handleConnectedUserUpdateNotification(_:)), name: NSNotification.Name(rawValue: "userWasConnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TeacherChatController.handleDisconnectedUserUpdateNotification(_:)), name: NSNotification.Name(rawValue: "userWasDisconnectedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(TeacherChatController.handleUserTypingNotification(_:)), name: NSNotification.Name(rawValue: "userTypingNotification"), object: nil)
    }
    func addSwipeGestureToView()
    {
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TeacherChatController.dismissKeyboard))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.down
        swipeGestureRecognizer.delegate = self
        view.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Custom Methods
    func configureTableView() {
        tblChat.delegate = self
        tblChat.dataSource = self
        // tblChat.register(UINib(nibName: "TeacherChatTableCell", bundle: nil), forCellReuseIdentifier: "teacherChatTableCell")
        tblChat.estimatedRowHeight = 190.0
        tblChat.rowHeight = UITableViewAutomaticDimension
        tblChat.tableFooterView = UIView(frame: CGRect.zero)
    }
    func configureNewsBannerLabel() {
        lblNewsBanner.layer.cornerRadius = 15.0
        lblNewsBanner.clipsToBounds = true
        lblNewsBanner.alpha = 0.0
    }
    func configureOtherUserActivityLabel() {
        lblOtherUserActivityStatus.isHidden = true
        lblOtherUserActivityStatus.text = ""
    }
    
    
    //KeyBoard notifications
    @objc func handleKeyboardDidShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                conBottomEditor.constant = keyboardFrame.size.height
                view.layoutIfNeeded()
            }
        }
    }
    @objc func handleKeyboardDidHideNotification(_ notification: Notification) {
        conBottomEditor.constant = 0
        view.layoutIfNeeded()
    }
    func scrollToBottom() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)) { () -> Void in
            if self.chatMessages.count > 0 {
                let lastRowIndexPath = IndexPath(row: self.chatMessages.count - 1, section: 0)
                self.tblChat.scrollToRow(at: lastRowIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        }
    }
    
    func showBannerLabelAnimated() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 1.0
            
        }, completion: { (finished) -> Void in
            self.bannerLabelTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: "hideBannerLabel", userInfo: nil, repeats: false)
        })
    }
    
    func hideBannerLabel() {
        if bannerLabelTimer != nil {
            bannerLabelTimer.invalidate()
            bannerLabelTimer = nil
        }
        
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.lblNewsBanner.alpha = 0.0
            
        }, completion: { (finished) -> Void in
        })
    }
    @objc func dismissKeyboard() {
        if tvMessageEditor.isFirstResponder {
            tvMessageEditor.resignFirstResponder()
            
            // socket.sendStopTypingMessage(nickname)
        }
    }
    @objc func handleConnectedUserUpdateNotification(_ notification: Notification) {
        let connectedUserInfo = notification.object as! [String: AnyObject]
        let connectedUserNickname = connectedUserInfo["nickname"] as? String
        lblNewsBanner.text = "User \(connectedUserNickname!.uppercased()) was just connected."
        showBannerLabelAnimated()
    }
    @objc func handleDisconnectedUserUpdateNotification(_ notification: Notification) {
        let disconnectedUserNickname = notification.object as! String
        lblNewsBanner.text = "User \(disconnectedUserNickname.uppercased()) has left."
        showBannerLabelAnimated()
    }
    
    @objc func handleUserTypingNotification(_ notification: Notification) {
        if let typingUsersDictionary = notification.object as? [String: AnyObject] {
            var names = ""
            var totalTypingUsers = 0
            for (typingUser, _) in typingUsersDictionary {
                if typingUser != nickname {
                    names = (names == "") ? typingUser : "\(names), \(typingUser)"
                    totalTypingUsers += 1
                }
            }
            
            if totalTypingUsers > 0 {
                let verb = (totalTypingUsers == 1) ? "is" : "are"
                
                lblOtherUserActivityStatus.text = "\(names) \(verb) now typing a message..."
                lblOtherUserActivityStatus.isHidden = false
            }
            else {
                lblOtherUserActivityStatus.isHidden = true
            }
        }
        
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "teacherChatTableCell", for: indexPath) as! TeacherChatTableCell
        
        cell.changesBasedOnUser(chatUserType:CHAT_USER_TYPE.RECEIVER.rawValue)
        
        //
        //        if chatMessages != nil{
        //
        //        let currentChatMessage = chatMessages[indexPath.row]
        //        let senderNickname = currentChatMessage["fromName"] as! String
        //        let message = currentChatMessage["message"] as! String
        //        let messageDate = currentChatMessage["timeStamp"] as! String
        //
        //        if senderNickname == nickname {
        //            cell.chatMessageLabel.textAlignment = NSTextAlignment.right
        //            cell.messageDetailsLabel.textAlignment = NSTextAlignment.right
        //
        //            cell.chatMessageLabel.textColor = lblNewsBanner.backgroundColor
        //            cell.chatMessageLabel.layer.cornerRadius = 10.0
        //        }
        //
        //        cell.chatMessageLabel.text = message
        //        cell.messageDetailsLabel.text = "by \(senderNickname.uppercased()) @ \(messageDate)"
        //        cell.chatMessageLabel.textColor = UIColor.darkGray
        //
        //      }
        return cell
    }
    
    // MARK: UITextViewDelegate Methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //   socket.sendStartTypingMessage(nickname)
        
        return true
    }
    
    // MARK: UIGestureRecognizerDelegate Methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: IBAction Methods
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        if(self.scoket.status == .connected) {
            print("socket connected")
            
            if tvMessageEditor.text.characters.count > 0 {
                
                let timeStampString = String(Date().timeStamp)
                print("tvMessageEditor.text : \(tvMessageEditor.text)")
                let parameters:Any = ["from": "CIV1T111", "to": "CIV1F111", "fromName": "Alvin","toName": "Test parent", "message": "my test message -  online status", "timeStamp": "\(timeStampString)"]
                print("parameters : \(parameters)")
                let newPara:Any = JSON(parameters)
                print("newPara  :\(newPara)")
                
                self.scoket.emit("new message", with: [parameters])
                chatMessages.append(parameters as! [String : AnyObject])
                
                tvMessageEditor.text = ""
                tvMessageEditor.resignFirstResponder()
            }
            else{
            }
        }
        else {
            print("socket not connected")
            if tvMessageEditor.text.characters.count > 0 {
                
                let timeStampString = String(Date().timeStamp)
                print("tvMessageEditor.text : \(tvMessageEditor.text)")
                let parameters:Any = ["from": "CIV1T111", "to": "CIV1F111", "fromName": "Alvin","toName": "Test parent", "message": "my test message -  offline status", "timeStamp": "\(timeStampString)"]
                
                print("parameters : \(parameters)")
                
                let newPara = JSON(parameters)
                
                self.scoket.emit("offline message", with: [parameters])
                chatMessages.append(parameters as! [String : AnyObject])
                
                tvMessageEditor.text = ""
                tvMessageEditor.resignFirstResponder()
            }
        }
        self.viewDidAppear(true)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
