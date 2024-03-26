//
//  CryptoSwiftUIApp.swift
//  CryptoSwiftUI
//
//  Created by Влад  on 4.03.24.
//

import SwiftUI

@main
struct CryptoSwiftUIApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
