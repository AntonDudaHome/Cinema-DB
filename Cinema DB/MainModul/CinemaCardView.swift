//
//  CinemaCardView.swift
//  Cinema DB
//
//  Created by Anton.Duda on 14.01.2024.
//

import SwiftUI

struct CinemaCardView: View {
    
    var cinemaData: Movie
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 16) {
                RemoteImage(urlString: "https://image.tmdb.org/t/p/w500\(cinemaData.posterPath)")
                    .aspectRatio(contentMode: .fit)
                
                Text(cinemaData.title)
                    .font(.custom("8bitOperatorPlus-Bold", size: 18))
                    .multilineTextAlignment(.center)
            }
            .padding(.all)
            .background {
                RoundedRectangle(cornerRadius: 24.0, style: .continuous)
                    .foregroundStyle(Color.gray)
            }
            
        }
    }
}

#Preview {
    CinemaCardView(cinemaData: Movie(movieID: 2, title: "", posterPath: ""))
}
