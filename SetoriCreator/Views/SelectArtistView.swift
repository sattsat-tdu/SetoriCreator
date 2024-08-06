//
//  SelectArtistView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/31
//
//

import SwiftUI
import MusicKit

struct SelectArtistView: View {
    
    @StateObject private var viewModel = MusicSearchViewModel()
    @StateObject private var chartVM = TopChartViewModel()
    @FocusState var focus:Bool
    @Binding var artist: Artist?
    // 3行表示に必要
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10), // スペースを設定
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    @Environment(\.presentationMode) private var presentationMode //View閉じるため
    
    var body: some View {
        VStack {
            Text("アーティストを選択してください。")
                .foregroundStyle(.secondary)
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray)
                
                TextField("アーティストを検索する...", text: $viewModel.searchTerm)
                    .keyboardType(.default)
                    .focused(self.$focus)
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
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            .padding()
            
            if let searchResponse = viewModel.searchResponse {
                //検索バーにフォーカスされ、かつ検索補完がロードできた場合
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
                        Divider()
                    }
                    .padding(.horizontal)
                    .animation(.default, value: viewModel.searchResponse)
                }
                
                ScrollView {
                    //Finderのように3行表示
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(searchResponse.topResults, id: \.self) { topResult in
                            if case let .artist(artist) = topResult {
                                VStack {
                                    if let artwork = artist.artwork {
                                        ArtworkImage(artwork,width: 60,height: 60)
                                            .clipShape(.rect(cornerRadius: 50))
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .frame(width: 60,height: 60)
                                    }
                                    Spacer()
                                    Text(artist.name)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                }
                                .onTapGesture {
                                    self.artist = artist
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                    .padding()
                }
                
            }
            List {
                Section(header: Text("おすすめアーティスト").fontWeight(.semibold)) {
                    if let topArtist = chartVM.topArtists {
                        ForEach(topArtist, id: \.self) { artist in
                            ArtistCell(artist: artist, mode: .none)
                                .onTapGesture {
                                    self.artist = artist
                                    presentationMode.wrappedValue.dismiss()
                                }
                                .listRowInsets(EdgeInsets())  //List内の余白を削除
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            
            Spacer()
        }
        .task {
            //トップアーティストを取得
            chartVM.getTopArtist()
        }
    }
}
