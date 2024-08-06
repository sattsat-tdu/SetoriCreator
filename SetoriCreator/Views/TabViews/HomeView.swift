//
//  HomeView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/30.
//

import SwiftUI
import MusicKit
//import Algorithms

struct HomeView: View {

    
    @EnvironmentObject var chartVM: TopChartViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 10) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("トップソング 〉")
                            .font(.title3).bold()
                            .foregroundStyle(.secondary)
                        
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
                    .background(.background)
                    .clipShape(.rect(cornerRadius: 8))
                    .shadow(radius: 5)
                }
                .padding()
            }
            .background(Color("backGroundColor"))
        }
    }
}

#Preview {
    HomeView()
}
