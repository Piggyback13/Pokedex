//
//  PokedexModel.swift
//  Pokedex
//
//  Created by piggyback13 on 17.10.2022.
//

import Foundation

public struct PokedexModel: Identifiable, Codable {
    public let id: Int
    var name: String
    let numberOfPokemon: Int
    
    public init(id: Int, name: String, numberOfPokemon: Int) {
        self.id = id
        self.name = name
        self.numberOfPokemon = numberOfPokemon
    }
}
