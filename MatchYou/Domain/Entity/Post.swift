//
//  Post.swift
//  MatchYou
//
//  Created by 김견 on 2/11/25.
//

import Foundation

public struct Post: Identifiable, Codable {
    let id: String
    let title: String
    let content: String
    let userId: String
    let imageUrl: String?
    let date: Date
}
