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
                VStack(spacing: 16) {
                    
                    topSongBox
                    
                    quickCreateBox
                        .onChange(of: artist) {
                            if artist != nil {
                                checkSetListFlg.toggle()
                            }
                        }
                    myAdBox
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
            .background(.mainBackground)
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
    
    private var topSongBox: some View {
        NavigationLink {
            ShowTopSongsView()
                .environmentObject(chartVM)
        } label: {
            VStack(alignment: .leading, spacing: 16) {
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
            .shadow(color: .black.opacity(0.1), radius: 3)
        }
        .buttonStyle(.plain)
    }
    
    private var quickCreateBox: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("クイック作成")
                .font(.title2.bold())
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                    Text("アーティストを選択するだけ")
                        .font(.footnote)
                }
                HStack {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                    Text("カラオケの選曲で迷っているあなたへ")
                        .font(.footnote)
                }
                Text("※セットリストは20曲で構成されます。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            
            NavigationLink {
                SelectArtistView(artist: $artist)
            } label: {
                Text("セットリストを作成する")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(themeColor)
                    .clipShape(Capsule())
                    .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding()
        .background(.item)
        .clipShape(.rect(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 3)
    }
    
    private var myAdBox: some View {
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
        .frame(height: 80)
        .padding()
        .background(.item)
        .clipShape(.rect(cornerRadius: 8))
        .shadow(color: .black.opacity(0.1), radius: 3)
    }
}

#Preview {
    HomeView()
}
