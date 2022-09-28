//
//  StorageManager.swift
//  Messenger
//
//  Created by Kaan Turan on 22.09.2022.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    public func uploadProfilePic (with data : Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metaData, error in
            guard error == nil else{
                print("failed to upload pictures")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("failed to get downloadUrl")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("download url returned: \(url)")
                completion(.success(urlString))
                
            }
            
        }
    }
    public func downloadURL(for path: String, completion: @escaping DownloadURLCompletion) {
        let reference = storage.child(path)
        reference.downloadURL { url, error  in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
    
}
public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadUrl
}
