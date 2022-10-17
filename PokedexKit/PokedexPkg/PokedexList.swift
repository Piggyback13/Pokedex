//
//  PokedexList.swift
//  Pokedex
//
//  Created by piggyback13 on 17.10.2022.
//

import SwiftUI

extension PokedexList {
    class ViewModel: ObservableObject {
        @Published var pokedexes: [PokedexModel]
        private let pokedexService: PokedexService
        
        init(pokedexService: PokedexService) {
            self.pokedexes = []
            self.pokedexService = pokedexService
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

public protocol PokedexService {
    func getPokedexes(callback: (Result<[PokedexModel], Error>) -> ())
}

public struct PokedexList: View {
    
    @StateObject var viewModel: ViewModel = ViewModel()
    
    public init() {}
    
    public var body: some View {
        Text("Hello, World!")
    }
}

struct PokedexList_Previews: PreviewProvider {
    static var previews: some View {
        PokedexList()
    }
}
