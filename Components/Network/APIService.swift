//
//  APIService.swift
//  Cinema DB
//
//  Created by Anton.Duda on 11.01.2024.
//

import Foundation

enum NetworkEnvironment: String {
    case openWeather = "https://imdb-api.com/en/API"
    
    
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNDdhMmM1NTgyNjliZjk2ZjY3MjNhNWQzZWM2MTRkNiIsInN1YiI6IjY1YTA3MTNmOTY2NzBlMDEyNmFiYWIyZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.erkW8g7AYvG2iu1HfrEEeF3_h1ITntkGLsAwZTn5vrg"

    
    //'https://api.themoviedb.org/3/discover/movie?include_adult=false&include_video=false&language=en-US&page=1&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200'
}

@MainActor
class API: ObservableObject {
    
    static let apiKey = "b47a2c558269bf96f6723a5d3ec614d6"
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiNDdhMmM1NTgyNjliZjk2ZjY3MjNhNWQzZWM2MTRkNiIsInN1YiI6IjY1YTA3MTNmOTY2NzBlMDEyNmFiYWIyZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.erkW8g7AYvG2iu1HfrEEeF3_h1ITntkGLsAwZTn5vrg"

    
    func loadMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1?api_key=\(API.apiKey)")!
        Task {
            do {
                let (data, responce) = try await URLSession.shared.data(from: url)
             } catch {
                
            }
        }
    }
}


