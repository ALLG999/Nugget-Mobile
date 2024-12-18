//
//  ContentView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//  为了部落

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("首页", systemImage: "house")
                }
            ToolsView()
                .tabItem {
                    Label("工具箱", systemImage: "wrench.and.screwdriver.fill")
                }
        }
    }
}
