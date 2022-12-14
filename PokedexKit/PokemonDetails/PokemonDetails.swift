//
//  PokemonDetails.swift
//  Pokedex
//
//  Created by piggyback13 on 04.12.2022.
//

import SwiftUI

public protocol PokemonDetailsService {
    func getPokemons(id: Int) async throws -> PokemonDetail
}

extension PokemonDetails {
    class ViewModel: ObservableObject {
        @Published var pokemon: PokemonDetail?
        
        let pokemonId: Int
        let pokemonName: String
        let pokemonService: PokemonDetailsService
        
        init(
            pokemonId: Int,
            pokemonName: String,
            pokemonService: PokemonDetailsService
        ) {
            self.pokemonId = pokemonId
            self.pokemonName = pokemonName
            self.pokemonService = pokemonService
        }
        
        func loadPokemon() {
            Task {
                do {
                    let pokemon = try await self.pokemonService.getPokemons(id: self.pokemonId)
                    await self.setPokemon(pokemon)
                } catch {
                    print(error)
                }
            }
        }
        
        @MainActor
        func setPokemon(_ pokemon: PokemonDetail) {
            self.pokemon = pokemon
        }
    }
}

struct PokemonDetails: View {
    @StateObject var viewModel: ViewModel
    
    public init(
        pokemonId: Int,
        pokemonName: String,
        pokemonService: PokemonDetailsService
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                pokemonId: pokemonId,
                pokemonName: pokemonName,
                pokemonService: pokemonService
            )
        )
    }
    
    public var body: some View {
        VStack {
            AsyncImage(url: self.viewModel.pokemon?.image) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .padding([.leading, .trailing], 24)
            
            Text(self.viewModel.pokemon?.description ?? "")
            Spacer()
        }
        .navigationTitle(self.viewModel.pokemonName)
        .onAppear(perform: self.viewModel.loadPokemon)
    }
}

struct PokemonDetails_Previews: PreviewProvider {
    struct MockedService: PokemonDetailsService {
        func getPokemons(id: Int) async throws -> PokemonDetail {
            return .init(
                id: id,
                name: "Bulbasaur",
                image: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!,
                description: "A strange seed was planted on its back at birth. The plant sprouts and grows with this POK??MON.")
        }
    }
    
    static var previews: some View {
        PokemonDetails(
            pokemonId: 1,
            pokemonName: "Bulbasaur",
            pokemonService: MockedService()
        )
    }
}
