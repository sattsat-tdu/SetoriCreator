//
//  AddSetListView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30
//
//

import SwiftUI
import MusicKit
import PhotosUI

struct AddSetListView: View {
    @Binding var isShowing: Bool
    @StateObject private var viewModel = MusicSearchViewModel()
    @EnvironmentObject var cdc: CoreDataController
    @State private var isAuto = true
    //Viewflag
    @State private var selectArtistflg = false
    @State private var selectSongsflg = false
    @State private var createSetoriFlg = false
    //アーティスト選択
    @State private var selectedArtist: Artist? = nil
    //総曲数を取得
    @State private var totalSongs = 20
    //カスタム時の楽曲配列の保存
    @State private var songs: [Song] = []
    @State private var name = ""
    @State var selectedPhoto: PhotosPickerItem?
    @State var selectedImageData: Data?
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
            
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading, spacing: 25) {
                    Text("作成スタイル")
                        .font(.title2).bold()
                    
                    VStack {
                        Button(action: {
                            isAuto = true
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("おまかせ")
                                    .font(.headline)
                                Label("特定のアーティストで作成したい方！", systemImage: "checkmark")
                                    .font(.caption)
                                Label("今日何を歌うか迷っている方！", systemImage: "checkmark")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding()
                            .background()
                            .clipShape(.rect(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isAuto ? .orange : .gray.opacity(0.2), lineWidth: 2)
                            )
                        })
                        
                        Button(action: {
                            isAuto = false
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }, label: {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("カスタム")
                                    .font(.headline)
                                Label("カラオケの十八番を登録したい方！", systemImage: "checkmark")
                                    .font(.caption)
                                Label("様々なアーティストのセトリを作成したい方！", systemImage: "checkmark")
                                    .font(.caption)
                            }
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding()
                            .background()
                            .clipShape(.rect(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isAuto ? .gray.opacity(0.2) : .orange, lineWidth: 2)
                            )
                        })
                    }
                    .foregroundStyle(.primary)
                    HStack {
                        Text("詳細設定")
                            .font(.title2).bold()
                        Spacer()
                        //アイコンを選択させる
                        PhotosPicker(selection: $selectedPhoto,
                                     matching: .images,
                                     photoLibrary: .shared()
                        ) {
                            ZStack {
                                if let imageData = selectedImageData,
                                   let uiImage = UIImage(data: imageData){
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .frame(width: 60,height: 60)
                                } else {
                                    Rectangle()
                                        .foregroundStyle(.background)
                                        .frame(width: 60,height: 60)
                                        .clipShape(Circle())
                                    
                                }
                                Image(systemName: "photo")
                                    .opacity(0.7)
                            }
                            .overlay(
                                Circle()
                                    .stroke(selectedImageData == nil ? .gray.opacity(0.2) : .orange, lineWidth: 2)
                            )
                        }
                        .padding(.trailing)
                        .onChange(of: selectedPhoto) {
                            if let selectedImageData = selectedPhoto {
                                selectedImageData.loadTransferable(type: Data.self) { result in
                                    switch result {
                                    case .success(let data):
                                        if let data = data {
                                            self.selectedImageData = data
                                        }
                                    case .failure:
                                        return
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    TextField("セットリスト名を入力...", text: $name)
                        .padding()
                        .keyboardType(.default)
                        .frame(height: 50)
                        .background()
                        .clipShape(.rect(cornerRadius: 8))
                        .submitLabel(.done)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray.opacity(0.2), lineWidth: 2)
                        )
                    ////おまかせかカスタムでの詳細設定
                    VStack {
                        if isAuto {
                            //アーティストの選択
                            Button(action: {
                                selectArtistflg.toggle()
                            }, label: {
                                if let artist = selectedArtist {
                                    ArtistCell(
                                        artist: artist,
                                        mode: .none)
                                    .background()
                                    .clipShape(.rect(cornerRadius: 8))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.orange, lineWidth: 2)
                                    }
                                } else {
                                    HStack(spacing: 15) {
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                        Text("アーティストを選択")
                                            .font(.headline)
                                        Spacer()
                                        Text("〉")
                                            .font(.headline)
                                    }
                                    .frame(height: 50)
                                    .foregroundStyle(.primary)
                                    .padding()
                                    .background()
                                    .clipShape(.rect(cornerRadius: 8))
                                    .overlay{
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.gray.opacity(0.2), lineWidth: 2)
                                    }
                                }
                            })
                            .fullScreenCover(isPresented: $selectArtistflg) {
                                SelectArtistView(artist: $selectedArtist)
                                    .resignKeyboardOnDragGesture()
                                //↑ドラッグしたらfocusを閉じる
                            }
                            
                            HStack(spacing: 15) {
                                Text("収録曲数")
                                    .font(.headline)
                                Spacer()
                                
                                Button(action: {
                                    if totalSongs > 2 {
                                        totalSongs -= 1
                                    }
                                }, label: {
                                    Image(systemName: "minus.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                })
                                .foregroundStyle(totalSongs < 3 ? .gray : .orange)
                                .disabled(totalSongs < 3)
                                
                                Picker("",selection: $totalSongs) {
                                    ForEach(2..<51) { num in
                                        Text("\(num)")
                                            .tag(num)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.1)
                                    }
                                }
                                .frame(width: 80)
                                
                                Button(action: {
                                    if totalSongs < 50 {
                                        totalSongs += 1
                                    }
                                }, label: {
                                    Image(systemName: "plus.circle")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30)
                                })
                                .foregroundStyle(totalSongs > 49 ? .gray : .orange)
                                .disabled(totalSongs > 49)
                            }
                            .padding()
                            .background()
                            .clipShape(.rect(cornerRadius: 8))
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray.opacity(0.2), lineWidth: 2)
                            }
                        } else {
                            //セトリに2曲以上収録されていたら詳細表示
                            if songs.count >= 2 {
                                SongsListView(songs: $songs)
                                    .frame(height: 400)
                                    .background()
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(.orange, lineWidth: 2)
                                    }
                            }
                            //カスタム選択時のView
                            Button(action: {
                                selectSongsflg.toggle()
                            }, label: {
                                HStack(spacing: 15) {
                                    Image(systemName: "music.note.list")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                    Text("セットリストを構成")
                                        .font(.headline)
                                    Spacer()
                                    Text("〉")
                                        .font(.headline)
                                }
                                .frame(height: 50)
                                .foregroundStyle(.primary)
                                .padding()
                                .background()
                                .clipShape(.rect(cornerRadius: 8))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.gray.opacity(0.2), lineWidth: 2)
                                }
                            })
                            .fullScreenCover(isPresented: $selectSongsflg) {
                                SelectSongsView(songs: $songs)
                                    .resignKeyboardOnDragGesture()
                                //↑ドラッグしたらfocusを閉じる
                            }
                        }
                        
                        Button(action: {
                            createSetoriFlg = true
                        }, label: {
                            Label("作成する", systemImage: "list.triangle")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .padding()
                                .frame(maxWidth: .infinity,alignment: .center)
                                .background(.orange)
                                .clipShape(.rect(cornerRadius: 8))
                        })
                        .padding(.top)
                        .fullScreenCover(isPresented: $createSetoriFlg) {
                            CreateSetoriView(
                                artist: selectedArtist!,
                                totalSongs: totalSongs,
                                name: name,
                                imageData: selectedImageData ?? Data(),
                                flg: $createSetoriFlg,
                                parentflg: $isShowing
                            )
                        }
                    }
                    .animation(.spring(), value: isAuto)
                    .foregroundStyle(.primary)
                }
                .padding()
            }
        }
        .background(Color("backGroundColor"))
        
    }
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack {
            Button(action: {
                isShowing.toggle()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                
            })
            Spacer()
            Text("セットリストを作成")
                .font(.title2).bold()
            Spacer()
        }
        .padding()
        .foregroundStyle(.primary)
        .background()
        Divider()
    }
}

#Preview {
    AddSetListView(isShowing: .constant(true))
}
