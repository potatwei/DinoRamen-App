//
//  LDRWidget.swift
//  LDRWidget
//
//  Created by Shihang Wei on 1/15/24.
//

import WidgetKit
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), status: Status(id: "", emoji: 1, comment: ""), image: UIImage(named: "DefaultImage"))
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(),
                                status: Status(id: "a",
                                               emoji: 2,
                                               comment: "Happy!"),
                                image: UIImage(named: "DefaultImage"))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        refreshUser()
        let currentDate = Date()
        
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        
        Task {
            await fetchStatus { status in
                var downloadedImage: UIImage?
                if let imageURL = status.image {
                    downloadedImage = await downloadImage(from: imageURL)
                }
                
                let entry = SimpleEntry(date: currentDate, status: status, image: downloadedImage)
                
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            
                completion(timeline)
                
                print(timeline)
            }
        }
    }
    
    func downloadImage(from url: String) async -> UIImage? {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return nil
        }
        do {
            let (imageData, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: imageData)
        } catch {
            print("Invalid data")
            return nil
        }
    }
    
    func fetchStatus(completion: @escaping (Status) async -> ()) async {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            await completion(Status(id: "", emoji: 0, comment: "Please Login"))
            return
        }
        let db = Firestore.firestore()
        var connectedId = "a"
        do {
            let document = try await db.document("users/\(currentUserId)/friend/connected").getDocument()
            if document.exists {
                if let data = document.data() {
                    for (id, _) in data {
                        connectedId = id
                    }
                    print("get connected user id Successfully")
                }
            } else {
                print("Connected document doesn't exist")
                await completion(Status(id: "", emoji: 0, comment: "Please connect to a friend"))
                return
            }
        } catch {
            print("Unable to update user id or fail to get document \(error)")
            await completion(Status(id: "", emoji: 0, comment: "Please connect to a friend first"))
            return
        }
        
        // Get connected user status
        do {
            let document = try await db.document("users/\(connectedId)/status/user_status").getDocument()
            if document.exists {
                let connUserStatus = try document.data(as: Status.self)
                await completion(connUserStatus)
                print("Updated userStatus Successfully")
            } else {
                print("user_status document doesn't exist")
                await completion(Status(id: "", emoji: 2, comment: "No Update from friend yet"))
            }
        } catch {
            print("Unable to update userStatus or fail to get document \(error)")
        }
    }
    
    func refreshUser() {
        do {
            let currentUser = Auth.auth().currentUser
            let sharedUser = try Auth.auth().getStoredUser(forAccessGroup: "\(TeamID).name.shihangwei.LDR")
            if sharedUser == nil {
                if currentUser != nil {
                    try Auth.auth().signOut()
                }
            } else if currentUser?.uid != sharedUser?.uid {
                updateUser(user: sharedUser!)
            }
        }
        catch {
            do {
                try Auth.auth().signOut()
            }
            catch {
                print("Error when trying to sign out: \(error.localizedDescription)")
            }
        }
    }
    
    func updateUser(user: User) {
        Auth.auth().updateCurrentUser(user) { error in
            if let error = error {
                print("Error when trying to update the user: \(error.localizedDescription)")
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let status: Status
    let image: UIImage?
}

struct LDRWidgetEntryView : View {
    @Environment(\.widgetContentMargins) var margins
    var entry: Provider.Entry
    let emojis = ["laugh","sweat","loveEye","loveHeart","largeCry","smallCry"]
    
    var body: some View {
        if entry.status.id != "" {
            if entry.image != nil {
                ZStack {
                    // fader
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .foregroundStyle(Gradient(colors: [.clear, Color.fader]))
                            .frame(maxHeight: 80)
                    }
                    
                    Group {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Image(emojis[entry.status.emoji])
                                    .resizable()
                                    .frame(width: 34, height: 34)
                                    .padding(1)
                                    .clipShape(Circle())
                                
                                Text(entry.status.comment)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .lineLimit(2)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(margins)
                }
                .background(Image(uiImage: entry.image!)
                .resizable()
                .scaledToFill())
            } else {
                VStack {
                    HStack {
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Image(emojis[entry.status.emoji])
                        .resizable()
                        .frame(width: 58, height: 58)
                        .padding(1)
                        .clipShape(Circle())
                    
                    Text(entry.status.comment)
                        .bold()
                        .font(.system(size: 18))
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding(margins)
                .background(Gradient(colors: [Color.backgroundUp, Color.backgroundDown]))
            }
        } else {
            ZStack {
                Rectangle().foregroundStyle(.clear)
                Text(entry.status.comment)
                    .bold()
                    .font(.system(size: 18))
                    .lineLimit(4)
            }
            .padding(margins)
            .background(Gradient(colors: [Color.backgroundDown, Color.backgroundUp]))
        }
    }
}

struct LDRWidget: Widget {
    let kind: String = "LDRWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LDRWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("Small Widget")
        .description("See live emojis and photos from your best friend on your Home Screen")
    }
}

#Preview(as: .systemSmall) {
    LDRWidget()
} timeline: {
//    SimpleEntry(date: .now,
//                status: Status(id: "",
//                               emoji: 2,
//                               comment: "Happy!",
//                               image: "https://firebasestorage.googleapis.com:443/v0/b/longdistanceconnection-28d62.appspot.com/o/sdMwJlQ6E1crDVY0oYQhfAg09fc2%2F00A0F8B8-0CED-439B-80B2-77ED9FDF6DFC.jpg?alt=media&token=d335b4c4-2782-4066-ade1-6410656934c7"),
//                image: UIImage(named: "DefaultImage"))
    SimpleEntry(date: .now,
                status: Status(id: "",
                               emoji: 2,
                               comment: "Happy!",
                               image: "https://firebasestorage.googleapis.com:443/v0/b/longdistanceconnection-28d62.appspot.com/o/sdMwJlQ6E1crDVY0oYQhfAg09fc2%2F00A0F8B8-0CED-439B-80B2-77ED9FDF6DFC.jpg?alt=media&token=d335b4c4-2782-4066-ade1-6410656934c7"),
                image: nil)
}
