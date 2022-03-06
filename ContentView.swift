//
//  ContentView.swift
//  Movie Flix App
//
//  Created by narayan sharma on 28/01/22.
//

import SwiftUI

struct ContentView: View {
    @State private var results = [Results]()
    @State private var base_path = "https://image.tmdb.org/t/p/w342/"
    @State private var backdrop_path = "https://image.tmdb.org/t/p/original"
    var body: some View {
        List(results, id: \.id){ item in
            VStack(alignment: .leading) {
                if(item.vote_count < 7){
                    HStack {
                        AsyncImage(url: URL(string: base_path+item.poster_path!)){
                            Phase in
                            if let image = Phase.image{
                                image
                                    .resizable()
                                    .scaledToFit()
                            } else if Phase.error != nil {
                                Text("There was an error loading the image.")
                            } else {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading, spacing: 10){
                            Text(item.original_title)
                                .font(.largeTitle)
                            Text(item.overview!)
                                .font(.headline)
                        }
                        .padding()
                    }
                }else if (item.vote_count >= 7){
                    ZStack {
                        AsyncImage(url: URL(string: backdrop_path+item.backdrop_path!)){
                            Phase in
                            if let image = Phase.image{
                                image
                                    .resizable()
                                    .scaledToFit()
                                Image(systemName: "play.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 32)
                                    .shadow(radius: 4)
                            } else if Phase.error != nil {
                                Text("There was an error loading the image.")
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 342, height: 350)
                    }
                }
            }
        }
        .task {
            await loadData()
        }
    }
    func loadData() async {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        else
        {
            print("Invalid URL")
            return
        }
        do{
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Movie.self, from: data){
                results = decodedResponse.results
            }
        } catch {
            print("Invalid Data")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
