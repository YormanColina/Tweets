//
//  LoginReponse.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import Foundation

struct LoginResponse: Codable {
    let user: User
    let token: String
}
