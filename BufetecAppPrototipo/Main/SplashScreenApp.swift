//
//  SplashScreenApp.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/2/24.
//

import SwiftUI

@main
struct SplashScreenApp: App {
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.colorScheme, .dark)
        }
    }
}
