//
//  HomeView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI
import MusicKit

struct HomeView: View {
    
    @State private var response2: MusicCatalogChartsResponse? = nil
    @State private var response: MusicCatalogChart<Song>? = nil
    
    var body: some View {
        VStack {
            if let response = response {
                ForEach(response.items) { song in
                    Text(song.title)
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backGroundColor"))
        .task {
            try? await testTopSong()
        }
    }
    
    @MainActor
    private func testTopSong() async throws {
        let request = MusicCatalogChartsRequest(
            kinds: [.mostPlayed], // Use kinds that are relevant for song charts.
            types: [Song.self]
        )
        let response = try await request.response()
        if let songChart = response.songCharts.first {
            self.response = songChart
        }
    }
}

#Preview {
    HomeView()
}
