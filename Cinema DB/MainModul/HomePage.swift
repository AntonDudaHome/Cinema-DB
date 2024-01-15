//
//  HomePage.swift
//  Cinema DB
//
//  Created by Anton.Duda on 10.01.2024.
//

import SwiftUI
import Kingfisher

struct HomePage: View {
    
    @EnvironmentObject private var authManager: AuthManager
    @Environment(\.navigationRouter) private var router
    @StateObject private var movieAPI = API()
    @State private var isTheEnd: Bool = false
    @State var movies: [Movie] = []
    @State private var pageNumber: Int = 1
    @State private var totalPages: Int = 0
    
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(movies, id: \.id) { data in
                    Button {
                        router.push(destination: DetailsScreen(movie: data))
                    } label: {
                        CinemaCardView(cinemaData: data)
                            .onAppear {
                                if let index = movies.firstIndex(where: { $0.id == data.id }), index == movies.count - 1 {
                                    print("Index - \(index) movies count - \(movies.count) page - \(pageNumber)")
                                    self.pageNumber += 1
                                    getMovies(page: pageNumber)
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationTitle("Cinema DB")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    signOut()
                } label: {
                    Text("Sign Out")
                }
                .buttonStyle(.plain)
            }
        }
        .onAppear {
            if movies.isEmpty {
                getMovies(page: pageNumber)
            }
        }
    }
    
    private func getMovies(page: Int) {
        movieAPI.fetchMovies(page: page) { data in
            totalPages = data.totalPage
            movies.append(contentsOf: data.results)
        }
    }
    
    private func signOut() {
        Task {
            do {
                try await authManager.signOut()
                await MainActor.run {
                    router.push(destination: WelcomeView(), replaceStack: true)
                }
            }
            catch {
                print("Error: \(error)")
            }
        }
    }
}

struct RemoteImage: View {
    let urlString: String
    
    var body: some View {
        KFImage(URL(string: urlString))
            .resizable()
            .placeholder {
                Color.gray
            }
            .aspectRatio(contentMode: .fit)
            .cornerRadius(12, corners: .allCorners)
    }
}

#if DEBUG
#Preview {
    HomePage()
}
#endif
