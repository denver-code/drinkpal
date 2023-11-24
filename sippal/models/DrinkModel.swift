//
//  Drink.swift
//  sippal
//
//  Created by Admin on 24/11/2023.
//

import Foundation

struct Drink: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var isFavourite: Bool
    var count: Int
}

