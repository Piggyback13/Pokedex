//
//  PokemonDetail.swift
//  Pokedex
//
//  Created by piggyback13 on 04.12.2022.
//

import Foundation

public struct PokemonDetail: Codable {
    let id: Int
    let name: String
    let image: URL
    let description: String
    
    public init(id: Int, name: String, image: URL, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
    }
}
