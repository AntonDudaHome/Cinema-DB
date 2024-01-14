//
//  DetailsScreen.swift
//  Cinema DB
//
//  Created by Anton.Duda on 14.01.2024.
//

import SwiftUI

struct DetailsScreen: View {
    
    @Environment(\.navigationRouter) private var router
    @StateObject private var movieAPI = API()
    
    @State private var movieDetails: MovieDetails? = nil
    
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RemoteImage(urlString: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
                    .aspectRatio(contentMode: .fit)
                Text(movieDetails?.overview ?? "")
                Text("Rating: ")
                    .bold()
                +
                Text("\(movieDetails?.vote_average ?? 0)/10")
                    .font(.subheadline)
                Text("Release Date: ")
                    .bold()
                + Text("\(movieDetails?.release_date ?? "")")
                    .font(.subheadline)
                Text("Actors:")
                    .font(.subheadline)
                    .bold()
                if let cast = movieDetails?.credits.cast {
                    let actors = cast.map{$0.name}
                    
                    Text(actors.joined(separator: ", "))
                }
            }
            .padding(.horizontal, 24)
            
        }
        .navigationTitle(movie.title)
        .onAppear {
            movieAPI.fetchMovieDetails(with: movie.id) { data in
                self.movieDetails = data
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationControllerView {
        DetailsScreen(movie: Movie(id: 12, title: "Middle Here", posterPath: ""))
    }
}
#endif
