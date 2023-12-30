//
//  ProfileViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/27/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import _PhotosUI_SwiftUI


@Observable class ProfileViewViewModel {
    var selectedPhoto: PhotosPickerItem?
    var showingSearchFriendView = false
    var user: User?
    
    func fetchUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.user = User(id: data["id"] as? String ?? "",
                                  name: data["name"] as? String ?? "",
                                  email: data["email"] as? String ?? "",
                                  joined: data["joined"] as? TimeInterval ?? 0,
                                  profileImageId: data["profileImageId"] as? String ?? "",
                                  profileImage: data["profileImage"] as? String ?? "")
                print(self!.user ?? "no user")
            }
            
            
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func saveImage(user: inout User, image: UIImage) async -> Bool {
        let photoName = UUID().uuidString // This will be the name o the image file
        let storage = Storage.storage() // Create a Firebase Storage instance
        let storageRef = storage.reference().child("\(user.id)/\(photoName).jpeg")
        
        // Compress image
        guard let resizedImage = image.jpegData(compressionQuality: 0.0) else {
            print("Cound not resize image")
            return false
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
                return false
            }
        } catch {
            print("Cound not upload image to FirebaseStorage")
            return false
        }
        
        // Save imageURLString to user -> profileImage
        let db = Firestore.firestore()
        do {
            let document = db.collection("users").document(user.id)
            user.profileImage = imageURLString
            user.profileImageId = photoName
            try document.setData(from: user)
            try await document.updateData(["keywordsForLookup": user.keywordsForLookup])
            print("Data updated successfully!")
            return true
        } catch {
            print("Could not updata data in user for userId \(user.id)")
            return false
        }
    }
    
    func deleteOldImage() async {
        let userId = user!.id
        let imageId = user!.profileImageId
        let storage = Storage.storage() // Create a Firebase Storage instance
        let storageRef = storage.reference().child("\(userId)/\(imageId).jpeg")
        do {
            try await storageRef.delete()
            print("Successfully deleted Image")
        } catch {
            print("Could not delete Image \(error.localizedDescription)")
        }
    }
}
