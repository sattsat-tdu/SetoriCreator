//
//  MusicSearchViewModel.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import MusicKit
import Combine

class MusicSearchViewModel: ObservableObject {
    
    //ViewModel版のState
    @Published var searchTerm = ""
    @Published var searchResponse: MusicCatalogSearchSuggestionsResponse?
    //監視用？
    private var searchTermObserver: AnyCancellable?
    
    //initで検索補完をする関数（requestSearchSuggestions)をsinkで紐付け、searchTermが変更されるごとに呼ばれるようにする。
    init() {
        searchTermObserver = $searchTerm
            .sink(receiveValue: requestSearchSuggestions)
    }
    
    
    //検索補完
    private func requestSearchSuggestions(for searchTerm: String) {
        if searchTerm.isEmpty {
            searchResponse = nil
        } else {
            Task {
                let searchSuggestionRequest = MusicCatalogSearchSuggestionsRequest(
                    term: searchTerm,
                    includingTopResultsOfTypes: [
                        Song.self,
                        Artist.self
                    ]
                )
                do {
                    let searchSuggestionResponse = try await searchSuggestionRequest.response()
                    await self.update(with: searchSuggestionResponse, for: searchTerm)
                } catch {
                    print("Failed to fetch search suggestions due to error: \(error)")
                }
            }
        }
    }
    
    @MainActor
    func update(with searchSuggestions: MusicCatalogSearchSuggestionsResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.searchResponse = searchSuggestions
        }
    }
}


