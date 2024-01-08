//
//  UserEditViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation
import FirebaseStorage

@Observable class UserEditViewViewModel {

    init() {
        print("😁😁😁😁😁😁")
        Task {
            await fetchStatus()
        }
    }
    
    var userStatus = Status(id: "", emoji: 0, comment: "")
    var emojis = ["😁","😅","🥰","😣","😭","😋","🙃","🤪","😪","😵‍💫","🤢","🤒"]
    
    var emojiToDisplay: Int { return userStatus.emoji } // TODO: Change to String after assets setted up and delete the emojis array
    var photoToDisplay: String? { return userStatus.image }
    var commentToDisplay: String { return userStatus.comment }
    var commentEntered: String = ""
    var takenImage: UIImage?
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return "b"
        }
        return currentUserId
    }
    
    func changeEmoji(by value: Int) {
        userStatus.add(value)
        if emojiToDisplay < 0 {
            userStatus.add(emojis.count)
        }
        if emojiToDisplay > emojis.count - 1 {
            userStatus.add(-emojis.count)
        }
    }
    
    @MainActor
    func upload() async {
        // Updata Model
        userStatus.changeId(currentUserId)
        userStatus.changeComment(commentEntered)
        if takenImage != nil {
            await deleteOldImage()
            await saveImage(image: takenImage!) // Upload the photo and the model
        }
    }
    
    func fetchStatus() async {
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("users").document(currentUserId).collection("status").document("user_status").getDocument()
            if document.exists {
                userStatus = try document.data(as: Status.self)
            }
        } catch {
            print("Unable to update Status or fail to get document \(error)")
        }
        commentEntered = commentToDisplay
    }
    
    @MainActor
    func saveImage(image: UIImage) async {
        let photoName = UUID().uuidString // This will be the name of the image file
        let storage = Storage.storage() // Create a Firebase Storage instance
        let storageRef = storage.reference().child("\(currentUserId)/\(photoName).jpg")
        
        // Compress image
        guard let resizedImage = image.jpegData(compressionQuality: 0.5) else {
            print("Cound not resize image")
            return
        }
        
        // Setting metadata allows to see image in the web browser
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg" // jpg also works for png
        
        var imageURLString = ""
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("Image Saved")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // Will save to user -> profileImage
            } catch {
                print("Could not get imageURL \(error.localizedDescription)")
                return
            }
        } catch {
            print("Cound not upload image to FirebaseStorage")
            return
        }
        
        // Save imageURLString to user -> profileImage
        let db = Firestore.firestore()
        do {
            let document = db.document("users/\(currentUserId)/status/user_status")
            userStatus.image = imageURLString
            userStatus.imageId = photoName
            try document.setData(from: userStatus)
            print("Data updated successfully!")
            return
        } catch {
            print("Could not updata image in user_status for userId \(currentUserId)")
            return
        }
    }
    
    func deleteOldImage() async {
        let imageId = userStatus.imageId
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(currentUserId)/\(imageId ?? "").jpg")
        do {
            try await storageRef.delete()
            print("😆Successfully deleted Image")
        } catch {
            print("😡Could not delete Image \(error.localizedDescription)")
        }
    }
}
