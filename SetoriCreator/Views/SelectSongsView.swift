//
//  SelectSongsView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/01
//
//

import SwiftUI
import MusicKit

struct SelectSongsView: View {
    
    @StateObject private var viewModel = MusicSearchViewModel()
    @StateObject private var chartVM = TopChartViewModel()
    @FocusState var focus:Bool
    let mode: Mode = .plus
    
    @Binding var songs: [Song]
    //セットリストの管理に使用
    @StateObject private var setListVM = SetListViewModel()
    @Environment(\.presentationMode) private var presentationMode //View閉じるため
    //フラグ変数
    @State private var songsListflg = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.gray)
                    
                    TextField("音楽を検索する...", text: $viewModel.searchTerm)
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
                    
                    List {
                        Section(header: Text("検索結果").fontWeight(.semibold)) {
                            
                            ForEach(searchResponse.topResults, id: \.self) { topResult in
                                switch topResult {
                                case .artist(let artist):
                                    ArtistCell(
                                        artist: artist,
                                        mode: mode)
                                    .environmentObject(setListVM)
                                case .song(let song):
                                    SongCell(song: song,mode: mode)
                                        .environmentObject(setListVM)
                                default:
                                    EmptyView()
                                }
                            }
                            .listRowInsets(EdgeInsets())  //List内の余白を削除
                            .listRowBackground(Color.clear)
                            
                        }
                        
                        Section(header: Text("おすすめアーティスト").fontWeight(.semibold)) {
                            if let topArtists = chartVM.topArtists {
                                ForEach(topArtists, id: \.self) { artist in
                                    ArtistCell(
                                        artist: artist,
                                        mode: mode)
                                    .environmentObject(setListVM)
                                        .listRowInsets(EdgeInsets())
                                }
                            }

                        }
                    }
                    .scrollContentBackground(.hidden)
                    .padding(-15)
                    
                }
                Spacer()
                
                if !focus {
                    HStack(spacing: 20) {
                        
                        Button(action: {
                            self.songs = setListVM.songs
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("閉じる")
                                .font(.headline)
                                .foregroundStyle(.primary)
                                .padding()
                                .frame(maxWidth: .infinity,alignment: .center)
                                .background()
                                .clipShape(.rect(cornerRadius: 8))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                                }
                        })
                        Button(action: {
                            songsListflg.toggle()
                        }, label: {
                            ZStack(alignment: .topTrailing) {
                                Label("セトリを確認", systemImage: "music.note.list")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .padding()
                                    .frame(maxWidth: .infinity,alignment: .center)
                                    .background(.orange)
                                    .clipShape(.rect(cornerRadius: 8))
                                
                                Text("\(setListVM.songs.count)")
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .background(.red)
                                    .clipShape(Circle())
                                    .padding(.top, -15)
                            }

                        })
                        .sheet (isPresented: $songsListflg){
                            SongsListView(songs: $setListVM.songs)
                                .presentationDetents([.medium])
                        }
                    }
                }
            }
            .padding()
            .background(Color("backGroundColor"))
            .onAppear {
                chartVM.getTopArtist()
                setListVM.initSetList(songs: self.songs)
            }
        }

    }
}

#Preview {
    SelectSongsView(songs: .constant([]))
}
