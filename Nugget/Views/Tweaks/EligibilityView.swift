//
//  EligibilityView.swift
//  Nugget
//
//  Created by lemin on 9/20/24.
//

import SwiftUI

struct EligibilityView: View {
    @StateObject var manager = EligibilityManager.shared
    
    @State var euEnabler: Bool = false
    
    @State var aiEnabler: Bool = false
    @State var changeDeviceModel: Bool = false
    
    var body: some View {
        List {
            // MARK: EU Enabler
//            Section {
//                Toggle(isOn: $euEnabler) {
//                    Text("启用欧盟侧载")
//                }.onChange(of: euEnabler) { nv in
//                    manager.euEnabler = nv
//                }
//            } header: {
//                Text("欧盟侧载")
//            }
            
            // MARK: AI Enabler
            if #available(iOS 18.1, *) {
                Section {
                    Toggle(isOn: $aiEnabler) {
                        HStack {
                            Text("启用苹果AI")
                            Spacer()
                            Button(action: {
                                showInfoAlert(NSLocalizedString("在不受支持的设备上启用Apple Intelligence。下载可能需要很长时间，请耐心检查[设置]->常规->iPhone/iPad存储->iOS->Apple Intelligence是否正在下载。\n\n如果不适用，请尝试重新应用。“，评论：”AI信息弹出窗口"))
                            }) {
                                Image(systemName: "info.circle")
                            }
                        }
                    }.onChange(of: aiEnabler) { nv in
                        manager.toggleAI(nv)
                    }
                    if aiEnabler {
                        Toggle(isOn: $changeDeviceModel) {
                            HStack {
                                Text("欺骗设备模型")
                                Spacer()
                                Button(action: {
                                    showInfoAlert(NSLocalizedString("将您的设备型号复制到iPhone 16（或iPad Pro M4），以便您下载AI型号。\n\n打开此选项可下载模型，然后关闭此选项并在下载模型后重新应用。\n\n注意：启用此选项时，会破坏Face ID。还原文件将修复此问题。”，注释：“设备型号更改器信息弹出窗口"))
                                }) {
                                    Image(systemName: "info.circle")
                                }
                            }
                        }.onChange(of: changeDeviceModel) { nv in
                            manager.setDeviceModelCode(nv)
                        }
                    }
                } header: {
                    Text("AI Enabler")
                }
            }
        }
        .tweakToggle(for: .Eligibility)
        .navigationTitle("Eligibility")
        .onAppear {
            euEnabler = manager.euEnabler
            aiEnabler = manager.aiEnabler
            changeDeviceModel = manager.spoofingDevice
        }
    }
    
    func showInfoAlert(_ body: String) {
        UIApplication.shared.alert(title: "Info", body: body)
    }
}
