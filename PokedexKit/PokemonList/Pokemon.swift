//
//  Pokemon.swift
//  Pokedex
//
//  Created by piggyback13 on 02.12.2022.
//

import Foundation

public struct Pokemon: Identifiable, Codable {
    public let id: Int
    let name: String
    let sprite: URL
    
    public init(id: Int, name: String, sprite: URL) {
        self.id = id
        self.name = name
        self.sprite = sprite
    }
}
