//
//  erpApp.swift
//  erp
//
//  Created by rachit daksh on 11/07/26.
//

import SwiftUI

@main
struct erpApp: App {
    @State private var currentFlow: SplashNavigation = .loading
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch currentFlow {
                case .loading:
                    SplashView { targetFlow in
                        withAnimation {
                            self.currentFlow = targetFlow
                        }
                    }
                case .login:
                    LoginView { response in
                        withAnimation {
                            self.currentFlow = .dashboard(response)
                        }
                    }
                case .dashboard(let response):
                    MainShellView(loginResponse: response) {
                        // Logout closure
                        KeychainHelper.shared.clearAll()
                        withAnimation {
                            self.currentFlow = .login
                        }
                    }
                }
            }
        }
    }
}
