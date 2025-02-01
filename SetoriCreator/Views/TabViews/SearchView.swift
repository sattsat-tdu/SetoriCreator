//
//  SearchView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/03
//  
//

import SwiftUI

struct SearchView: View {
    
    @StateObject private var viewModel = MusicSearchViewModel()
    @EnvironmentObject var chartVM: TopChartViewModel
    @FocusState var focus:Bool
    //曲の表示形式を指定
    let mode: Mode = .normal
    
    var body: some View {
        NavigationStack {
            VStack {
                
                searchBox.padding()
                
                List {
                    if let searchResponse = viewModel.searchResponse {
                        //フォーカスされていれば検索補完
                        if focus {
                            ForEach(searchResponse.suggestions, id: \.self) { suggestion in
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                    Text(suggestion.displayTerm)
                                        .font(.body)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                }
                                .onTapGesture {
                                    viewModel.searchTerm = suggestion.displayTerm
                                }
                            }
                            .listRowInsets(EdgeInsets())  //List内の余白を削除
                            .listRowBackground(Color.clear)
                            .padding(.horizontal)
                            .animation(.default, value: viewModel.searchResponse)
                        }
                        Section(header: Text("検索結果").fontWeight(.semibold)) {
                            
                            ForEach(searchResponse.topResults, id: \.self) { topResult in
                                switch topResult {
                                case .artist(let artist):
                                    ArtistCell(artist: artist, mode: self.mode)
                                case .song(let song):
                                    SongCell(song: song, mode: self.mode)
                                default:
                                    EmptyView()
                                }
                            }
                            .listRowInsets(EdgeInsets())  //List内の余白を削除
                        }
                        
                    }
                    Section(header: Text("おすすめアーティスト").fontWeight(.semibold)) {
                        if let topArtists = chartVM.topArtists {
                            ForEach(topArtists, id: \.self) { artist in
                                ArtistCell(artist: artist, mode: mode)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    
                    Section(header: Text("おすすめソング").fontWeight(.semibold)) {
                        if let topSongs = chartVM.topSongs {
                            ForEach(topSongs, id: \.self) { song in
                                SongCell(song: song, mode: .normal)
                                    .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
    }
}

//MARK: Views
extension SearchView {
    
    private var searchBox: some View {
        //検索表示
        HStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.gray)
            
            TextField("音楽を検索する...", text: $viewModel.searchTerm)
                .keyboardType(.default)
                .focused(self.$focus)
                .submitLabel(.search)
                .toolbar { //キーボードに閉じるボタンを付与
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()         // 右寄せにする
                        Button("閉じる") {
                            focus = false
                        }
                    }
                }
            
            if focus {
                Button(action: {
                    focus = false
                    viewModel.searchTerm = ""
                }, label: {
                    Text("キャンセル")
                        .foregroundStyle(.primary)
                })
            }
        }
        .padding(.vertical,10)
        .padding(.horizontal)
        .background(Color.primary.opacity(0.1))
        .clipShape(.rect(cornerRadius: 8))
    }
}

#Preview {
    SearchView()
}
