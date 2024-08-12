//
//  ShowTopSongsView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/08
//  
//

import SwiftUI

struct ShowTopSongsView: View {
    
    @EnvironmentObject var chartVM: TopChartViewModel
    
    var body: some View {
        List {
            
            ZStack {
                Image(systemName: "crown")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.yellow.opacity(0.5))
                    .scaleEffect(0.8)
                Rectangle()
                    .fill(
                        LinearGradient(colors: [
                            .backGround.opacity(0),
                            .backGround.opacity(1),
                        ], startPoint: .center, endPoint: .bottom)
                    )
                
            }
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)  //区切り線を非表示
            
            if let topSongs = chartVM.topSongs {
                ForEach(topSongs.items, id: \.self) { song in
                    SongCell(song: song, mode: .normal)
                }
                .listRowInsets(EdgeInsets())  //List内の余白を削除
                .listRowBackground(Color.clear)
            } else {
                ForEach(0 ..< 5) { index in
                    HStack {
                        Text("\(index + 1)")
                            .font(.headline)
                        Spacer()
                        LoadingCell()
                            .frame(width: 40, height: 40)
                            .clipShape(.rect(cornerRadius: 5))
                        LoadingCell()
                            .frame(maxWidth: .infinity)
                    }
                    .id(index)
                    .frame(height: 40)
                }
                .padding()
            }
        }
        .navigationTitle("トップソング")
        .scrollIndicators(.hidden)  //スクロールバーの削除
        .listStyle(.plain)  //List特有の余白を削除
        .background(Color("backGroundColor"))
    }
}

#Preview {
    ShowTopSongsView()
}
