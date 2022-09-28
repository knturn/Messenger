//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Kaan Turan on 20.09.2022.
//

import Foundation
import FirebaseAuth
import GoogleSignIn

final class ProfileViewModel {
    let currentUser = FirebaseAuth.Auth.auth().currentUser
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        do  {
        try FirebaseAuth.Auth.auth().signOut()
        }
        catch {
            print("Can't sign out")
        }
    }
    func downLoadURL(for path: String, completion: @escaping (URL?) -> Void ) {
        StorageManager.shared.downloadURL(for: path) { result in
            switch result {
            case (.success(let url)):
                completion(url)
            case (.failure(let error)):
                print(error)
            }
        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
    }
    
}
