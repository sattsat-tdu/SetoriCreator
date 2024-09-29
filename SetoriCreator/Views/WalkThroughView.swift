//
//  WalkThroughView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/11
//
//

import SwiftUI

struct WalkThroughView: View {
    
    let walkthroughImage = ["WalkThrough1",
                            "WalkThrough2",
                            "WalkThrough3",
                            "WalkThrough4",
                            "WalkThrough5"
    ]
    @AppStorage("isFirstLaunch") var isFirstLaunch = true
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                ForEach(walkthroughImage.indices, id: \.self) { index in
                    Image(walkthroughImage[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
                
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(.default, value: currentPage)
            
            Button(action: {
                if currentPage == walkthroughImage.count - 1 {
                    isFirstLaunch = false
                } else {
                    currentPage += 1
                }
            }, label: {
                Text(currentPage == walkthroughImage.count - 1 ? "始める" : "次へ")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 50)
                    .background(themeColor)
                    .clipShape(Capsule())
                    .padding()
            })
        }
//        .edgesIgnoringSafeArea(.all)
        .background(.white)
    }
}


#Preview {
    WalkThroughView()
}
