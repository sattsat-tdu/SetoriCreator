//
//  TopChartViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/02
//  
//

import MusicKit
import Combine

class TopChartViewModel: ObservableObject {
    @Published var topArtists: [Artist]?
    @Published var topSongs: MusicCatalogChart<Song>? = nil
    
    init() {
        Task {
            await getTopSongs()
        }
    }
    
    //人気曲を取得
    @MainActor
    private func getTopSongs() {
        Task {
            do {
                let request = MusicCatalogChartsRequest(
                    kinds: [.mostPlayed], // Use kinds that are relevant for song charts.
                    types: [Song.self]
                )
                let response = try await request.response()
                if let songChart = response.songCharts.first {
                    self.topSongs = songChart
                }
            } catch {
                print(error)
            }
        }
    }
    
    //TopSongから、上位6名のアーティストを抽出する関数
    @MainActor
    func getTopArtist(){
        Task {
            let request = MusicCatalogChartsRequest(
                kinds: [.mostPlayed],
                types: [Song.self]
            )
            do {
                let response = try await request.response()
                if let songChart = response.songCharts.first {
                    var artistNames: Set<String> = []
                    for song in songChart.items {
                        artistNames.insert(song.artistName)
                        if artistNames.count >= 6 {
                            break   //アーティスト数は6を超えたらforを終了
                        }
                    }
                    
                    // 取得したアーティスト名からアーティストを検索、格納
                    var fetchedArtists:[Artist] = []
                    for artistName in artistNames {
                        let searchRequest = MusicCatalogSearchRequest(term: artistName, types: [Artist.self])
                        let searchResponse = try await searchRequest.response()
                        
                        if let artist = searchResponse.artists.first {
                            fetchedArtists.append(artist)
                        }
                    }
                    self.topArtists = fetchedArtists
                }
            } catch {
                print("取得できませんでした")
            }
        }
    }
}
