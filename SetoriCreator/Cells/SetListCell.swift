//
//  SetListCell.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/05
//
//

import SwiftUI
import MusicKit

struct SetListCell: View {
    
    let setList: SetList
    @EnvironmentObject var viewModel: SetListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            StackImage(imageType: viewModel.imageType, size: 100)
            
            Spacer()
            Text(setList.name ?? "フォルダ名がnilです")
                .font(.callout)
                .fontWeight(.semibold)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.primary)
        }
    }
}

#Preview {
    let context = CoreDataController.shared.saveContext
    let testSetList = SetList(context: context)
    testSetList.name = "テストセットリスト"
    testSetList.image = UIImage(named: "testArtist")?.pngData()
    testSetList.songsid = ["", ""] as NSObject
    return SetListCell(setList: testSetList)
        .frame(width: 100, height: 100)
        .environment(\.managedObjectContext, context)
}
