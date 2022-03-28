//
//  RegisterRequest.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import Foundation

struct RegisterRequest: Codable {
    let email: String
    let password: String
    let names: String
}
