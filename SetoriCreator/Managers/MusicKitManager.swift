//
//  MusicKitManager.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2025/01/28
//
//

import Foundation
import MusicKit

enum MusicKitError: String, Error {
    case networkError
    case fetchAlbumsFailed
    case fetchTopSongsFailed
    case unknownError
}

@MainActor
final class MusicKitManager {
    static let shared = MusicKitManager()
    
    private init() {}
    
    //アーティストのセットリストを生成
    func createSetori(artist: Artist, count: Int = 20) async -> Result<[Song], MusicKitError> {
        var songs = [Song]()
        
        do {
            let updatedArtist = try await artist.with([.albums])
            guard let albums = updatedArtist.albums else {
                print("No albums found for the artist.")
                return .failure(.fetchAlbumsFailed)
            }
            
            songs = await withTaskGroup(of: [Song].self) { group in
                var collectedSongs: [Song] = []
                for album in albums {
                    group.addTask {
                        await self.fetchSongsFromAlbum(album: album)
                    }
                }
                
                for await albumSongs in group {
                    collectedSongs.append(contentsOf: albumSongs)
                }
                
                return collectedSongs
            }
            
            let limitedSongs = songs.shuffled().prefix(count)
            return .success(Array(limitedSongs))
        } catch {
            print("[ERROR] アーティストのアルバム取得に失敗しました")
            return .failure(.fetchAlbumsFailed)
        }
    }
    
    //アルバムの中のSong一覧を取得
    private func fetchSongsFromAlbum(album: Album) async -> [Song] {
        do {
            let albumWithTracks = try await album.with([.tracks])
            guard let tracks = albumWithTracks.tracks else {
                print("[ERROR] tracksの取得に失敗しました")
                return []
            }
            
            //trackの曲部分のみ取得
            return tracks.compactMap { track in
                if case .song(let song) = track {
                    return song
                }
                return nil
            }
        } catch {
            print("[ERROR] アルバムの曲取得に失敗しました")
            return []
        }
    }
    
    //idから曲を取得
    func fetchSong(songId: String) async -> Song? {
        do {
            let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(songId))
            let response = try await request.response()
            return response.items.first
        } catch {
            print("[ERROR] 曲の取得に失敗しました。id: \(songId)")
            return nil
        }
    }
    
    //idからArtistを取得
    func fetchArtist(artistId: String) async -> Artist? {
        do {
            let request = MusicCatalogResourceRequest<Artist>( matching: \.id, equalTo: MusicItemID(rawValue: artistId))
            let response = try await request.response()
            return response.items.first
        } catch {
            print("[ERROR] Artistの取得に失敗しました。id: \(artistId)")
            return nil
        }
    }
    
    //トップソングを取得
    func fetchTopSongs(limit: Int = 20) async -> Result<[Song], MusicKitError> {
        do {
            var request = MusicCatalogChartsRequest(
                kinds: [.mostPlayed],
                types: [Song.self]
            )
            request.limit = limit
            let response = try await request.response()
            
            guard let songsChart = response.songCharts.first else {
                print("[ERROR] トップソングチャートが見つかりません")
                return .failure(.unknownError)
            }
            
            return .success(Array(songsChart.items))
        } catch {
            print("[ERROR] TopSongの取得に失敗しました")
            return .failure(.fetchTopSongsFailed)
        }
    }
    
    //曲からアーティストを取得
    func songToArtist(_ song: Song) async -> Artist? {
        do {
            let songWithArtist = try await song.with([.artists])
            guard let artists = songWithArtist.artists else {
                print("[ERROR] fetch failed artists from \(song.title)")
                return nil
            }
            return artists.first
        } catch {
            print("[ERROR] \(song.title)のアーティスト情報の取得に失敗")
            return nil
        }
    }
}

