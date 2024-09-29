//
//  CustomPopupView.swift
//  SetoriCreator
//
//  Created by SATTSAT on 2024/08/16
//
//


/*------------------------------------
 
 未完成、実行できず↓
 
 ------------------------------------*/

import SwiftUI

struct CustomPopupView: View {
    
    let title: String
    let message: String
    let onDismiss: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            Button("Dismiss") {
                onDismiss?()
                CustomPopup.shared.hideAlert()
            }
            .font(.headline)
            .foregroundColor(.primary)
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding()
        .background()
        .cornerRadius(12)
        .shadow(radius: 8)
        .padding()
    }
}

#Preview {
    CustomPopupView(title: "タイトル", message: "メッセージです", onDismiss: {})
}
