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
                ForEach(movies) { data in
                    CinemaCardView(cinemaData: data)
                        .onAppear {
                            if let index = movies.firstIndex(where: { $0.id == data.id }), index == movies.count - 1 {
                                self.pageNumber += 1                                
                                getMovies(page: pageNumber)
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
            getMovies(page: pageNumber)
        }
    }
    
    func loadMoreContent(currentItem item: Movie){
        let thresholdIndex = self.movies.index(self.movies.endIndex, offsetBy: -1)
        if thresholdIndex == item.id, (pageNumber + 1) <= totalPages {
            pageNumber += 1
            getMovies(page: pageNumber)
        }
    }
    
    private func getMovies(page: Int) {
        movieAPI.fetchMovies(page: page) { data in
            totalPages = data.totalPage
            movies += data.results
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


extension ScrollView {
    func onScrolledToBottom(perform action: @escaping() -> Void) -> some View {
        return ScrollView<LazyVStack> {
            LazyVStack {
                self.content
                Rectangle().size(.zero).onAppear {
                    action()
                }
            }
        }
    }
}
