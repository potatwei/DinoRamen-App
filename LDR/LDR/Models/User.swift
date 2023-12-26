//
//  User.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation

struct User: Codable{
    let id: String
    let name: String
    let email: String
    let joined: TimeInterval
}
