//
//  CustomPopup.swift
//  SetoriCreator
//  
//  Created by SATTSAT on 2024/08/16
//  
//

/*------------------------------------
 
 未完成、実行できず↓
 
 ------------------------------------*/

import SwiftUI
import UIKit

class CustomPopup {
    static let shared = CustomPopup()
    
    private var window: UIWindow?
    
    private init() {}
    
    func showAlert<Content: View>(@ViewBuilder content: () -> Content) {
        if let existingWindow = window {
            existingWindow.isHidden = true
            window = nil
        }
        
        print("Setting up UIHostingController")
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.backgroundColor = UIColor.clear  // 透明ではないか確認
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = hostingController
        newWindow.windowLevel = .alert + 1
        newWindow.backgroundColor = .clear

        // Auto Layout constraints for hostingController's view
        newWindow.addSubview(hostingController.view)
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: newWindow.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: newWindow.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: newWindow.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: newWindow.bottomAnchor)
        ])

        newWindow.makeKeyAndVisible()
        
        print("UIHostingController set and window made visible")
        window = newWindow
    }
    
    func hideAlert() {
        window?.isHidden = true
        window = nil
    }
}

class aaa {
    static func present(title: String, message: String) {
        CustomPopup.shared.showAlert {
            CustomPopupView(title: title, message: message, onDismiss: nil)
        }
    }

    static func presentWithDismissHandler(title: String, message: String,onDismiss: @escaping () -> Void) {
        CustomPopup.shared.showAlert {
            CustomPopupView(title: title, message: message, onDismiss: onDismiss)
        }
    }
}
