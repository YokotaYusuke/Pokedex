import SwiftUI

struct Pokemon: Decodable {
    let name: String
}

struct PokemonResponse: Decodable {
    let results: [Pokemon]
}

struct ContentView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        List(viewModel.pokemons, id: \.name) { pokemon in
            Text(pokemon.name)
        }
    }
}

extension ContentView {
    class ViewModel: ObservableObject {
        @Published var pokemons = [Pokemon]()
        
        init(pokemonRepository: PokemonRepository = DefaultPokemonRepository()) {
            Task {
                self.pokemons = await pokemonRepository.getPokemons()
            }
        }
    }
}

protocol PokemonRepository {
    func getPokemons() async -> [Pokemon]
}

class DefaultPokemonRepository: PokemonRepository {
    let http: Http
    
    init(http: Http = URLSession.shared) {
        self.http = http
    }
    
    func getPokemons() async -> [Pokemon] {
        let request = URLRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon")!)
        do {
            let (data, _) = try await http.data(for: request)
            let pokemonResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
            return pokemonResponse.results
        } catch {
            return []
        }
    }
}

protocol Http {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Http {}

class DummyHttp: Http {
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (Data(), URLResponse())
    }
}

#Preview {
    ContentView(viewModel: .init())
}
