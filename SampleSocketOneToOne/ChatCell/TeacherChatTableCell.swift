//
//  TeacherChatTableCell.swift
//  SampleSockerIOChat
//
//  Created by apple on 31/08/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TeacherChatTableCell: UITableViewCell {
    
    @IBOutlet weak var chatMessageView: UIView!
    @IBOutlet weak var chatMessageLabel: UILabel!
    @IBOutlet weak var messageDetailsLabel: UILabel!

    override func draw(_ rect: CGRect) {
       
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customizeChatMessageView()
    }
    
    func changesBasedOnUser(chatUserType:String){
        
        switch chatUserType {
        case CHAT_USER_TYPE.SENDER.rawValue:
            chatMessageView.backgroundColor = UIColor(rgb: 0x38BAA4)
           // chatMessageView.addLeftTriangle(colour:UIColor(rgb: 0xC0C0C0))
        case CHAT_USER_TYPE.RECEIVER.rawValue:
            chatMessageView.backgroundColor = UIColor(rgb: 0xE06579)
            
        default:
            break
        }
    }
    func customizeChatMessageView()
    {
        chatMessageView.setCardView(view: chatMessageView)
        chatMessageView.layer.cornerRadius = 5
        chatMessageView.layer.masksToBounds = true
        chatMessageView.addRightTriangle(colour:UIColor.red)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
