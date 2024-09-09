//
//  NewsView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/7/24.
//

import SwiftUI

struct NewsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showingScrolledTitle = false
    @State private var selectedIndex = 0
    @State private var showingSettings = false
    private let numberOfTabs = 5
    
    private func scrollDetector(topInsets: CGFloat) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let isUnderToolbar = minY - topInsets < 0
            Color.clear
                .onChange(of: isUnderToolbar) { oldVal, newVal in
                    showingScrolledTitle = newVal
                }
        }
    }
    
    var body: some View {
        GeometryReader { outer in
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        NewsHeaderView(showingScrolledTitle: $showingScrolledTitle)
                        
                        NewsTabView(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                        
                        PageIndicator(numberOfTabs: numberOfTabs, selectedIndex: $selectedIndex)
                    }
                    .padding(.bottom, 20)
                }
                .background(Color("btBackground"))
                .toolbar {
                    CustomToolbar(showingScrolledTitle: $showingScrolledTitle, showingSettings: $showingSettings)
                }
                .navigationTitle("Noticias")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color("btBackground"))
                .sheet(isPresented: $showingSettings) {
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    NewsView()
        .environment(AppearanceManager())
}
