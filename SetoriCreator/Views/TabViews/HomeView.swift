//
//  HomeView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI
import MusicKit

struct HomeView: View {
    
    
    @EnvironmentObject var chartVM: TopChartViewModel
    
    @State private var artist: Artist?
    @State private var checkSetListFlg = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 25) {
                    
                    NavigationLink {
                        ShowTopSongsView()
                            .environmentObject(chartVM)
                    } label: {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("トップソング 〉")
                                .font(.title2).bold()
                                .foregroundStyle(.primary)
                            
                            if let topSongs = chartVM.topSongs {
                                let top3Songs = Array(topSongs.items.prefix(3))
                                HStack(spacing: 20) {
                                    ForEach(Array(top3Songs.enumerated()), id: \.element.id) { index, song in
                                        LuxurySongCell(index: index + 1, song: song)
                                    }
                                }
                            } else {
                                HStack(spacing: 20) {
                                    ForEach(0..<3) { num in
                                        VStack {
                                            LoadingCell()
                                                .frame(width: 100,height: 100)
                                                .clipShape(.rect(cornerRadius: 5))
                                            LoadingCell()
                                                .frame(height: 30)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.gray.opacity(0.2), lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("クイック作成")
                            .font(.title2.bold())
                        Label("アーティストを選択するだけ！", systemImage: "checkmark")
                            .font(.footnote)
                        Label("カラオケで迷っているあなたに！", systemImage: "checkmark")
                            .font(.footnote)
                        Text("※セットリストは20曲で構成されます。")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        
                        NavigationLink {
                            SelectArtistView(artist: $artist)
                        } label: {
                            Text("セットリストを作成する")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(themeColor)
                                .clipShape(Capsule())
                                .padding(.top)
                        }
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .padding()
                    .background()
                    .clipShape(.rect(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.yellow, lineWidth: 2)
                    )
                    .onChange(of: artist) {
                        if artist != nil {
                            checkSetListFlg.toggle()
                        }
                    }
                    
                    //リンクへ飛ばす。
                    Link(destination: URL(string: "https://apps.apple.com/jp/developer/daisuke-ishii/id1609332032")!) {
                        HStack {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("こちらもおすすめ 〉")
                                    .font(.headline)
                                Text("sattsatはシンプルで使いやすい\nアプリを目指しています。")
                                    .font(.footnote)
                            }
                            Spacer()
                            Image("MyAppAdIMG")
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.black)
                    .frame(height: 80)
                    .padding()
                    .background(.teal)
                    .clipShape(.rect(cornerRadius: 8))
                }
                .padding()
                .fullScreenCover(isPresented: $checkSetListFlg) {
                    CheckSetoriView(artist: artist!,
                                    totalSongs: 20,
                                    name: "\(artist!.name)のセトリ",
                                    imageData: Data(),
                                    flg: $checkSetListFlg,
                                    parentflg: .constant(true))
                }
            }
            .background(CustomBackGround2())
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
            .navigationBarBackButtonHidden(true)    //左上邪魔だから消す
            .toolbar {
//                ToolbarItemGroup(placement: .automatic) {
//                    Spacer()
//                    Text("center")
//                    Spacer()
//                    Image(systemName: "plus")
//                }
                ToolbarItem(placement: .principal) {
                    Text("セットリスト\nクリエイター")
                        .font(.headline)
                        .minimumScaleFactor(0.1)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
