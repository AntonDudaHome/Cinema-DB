//
//  APIService.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import Foundation
import Logger

enum NetworkEnvironment: String {
    case openWeather = "https://imdb-api.com/en/API"
}

@MainActor
class API: ObservableObject {
    
    private let baseUrl = "https://api.themoviedb.org/3"
    
    func fetchMovies(page: Int, completion: @escaping (TMDBResponse) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String else {
            print("TMDB API Key missing")
            return
        }
        
        let url = URL(string: "\(baseUrl)/movie/popular?api_key=\(apiKey)&page=\(page)")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TMDBResponse.self, from: data)
                    completion(response)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
    func fetchMovieDetails(with id: Int, completion: @escaping(MovieDetails) -> Void)  {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String else {
            print("TMDB API Key missing")
            return
        }
        //
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&append_to_response=credits")!
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    let movieDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                    completion(movieDetails)
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}


struct Movie: Codable, Identifiable, Hashable {
    let id: Int
    let title: String
    let posterPath: String
   
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}

struct TMDBResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPage: Int
    let tottalResult: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPage = "total_pages"
        case tottalResult = "total_results"
    }
}

struct MovieDetails: Decodable {
    let overview: String
    let vote_average: Double
    let release_date: String
    let credits: Credits
    // Add more properties as needed
    
    enum CodingKeys: String, CodingKey {
        case overview
        case vote_average
        case release_date
        case credits
    }
}
struct Credits: Decodable {
    let cast: [Cast]
}
struct Cast: Decodable, Identifiable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
