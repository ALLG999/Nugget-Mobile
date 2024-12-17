//
//  GestaltView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

struct GestaltView: View {
    let gestaltManager = MobileGestaltManager.shared
    let userVersion = Version(string: UIDevice.current.systemVersion)
    
    struct GestaltTweak: Identifiable {
        var id = UUID()
        var label: String
        var keys: [String]
        var values: [Any] = [1]
        var active: Bool = false
        var minVersion: Version = Version(string: "1.0")
    }
    
    struct GestaltSection: Identifiable {
        var id = UUID()
        var tweaks: [GestaltTweak]
    }
    
    struct DeviceSubType: Identifiable {
        var id = UUID()
        var key: Int
        var title: String
        var minVersion: Version = Version(string: "16.0")
    }
    
    @State private var CurrentSubType: Int = -1
    @State private var CurrentSubTypeDisplay: String = "Default"
    
    @State private var modifyResolution: Bool = false
    private let resMode: Int = MobileGestaltManager.shared.getRdarFixMode()
    private let resTitle: String = MobileGestaltManager.shared.getRdarFixTitle()
    
    @State private var deviceModelChanged: Bool = false
    @State private var deviceModelName: String = ""
    
    // list of device subtype options
    @State var deviceSubTypes: [DeviceSubType] = [
        .init(key: -1, title: NSLocalizedString("默认", comment: "默认设备类型")),
        .init(key: 2436, title: NSLocalizedString("iPhone X 手势", comment: "x 手势")),
        .init(key: 2556, title: NSLocalizedString("iPhone 14 Pro 灵动岛", comment: "iPhone 14 Pro SubType")),
        .init(key: 2796, title: NSLocalizedString("iPhone 14 Pro Max 灵动岛", comment: "iPhone 14 Pro Max SubType")),
        .init(key: 2976, title: NSLocalizedString("iPhone 15 Pro Max 灵动岛", comment: "iPhone 15 Pro Max SubType"), minVersion: Version(string: "17.0")),
        .init(key: 2622, title: NSLocalizedString("iPhone 16 Pro 灵动岛", comment: "iPhone 16 Pro SubType"), minVersion: Version(string: "18.0")),
        .init(key: 2868, title: NSLocalizedString("iPhone 16 Pro Max 灵动岛", comment: "iPhone 16 Pro Max SubType"), minVersion: Version(string: "18.0"))
    ]
    
    // list of mobile gestalt tweaks
    @State var gestaltTweaks: [GestaltSection] = [
        .init(tweaks: [
            .init(label: "启用开机铃声", keys: ["QHxt+hGLaBPbQJbXiUJX3w"]),
            .init(label: "启用充电限制", keys: ["37NVydb//GP/GrhuTN+exg"]),
            .init(label: "启用碰撞 SOS", keys: ["HCzWusHQwZDea6nNhaKndw"]),
            .init(label: "启用点击唤醒 (iPhone SE)", keys: ["yZf3GTRMGTuwSV/lD7Cagw"]),
            .init(label: "启用 iPhone 16 相机按钮设置", keys: ["CwvKxM2cEogD3p+HYgaW0Q", "oOV1jhJbdV3AddkcCg0AEA"], values: [1, 1], minVersion: Version(string: "18.0")),
            .init(label: "禁用壁纸视差", keys: ["UIParallaxCapability"], values: [0])
        ]),
        .init(tweaks: [
            .init(label: "启用舞台经理支持（警告：在某些设备上存在风险，主要是手机）", keys: ["qeaj75wk3HF4DwQ8qbIi7g"], values: [1]),
            .init(label: "启用美杜莎（iPad 多任务）（警告：在手机上使用可能有风险）", keys: ["mG0AnH/Vy1veoqoLRAIgTA", "UCG5MkVahJxG1YULbbd5Bg", "ZYqko/XM5zD3XBfN5RmaXA", "nVh/gwNpy7Jv1NOk00CMrw", "uKc7FPnEO++lVhHWHFlGbQ"], values: [1, 1, 1, 1, 1]),
            .init(label: "允许 iPhone 上的 iPad 应用", keys: ["9MZ5AdH43csAUajl/dU+IQ"], values: [[1, 2]]),
            .init(label: "禁用区域限制（例如快门声音）", keys: ["h63QSdBCiT/z0WU6rdQv6Q", "zHeENZu+wbg7PUprwNwBWg"], values: ["US", "LL/A"]),
            .init(label: "启用苹果笔", keys: ["yhHcB0iH0d1XzPO/CFd3ow"]),
            .init(label: "切换操作按钮", keys: ["cT44WE1EohiwRzhsZ8xEsw"])
        ]),
        .init(tweaks: [
            .init(label: "切换内部存储（警告：对某些设备有风险，主要是 iPad）", keys: ["LBJfwOEzExRxzlAnSuI7eg"]),
            .init(label: "设置为 Apple 内部安装（即任何应用程序中的 Metal HUD）", keys: ["EqrsVvjcYDdxHBiQmGhAWw"]),
            .init(label: "始终显示", keys: ["2OOJf1VhaM7NxfRok3HbWQ", "j8/Omm6s1lsmTDFsXjsBfA"], values: [1, 1], minVersion: Version(string: "18.0"))
        ])
    ]
    
    var body: some View {
        List {
            Section {
                // device subtype
                HStack {
                    Image(systemName: "ipodtouch")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                    
                    
                    Text("Gestures / Dynamic Island")
                        .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    Button(CurrentSubTypeDisplay, action: {
                        showSubTypeChangerPopup()
                    })
                    .foregroundColor(.blue)
                    .padding(.leading, 10)
                }
                
                // rdar fix (change resolution)
                if resMode > 0 {
                    Toggle("\(resTitle) (modifies resolution)", isOn: $modifyResolution).onChange(of: modifyResolution, perform: { nv in
                        if nv {
                            gestaltManager.setGestaltValue(key: "IOMobileGraphicsFamily", value: resMode)
                        } else {
                            gestaltManager.setGestaltValue(key: "IOMobileGraphicsFamily", value: 0)
                        }
                    })
                }
                
                // device model name
                VStack {
                    Toggle("Change Device Model Name", isOn: $deviceModelChanged).onChange(of: deviceModelChanged, perform: { nv in
                        if nv {
                            if deviceModelName != "" {
                                gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
                            }
                        } else {
                            gestaltManager.removeGestaltValue(key: "ArtworkDeviceProductDescription")
                        }
                    })
                    TextField("Device Model Name", text: $deviceModelName).onChange(of: deviceModelName, perform: { nv in
                        if deviceModelChanged {
                            gestaltManager.setGestaltValue(key: "ArtworkDeviceProductDescription", value: deviceModelName)
                        }
                    })
                }
            }
            // tweaks from list
            ForEach($gestaltTweaks) { category in
                Section {
                    ForEach(category.tweaks) { tweak in
                        if userVersion >= tweak.minVersion.wrappedValue {
                            Toggle(tweak.label.wrappedValue, isOn: tweak.active).onChange(of: tweak.active.wrappedValue, perform: { nv in
                                if nv {
                                    gestaltManager.setGestaltValues(keys: tweak.keys.wrappedValue, values: tweak.values.wrappedValue)
                                } else {
                                    gestaltManager.removeGestaltValues(keys: tweak.keys.wrappedValue)
                                }
                            })
                        }
                    }
                }
            }
        }
        .tweakToggle(for: .MobileGestalt)
        .navigationTitle("Mobile Gestalt")
        .navigationViewStyle(.stack)
        .onAppear {
            // get the base device subtype
            for (i, deviceSubType) in deviceSubTypes.enumerated() {
                if deviceSubType.key == -1 {
                    deviceSubTypes[i].key = gestaltManager.deviceSubType
                    break
                }
            }
            // load enabled gestalt tweaks
            let enabledTweaks = gestaltManager.getEnabledTweaks()
            // first, the dynamic island
            if let subtype = enabledTweaks["ArtworkDeviceSubType"] as? Int {
                CurrentSubType = subtype
                for deviceSubType in deviceSubTypes {
                    if deviceSubType.key == subtype {
                        CurrentSubTypeDisplay = deviceSubType.title
                        break
                    }
                }
            }
            // second, the resolution
            if let resChange = enabledTweaks["IOMobileGraphicsFamily"] as? Bool {
                modifyResolution = resChange
            }
            // next, the device model name
            if let modelName = enabledTweaks["ArtworkDeviceProductDescription"] as? String {
                deviceModelName = modelName
                deviceModelChanged = true
            }
            // finally, do the other values
            for (i, category) in gestaltTweaks.enumerated() {
                for (j, gestaltTweak) in category.tweaks.enumerated() {
                    if gestaltTweak.keys.count > 0 && enabledTweaks[gestaltTweak.keys[0]] != nil {
                        gestaltTweaks[i].tweaks[j].active = true
                    }
                }
            }
        }
    }
    
    func showSubTypeChangerPopup() {
        // create and configure alert controller
        let alert = UIAlertController(title: NSLocalizedString("Choose a device subtype", comment: ""), message: "", preferredStyle: .actionSheet)
        
        // create the actions
        
        for type in deviceSubTypes {
            if userVersion >= type.minVersion {
                let newAction = UIAlertAction(title: type.title + " (" + String(type.key) + ")", style: .default) { (action) in
                    // apply the type
                    gestaltManager.setGestaltValue(key: "ArtworkDeviceSubType", value: type.key)
                    CurrentSubType = type.key
                    CurrentSubTypeDisplay = type.title
                }
                if CurrentSubType == type.key {
                    // add a check mark
                    newAction.setValue(true, forKey: "checked")
                }
                alert.addAction(newAction)
            }
        }
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { (action) in
            // cancels the action
        }
        
        // add the actions
        alert.addAction(cancelAction)
        
        let view: UIView = UIApplication.shared.windows.first!.rootViewController!.view
        // present popover for iPads
        alert.popoverPresentationController?.sourceView = view // prevents crashing on iPads
        alert.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.maxY, width: 0, height: 0) // show up at center bottom on iPads
        
        // present the alert
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
    }
}
