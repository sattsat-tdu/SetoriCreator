//
//  HomeView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI
import MusicKit
//import Algorithms

struct HomeView: View {

    
    @State private var response: MusicCatalogChart<Song>? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("トップソング 〉")
                            .font(.title3).bold()
                            .foregroundStyle(.secondary)
                        
                        if let response = response {
//                            HStack(spacing: 20) {
//                                ForEach(response.items) { song in
//                                    luxurySong(song: song)
//                                }
//                            }
                            //index情報が必要だったため下記を使用
                            HStack(spacing: 20) {
                                ForEach(Array(response.items.enumerated()), id: \.element) { index, song in
                                    LuxurySongCell(index: index + 1, song: song)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(.background)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(radius: 5)
                }
                .padding()
            }
            .background(Color("backGroundColor"))

            .task {
                //View表示時に非同期処理？
                try? await getTop3Songs()
            }
        }
    }
    
    @MainActor
    private func getTop3Songs() async throws {
        var request = MusicCatalogChartsRequest(
            kinds: [.mostPlayed], // Use kinds that are relevant for song charts.
            types: [Song.self]
        )
        
        //Top3の3曲しか必要ないのでlimit指定
        request.limit = 3
        let response = try await request.response()
        if let songChart = response.songCharts.first {
            self.response = songChart
        }
    }
}

#Preview {
    HomeView()
}
