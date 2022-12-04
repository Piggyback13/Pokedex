//
//  PokedexList.swift
//  Pokedex
//
//  Created by piggyback13 on 17.10.2022.
//

import SwiftUI

public protocol PokedexService {
    func getPokedexes(callback: (Result<[PokedexModel], Error>) -> ())
}

public typealias PokedexDetailProvider<Details: View> = (Int, String) -> Details

extension PokedexList {
    class ViewModel<DetailsView: View>: ObservableObject {
        @Published var pokedexes: [PokedexModel]
        private let pokedexService: PokedexService
        let detailsProvider: PokedexDetailProvider<DetailsView>
        
        init(
            pokedexService: PokedexService,
            detailsProvider: @escaping PokedexDetailProvider<DetailsView>
        ) {
            self.pokedexes = []
            self.pokedexService = pokedexService
            self.detailsProvider = detailsProvider
        }
        
        func loadPokedex() {
            self.pokedexService.getPokedexes { [weak self] result in
                switch result {
                case .success(let pokedexes):
                    self?.pokedexes = pokedexes
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

public struct PokedexList<DetailsView: View>: View {
    @StateObject var viewModel: ViewModel<DetailsView>
    
    public init(
        pokedexService: PokedexService,
        pokedexDetailsProvider: @escaping PokedexDetailProvider<DetailsView>
    ) {
        self._viewModel = StateObject(
            wrappedValue: ViewModel(
                pokedexService: pokedexService,
                detailsProvider: pokedexDetailsProvider
            )
        )
    }
    
    public var body: some View {
        List(self.viewModel.pokedexes) { pokedex in
            NavigationLink(
                destination: {
                    self.viewModel.detailsProvider(pokedex.id, pokedex.name)
                },
                label: {
                    HStack {
                        Text(pokedex.name)
                        Spacer()
                        Text("\(pokedex.numberOfPokemon)")
                    }
                }
            )
        }
        .navigationTitle("Pokedex")
        .onAppear(perform: self.viewModel.loadPokedex)
    }
}

struct PokedexList_Previews: PreviewProvider {
    class MockedService: PokedexService {
        func getPokedexes(callback: (Result<[PokedexModel], Error>) -> ()) {
            callback(.success([
                .init(id: 1, name: "Kanto", numberOfPokemon: 151),
                .init(id: 2, name: "Johto", numberOfPokemon: 251)
            ]))
        }
    }
    
    static var previews: some View {
        PokedexList(
            pokedexService: MockedService()) { id, name in
                Text("Pokedex with id \(id)")
            }
    }
}
