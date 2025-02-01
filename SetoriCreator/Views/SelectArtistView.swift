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
    @FocusState var focus: Bool
    @Binding var artist: Artist?
    @Environment(\.presentationMode) private var presentationMode
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 10), // スペースを設定
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            if !focus {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                        
                    })
                    Spacer()
                    Text("アーティストを選択してください。")
                        .foregroundStyle(.secondary)
                    Spacer()
                }
                .padding()
                .background()
                Divider()
            }
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray)
                
                TextField("アーティストを検索する...", text: $viewModel.searchTerm)
                    .keyboardType(.default)
                    .focused(self.$focus)
                    .submitLabel(.search)  // ここで「検索」ボタンを表示するように指定
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("閉じる") {
                                withAnimation {
                                    focus = false
                                }
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
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(Color.primary.opacity(0.05))
            .cornerRadius(8)
            .padding()
            
            List {
                if let searchResponse = viewModel.searchResponse {
                    // 検索バーにフォーカスされ、かつ検索補完がロードできた場合
                    if focus {
                        ForEach(searchResponse.suggestions, id: \.self) { suggestion in
                            HStack {
                                Image(systemName: "magnifyingglass")
                                Text(suggestion.displayTerm)
                                    .font(.body)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .onTapGesture {
                                viewModel.searchTerm = suggestion.displayTerm
                            }
                        }
                        .animation(.default, value: viewModel.searchResponse)
                    }
                    
                    // Finderのように3列表示
                    Section(header: Text("検索結果").fontWeight(.semibold)) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(searchResponse.topResults, id: \.self) { topResult in
                                if case let .artist(artist) = topResult {
                                    VStack {
                                        if let artwork = artist.artwork {
                                            ArtworkImage(artwork, width: 60, height: 60)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .frame(width: 60, height: 60)
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
                        .padding(.vertical)
                    }
                }
                
                Section(header: Text("おすすめアーティスト").fontWeight(.semibold)) {
                    if let topArtist = chartVM.topArtists {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(topArtist, id: \.self) { artist in
                                VStack {
                                    if let artwork = artist.artwork {
                                        ArtworkImage(artwork, width: 60, height: 60)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.circle.fill")
                                            .frame(width: 60, height: 60)
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
                }
            }
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)  //スクロールバーの削除
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.3), value: focus)
        .navigationBarBackButtonHidden(true)
    }
}
