//
//  PlayMusicViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/16
//  
//

import MusicKit
import Combine

final class PlayMusicViewModel: ObservableObject {
    
    static let shared = PlayMusicViewModel()
    @Published var isSubscribe = false
    @Published var isPlaying = false
    var playbackStateObserver: AnyCancellable?
    
    @MainActor
    func onAppear() {
        checkUserState()    //契約状況を確認
    }
    
    //再生状態の監視
    private var musicPlayer: ApplicationMusicPlayer {
        let musicPlayer = ApplicationMusicPlayer.shared
        if playbackStateObserver == nil {
            playbackStateObserver = musicPlayer.state.objectWillChange
                .sink { [weak self] in
                    self?.handlePlaybackStateDidChange()
                }
        }
        return musicPlayer
    }
    
    @MainActor
    private func checkUserState() {
        Task {
            for await subscription in MusicSubscription.subscriptionUpdates {
                isSubscribe = subscription.canPlayCatalogContent
                print(isSubscribe)
            }
        }
    }
    
    private var isPlaybackQueueInitialized = false
    private var playbackQueueInitializationItemID: MusicItemID?
    
    func togglePlaybackStatus(for song: Song) {
        if !isPlaying {
            let isPlaybackQueueInitializedForSpecifiedSong = isPlaybackQueueInitialized && (playbackQueueInitializationItemID == song.id)
            if !isPlaybackQueueInitializedForSpecifiedSong {
                let musicPlayer = self.musicPlayer
                setQueue(for: [song])
                isPlaybackQueueInitialized = true
                playbackQueueInitializationItemID = song.id
                Task {
                    do {
                        try await musicPlayer.play()
                    } catch {
                        print("Failed to prepare music player to play \(song).")
                    }
                }
            } else {
                Task {
                    try? await musicPlayer.play()
                }
            }
        } else {
            musicPlayer.pause()
        }
    }

    private func setQueue(for songs: [Song], startingAt startSong: Song? = nil) {
        ApplicationMusicPlayer.shared.queue = ApplicationMusicPlayer.Queue(for: songs, startingAt: startSong)
    }
    
    private func handlePlaybackStateDidChange() {
        isPlaying = (musicPlayer.state.playbackStatus == .playing)
    }
}
