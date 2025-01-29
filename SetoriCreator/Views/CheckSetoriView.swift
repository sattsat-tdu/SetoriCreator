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
    
    @State private(set) var resultSongs: [Song]?
    
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
                            createArtistSetori()
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
                .onAppear(perform: createArtistSetori)
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
    
    //セットリスト生成関数
    private func createArtistSetori() {
        Task {
            let result = await MusicKitManager.shared.createSetori(
                artist: artist,
                count: totalSongs
            )
            switch result {
            case .success(let songs):
                resultSongs = songs
            case .failure(let error):
                print("[ERROR] \(error.rawValue)")
            }
        }
    }
    
}
