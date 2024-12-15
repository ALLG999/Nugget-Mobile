//
//  ToolsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct ToolsView: View {
    @StateObject var applyHandler = ApplyHandler.shared
    
    struct GeneralOption: Identifiable {
        var id = UUID()
        var page: TweakPage
        var view: AnyView
        var title: String
        var imageName: String
        var minVersion: Version = Version(string: "1.0")
    }
    
    struct ToolCategory: Identifiable {
        var id = UUID()
        var title: String
        var pages: [GeneralOption]
    }
    
    @State var tools: [ToolCategory] = [
        .init(title: "Sparserestore Tweaks", pages: [
            .init(page: .MobileGestalt, view: AnyView(GestaltView()), title: NSLocalizedString("移动格式塔", comment: "Title of tool"), imageName: "platter.filled.top.and.arrow.up.iphone"),
            .init(page: .FeatureFlags, view: AnyView(FeatureFlagsView()), title: NSLocalizedString("功能标记", comment: "Title of tool"), imageName: "flag", minVersion: Version(string: "18.0")),
            .init(page: .Eligibility, view: AnyView(EligibilityView()), title: NSLocalizedString("合格", comment: "Title of tool"), imageName: "mappin", minVersion: Version(string: "18.1")/*Version(string: "17.4")*/),
            .init(page: .SpringBoard, view: AnyView(SpringboardTweaksView()), title: NSLocalizedString("跳板", comment: "Title of tool"), imageName: "app.badge"),
            .init(page: .Internal, view: AnyView(InternalOptionsView()), title: NSLocalizedString("内部选项", comment: "Title of tool"), imageName: "internaldrive")
        ]),
        .init(title: "域名恢复调整（需要跳过设置）", pages: [
            .init(page: .StatusBar, view: AnyView(StatusBarView()), title: NSLocalizedString("状态栏", comment: "Title of tool"), imageName: "wifi")
        ])
        
    ]
    
    let userVersion = Version(string: UIDevice.current.systemVersion)
    
    var body: some View {
        NavigationView {
            List {
                ForEach($tools) { category in
                    Section {
                        ForEach(category.pages) { option in
                            if option.minVersion.wrappedValue <= userVersion {
                                NavigationLink(destination: option.view.wrappedValue) {
                                    HStack {
                                        Image(systemName: option.imageName.wrappedValue)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.blue)
                                        Text(option.title.wrappedValue)
                                            .padding(.horizontal, 8)
                                        if applyHandler.isTweakEnabled(option.page.wrappedValue) {
                                            // show that it is enabled
                                            Spacer()
                                            Image(systemName: "checkmark.seal")
                                                .foregroundStyle(Color(.green))
                                        }
                                    }
                                }
                            }
                        }
                    } header: {
                        Text(category.title.wrappedValue)
                    }
                }
            }
            .navigationTitle("Tools")
        }
    }
}
