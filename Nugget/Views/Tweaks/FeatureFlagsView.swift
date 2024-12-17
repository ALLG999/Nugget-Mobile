//
//  FeatureFlagsView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct FeatureFlagsView: View {
    @StateObject var ffManager = FeatureFlagManager.shared
    
    struct FeatureFlagOption: Identifiable {
        var id = UUID()
        var label: String
        var flag: FeatureFlag
        var active: Bool = false
    }
    
    @State var featureFlagOptions: [FeatureFlagOption] = [
        .init(label: "切换锁屏时钟动画",
              flag: .init(id: 0, category: .SpringBoard, flags: ["Swift UI时间动画"])),
        .init(label: "切换复制锁屏按钮和锁屏快速开关",
              flag: .init(id: 1, category: .SpringBoard, flags: ["高速公路快速切换过渡", "滑动开关", "海报编辑Kashida"])),
        .init(label: "Enable Old Photo UI",
              flag: .init(id: 2, category: .Photos, flags: ["柠檬水"], is_list: false, inverted: true)),
        .init(label: "Enable Apple Intelligence",
              flag: .init(id: 3, category: .SpringBoard, flags: ["骨牌", "超级多米诺骨牌"]))
    ]
    
    var body: some View {
        List {
            // tweaks from list
            ForEach($featureFlagOptions) { tweak in
                Toggle(tweak.label.wrappedValue, isOn: tweak.active).onChange(of: tweak.active.wrappedValue, perform: { nv in
                    if nv {
                        ffManager.EnabledFlags.append(tweak.flag.wrappedValue)
                    } else {
                        for (i, flag) in ffManager.EnabledFlags.enumerated() {
                            if tweak.flag.wrappedValue.id == flag.id {
                                ffManager.EnabledFlags.remove(at: i)
                                return
                            }
                        }
                    }
                })
            }
        }
        .tweakToggle(for: .FeatureFlags)
        .navigationTitle("功能标记")
        .navigationViewStyle(.stack)
        .onAppear {
            // get the enabled feature flags
            // O(n^2), should be improved
            let enabledFlags = ffManager.EnabledFlags
            for (i, flagOption) in featureFlagOptions.enumerated() {
                for enabledFlag in enabledFlags {
                    if enabledFlag.id == flagOption.flag.id {
                        featureFlagOptions[i].active = true
                        break
                    }
                }
            }
        }
    }
}
