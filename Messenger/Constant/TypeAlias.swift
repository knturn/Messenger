//
//  TypeAlias.swift
//  Messenger
//
//  Created by Kaan Turan on 9.09.2022.
//
import UIKit.UIViewController
import MessageKit

typealias ConfigureTableView = UITableViewDelegate & UITableViewDataSource
typealias ConfigureMessageView = MessagesLayoutDelegate & MessagesDisplayDelegate & MessagesDataSource & MessageCellDelegate
typealias UploadPictureCompletion = (Result<String, Error> ) -> Void
typealias DownloadURLCompletion = (Result <URL, Error>) -> Void

