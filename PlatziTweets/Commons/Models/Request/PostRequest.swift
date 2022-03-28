//
//  PostRequest.swift
//  PlatziTweets
//
//  Created by Jyferson Colina on 27/01/22.
//

import Foundation

struct PostRequest: Codable {
    let text: String
    let imageUrl: String?
    let videoUrl: String?
    let location: PostRequestLocation?
}
