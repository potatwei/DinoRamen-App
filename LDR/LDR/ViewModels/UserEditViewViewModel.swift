//
//  UserEditViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

@Observable class UserEditViewViewModel {

    var userStatus = Status(id: "", emoji: 0, comment: "")
    var emojis = ["😁","😅","🥰","😣","😭","😋","🙃","🤪","😪","😵‍💫","🤢","🤒"]
    
    var emojiToDisplay: Int { return userStatus.emoji } // TODO: Change to String after assets setted up and delete the emojis array
    //var photoToDisplay = ""
    var commentToDisplay: String { return userStatus.comment }
    var commentEntered: String = ""
    
    func changeEmoji(by value: Int) {
        userStatus.add(value)
        if emojiToDisplay < 0 {
            userStatus.add(emojis.count)
        }
        if emojiToDisplay > emojis.count - 1 {
            userStatus.add(-emojis.count)
        }
    }
    
    func upload() {
        // Get User Id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        
        // Updata Model
        userStatus.changeId(uId)
        userStatus.changeComment(commentEntered)
        
        // Save Model
        let db = Firestore.firestore()
        do {
            try db.collection("users")
                .document(uId)
                .collection("status")
                .document("user_status")
                .setData(from: userStatus)
        } catch {
            
        }
    }
    
    func fetchStatus() {
        // Get User Id
        guard let uId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users")
            .document(uId)
            .collection("status")
            .document("user_status")
            .getDocument { [weak self] snapshot, error in
            // Check if get data and no error
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.userStatus = Status(id:  data["id"] as? String ?? "",
                                                 emoji: data["emoji"] as? Int ?? 0,
                                                 comment: data["comment"] as? String ?? "")
            }
        }
        commentEntered = commentToDisplay
    }
}
