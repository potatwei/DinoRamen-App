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
    var emojis = ["laugh","sweat","loveEye","loveHeart","largeCry","smallCry"]
    
    var takenImage: UIImage?
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return "b"
        }
        return currentUserId
    }
    
    @MainActor
    func upload(_ status: Status, comment: String) async -> Status {
        var status = status
        // Updata Model
        status.id = currentUserId
        status.comment = comment
        if takenImage != nil {
            await deleteOldImage(status.imageId ?? "a")
            let imageInfo = await saveImage(image: takenImage!, status: status) // Upload the photo
            if let imageInfo = imageInfo {
                status.image = imageInfo.0
                status.imageId = imageInfo.1
            }
        } else { // when no photo is taken update environment's image as nil
            await deleteOldImage(status.imageId ?? "a")
            status.image = nil
            status.imageId = nil
        }
        
        // upload status
        let db = Firestore.firestore()
        do {
            let document = db.document("users/\(currentUserId)/status/user_status")
            try document.setData(from: status)
            print("Data updated successfully!")
            return status
        } catch {
            print("Could not update image in user_status for userId \(currentUserId)")
            return status
        }
    }
    
    @MainActor
    func saveImage(image: UIImage, status: Status) async -> (String, String)? {
        let photoName = UUID().uuidString // This will be the name of the image file
        let storage = Storage.storage() // Create a Firebase Storage instance
        let storageRef = storage.reference().child("\(currentUserId)/\(photoName).jpg")
        
        // Compress image
        guard let resizedImage = image.jpegData(compressionQuality: 0.5) else {
            print("Cound not resize image")
            return nil
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
                return (imageURLString, photoName)
            } catch {
                print("Could not get imageURL \(error.localizedDescription)")
                return nil
            }
        } catch {
            print("Cound not upload image to FirebaseStorage")
            return nil
        }
    }
    
    func deleteOldImage(_ imageId: String) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(currentUserId)/\(imageId).jpg")
        do {
            try await storageRef.delete()
            print("😆Successfully deleted Image")
        } catch {
            print("😡Could not delete Image \(error.localizedDescription)")
        }
    }
}
