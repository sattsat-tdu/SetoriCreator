//
//  ArtistCell.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/07/31
//
//

import SwiftUI
import MusicKit

struct ArtistCell: View {
    
    let artist: Artist
    let mode: Mode
    @EnvironmentObject var setListVM: SelectSongViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            if let artwork = artist.artwork {
                ArtworkImage(artwork, width: 60)
                    .clipShape(.rect(cornerRadius: 50))
            } else {
                Circle()
                    .fill(.secondary)
                    .frame(width: 60)
            }
            
            Text(artist.name)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
            Spacer()
            
            switch mode {
            case .none:
                Spacer()
            case .normal:
                NavigationLink(destination: ArtistDetailView(artist: artist, mode: mode)) {
                    EmptyView()
                }
            case .plus:
                NavigationLink(destination: ArtistDetailView(artist: artist, mode: mode)
                    .environmentObject(setListVM)
                ) {
                    EmptyView()
                }
            }
        }
        .frame(height: 40)
        .foregroundStyle(.primary)
        .padding()
    }
}
