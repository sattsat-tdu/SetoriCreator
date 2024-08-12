//
//  TimeLineView.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/07/30
//  
//

import SwiftUI

struct TimeLineView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("タイムライン")
                .font(.title2.bold())
            
            Text("セットリストを世界の人々と共有できるサービスです。\n今後のアップデートで追加予定")
                .font(.body)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .background(CustomBackGround())

    }
}

#Preview {
    TimeLineView()
}
