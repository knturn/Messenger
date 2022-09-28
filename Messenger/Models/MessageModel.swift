//
//  MessageModel.swift
//  Messenger
//
//  Created by Kaan Turan on 26.09.2022.
//

import Foundation
import MessageKit

    struct Message: MessageType {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
    }
    struct Sender: SenderType {
        var photoURL: String
        var senderId: String
        var displayName: String
    }


