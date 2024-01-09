//
//  OwnsInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation


struct Status: Codable {
    var id: String
    var emoji: Int // TODO: change to string after asset setted up
    var comment: String
    var image: String?
    var imageId: String?
    var reaction: String = ""
}
