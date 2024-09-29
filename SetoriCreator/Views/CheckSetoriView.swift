//
//  CreateSetoriView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/01
//
//現在はおまかせを押した時のみ対応

import SwiftUI
import MusicKit

struct CheckSetoriView: View {
    
    @EnvironmentObject var cdc: CoreDataController
    
    let artist: Artist
    let totalSongs: Int
    let name: String
    let imageData: Data
    @Binding var flg: Bool
    @Binding var parentflg: Bool
    @State private var isShowCheckAlert = false //警告表示
    
    @State private var resultSongs: [Song]?
    
    var body: some View {
        NavigationStack {
            if let songs = resultSongs {
                List {
                    Section(header: Text(name).font(.title2.bold())) {
                        ForEach(songs.indices, id: \.self) {index in
                            HStack {
                                Text("\(index + 1)")
                                    .font(.headline)
                                Spacer()
                                SongCell(song: songs[index], mode: .none)
                            }
                            .id(songs[index].id)
                            .listRowInsets(EdgeInsets())  //List内の余白を削除
                            .listRowBackground(Color.clear)
                        }
                        .onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                }
                .background(Color("backGroundColor"))
                .scrollIndicators(.hidden)  //スクロールの表示を消す
                .scrollContentBackground(.hidden)
                .navigationTitle("生成結果")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction){
                        Button(action: {
                            isShowCheckAlert.toggle()
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                        })
                        .alert("警告", isPresented: $isShowCheckAlert) {
                            Button("削除", role: .destructive) {
                                flg.toggle()
                            }
                        } message: {
                            Text("現在のセットリストが破棄されますが、よろしいですか？")
                        }
                    }
                    //編集ボタン、右上に
                    ToolbarItem(placement: .confirmationAction){
                        EditButton()
                    }
                    
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button(action: {
                            resultSongs = nil
                            Task {
                                await createSetori(artist: artist, totalSongs: totalSongs)
                            }
                        }, label: {
                            Text("再生成")
                                .font(.headline)
                                .foregroundStyle(.red)
                        })
                        .frame(height: 40)
                        Button(action: {
                            if let songs = resultSongs{
                                let songIDs = songs.map { $0.id.rawValue } // Songのidを抽出
                                cdc.createSetList(
                                    name: name,
                                    image: imageData,
                                    artistID: artist.id.rawValue,
                                    songIDs: songIDs
                                )
                                //親ビューを消してからこのViewも消す
                                parentflg = false
                                flg = false
                            }
                            
                        }, label: {
                            Text("保存する")
                                .font(.headline)
                        })
                    }
                }
            } else {
                ZStack {
                    LoadingCell()
                    Text("セットリストを生成中...")
                        .font(.title2.bold())
                        .foregroundStyle(.secondary)
                }
                .edgesIgnoringSafeArea(.all)
                .task {
                    await createSetori(artist: artist, totalSongs: totalSongs)
                }
            }
        }
        
    }
    
    //並び替え
    private func move(from source: IndexSet, to destination: Int) {
        resultSongs!.move(fromOffsets: source, toOffset: destination)
    }
    
    //削除
    private func delete(at offsets: IndexSet) {
        resultSongs!.remove(atOffsets: offsets)
    }
    
    @MainActor  //totalSongs分セトリを作成
    private func createSetori(artist: Artist, totalSongs: Int) async {
        do {
            //アルバム情報を取得
            let updatedArtist = try await artist.with([.albums])
            if let albums = updatedArtist.albums {
                var allSongsDict: [String: Song] = [:]
                for album in albums {
                    //アルバムからトラック情報を取得
                    let updatedAlnum = try await album.with([.tracks])
                    if let tracks = updatedAlnum.tracks {
                        for track in tracks {
                            if case .song(let song) = track {
                                allSongsDict[song.title] = song
                            }
                        }
                    }
                }
                let randomSongs = allSongsDict.values.shuffled().prefix(totalSongs)
                self.resultSongs = Array(randomSongs)
            }
        } catch {
            print("Failed to load top songs: \(error)")
        }
    }
}

//#Preview {
//    CreateSetoriView(flg: .constant(true), parentflg: .constant(true))
//}
