//
//  HomeView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    private let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    
    @State var showRevertPage = false
    @State var showPairingFileImporter = false
    @State var showErrorAlert = false
    @State var lastError: String?
    @State var path = NavigationPath()
    
    // Prefs
    @AppStorage("AutoReboot") var autoReboot: Bool = true
    @AppStorage("PairingFile") var pairingFile: String?
    @AppStorage("SkipSetup") var skipSetup: Bool = true
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                // MARK: App Version
                Section {
                    
                } header: {
                    Label("Version \(Bundle.main.releaseVersionNumber ?? "UNKNOWN") (\(Int(buildNumber) != 0 ? "beta \(buildNumber)" : NSLocalizedString("发布", comment:"")))", systemImage: "信息")
                }
                .listStyle(InsetGroupedListStyle())
                
                // MARK: Tweak Options
                Section {
                    VStack {
                        // apply all tweaks button
                        HStack {
                            Button("应用调整") {
                                applyChanges(reverting: false)
                            }
                            .buttonStyle(TintedButton(color: .blue, fullwidth: true))
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("通知", comment: "info header"), body: NSLocalizedString("应用所有选定的调整。", comment: "应用调整信息"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                        // remove all tweaks button
                        HStack {
                            Button("删除所有调整") {
                                showRevertPage.toggle()
                            }
                            .buttonStyle(TintedButton(color: .red, fullwidth: true))
                            .sheet(isPresented: $showRevertPage, content: {
                                RevertTweaksPopoverView(revertFunction: applyChanges(reverting:))
                            })
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("通知", comment: "info header"), body: NSLocalizedString("删除并恢复所有调整，包括移动格式塔", comment: "删除调整信息"))
                            } label: {
                                Image(systemName: "info")
                            }
                            .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                        }
                        // select pairing file button
                        if !ApplyHandler.shared.trollstore {
                                if pairingFile == nil {
                                HStack {
                                    Button("选择配对文件") {
                                        showPairingFileImporter.toggle()
                                    }
                                    .buttonStyle(TintedButton(color: .green, fullwidth: true))
                                    Button {
                                        UIApplication.shared.helpAlert(title: NSLocalizedString("通知", comment: "info header"), body: NSLocalizedString("选择配对文件以恢复设备。可以从 AltStore 或 SideStore 等应用获取。点击“帮助”获取更多信息。", comment: "配对文件选择器信息"), link: "https://docs.sidestore.io/docs/getting-started/pairing-file")
                                    } label: {
                                        Image(systemName: "info")
                                    }
                                    .buttonStyle(TintedButton(material: .systemMaterial, fullwidth: false))
                                }
                            } else {
                                Button("重置配对文件") {
                                    pairingFile = nil
                                }
                                .buttonStyle(TintedButton(color: .green, fullwidth: true))
                            }
                        }
                    }
                    .listRowInsets(EdgeInsets())
                    // auto reboot option
                    HStack {
                        Toggle(isOn: $autoReboot) {
                            Text("应用后自动重启")
                                .minimumScaleFactor(0.5)
                        }
                    }
                    // skip setup
                    Toggle(isOn: $skipSetup) {
                        HStack {
                            Text("传统跳过设置")
                                .minimumScaleFactor(0.5)
                            Spacer()
                            Button {
                                UIApplication.shared.alert(title: NSLocalizedString("通知", comment: "info header"), body: NSLocalizedString("应用Cowabunga Lite的Skip Setup方法跳过非漏洞利用文件的设置。\n\n这可能会给某些人带来问题，因此如果您使用配置文件，请将其关闭。\n\n如果您只应用漏洞利用文件，则不会应用此方法，因为它将使用SparseRestore方法跳过安装。", comment: "跳过设置信息"))
                            } label: {
                                Image(systemName: "info.circle")
                            }
                            .padding(.horizontal)
                        }
                    }
                } header: {
                    Label("调整选项", systemImage: "hammer")
                }
                .listStyle(InsetGroupedListStyle())
                .listRowInsets(EdgeInsets())
                .padding()
                .fileImporter(isPresented: $showPairingFileImporter, allowedContentTypes: [UTType(filenameExtension: "mobiledevicepairing", conformingTo: .data)!, UTType(filenameExtension: "mobiledevicepair", conformingTo: .data)!], onCompletion: { result in
                                switch result {
                                case .success(let url):
                                    do {
                                        pairingFile = try String(contentsOf: url)
                                        startMinimuxer()
                                    } catch {
                                        lastError = error.localizedDescription
                                        showErrorAlert.toggle()
                                    }
                                case .failure(let error):
                                    lastError = error.localizedDescription
                                    showErrorAlert.toggle()
                                }
                            })
                            .alert("Error", isPresented: $showErrorAlert) {
                                Button("OK") {}
                            } message: {
                                Text(lastError ?? "???")
                            }
                
                // MARK: App Credits
                Section {
                    // app credits
                    LinkCell(imageName: "leminlimez", url: "https://x.com/leminlimez", title: "leminlimez", contribution: NSLocalizedString("Main Developer", comment: "leminlimez's contribution"), circle: true)
                    LinkCell(imageName: "khanhduytran", url: "https://github.com/khanhduytran0/SparseBox", title: "khanhduytran0", contribution: "SparseBox", circle: true)
                    LinkCell(imageName: "jjtech", url: "https://github.com/JJTech0130/TrollRestore", title: "JJTech0130", contribution: "Sparserestore", circle: true)
                    LinkCell(imageName: "disfordottie", url: "https://x.com/disfordottie", title: "disfordottie", contribution: "Some Global Flag Features", circle: true)
                    LinkCell(imageName: "f1shy-dev", url: "https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5#file-eligibility-plist", title: "f1shy-dev", contribution: "AI Enabler", circle: true)
                    LinkCell(imageName: "app.gift", url: "https://sidestore.io/", title: "SideStore", contribution: "em_proxy and minimuxer", systemImage: true, circle: true)
                    LinkCell(imageName: "cable.connector", url: "https://libimobiledevice.org", title: "libimobiledevice", contribution: "Restore Library", systemImage: true, circle: true)
                    LinkCell(imageName: "ALLG", url: "https://github.com/136478738/", title: "ALLG", contribution: "中文汉化", systemImage: false, circle: true)
                } header: {
                    Label("致谢", systemImage: "wrench.and.screwdriver")
                }
            }
            .onOpenURL(perform: { url in
                // for opening the mobiledevicepairing file
                if url.pathExtension.lowercased() == "mobiledevicepairing" {
                    do {
                        pairingFile = try String(contentsOf: url)
                        startMinimuxer()
                    } catch {
                        lastError = error.localizedDescription
                        showErrorAlert.toggle()
                    }
                }
            })
            .onAppear {
                _ = start_emotional_damage("127.0.0.1:51820")
                if let altPairingFile = Bundle.main.object(forInfoDictionaryKey: "ALTPairingFile") as? String, altPairingFile.count > 5000, pairingFile == nil {
                    pairingFile = altPairingFile
                } else if pairingFile == nil, FileManager.default.fileExists(atPath: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing").path) {
                    pairingFile = try? String(contentsOf: URL.documents.appendingPathComponent("pairingfile.mobiledevicepairing"))
                }
                startMinimuxer()
            }
            .navigationTitle("金块")
            .navigationDestination(for: String.self) { view in
                if view == "应用变更" {
                    LogView(resetting: false, autoReboot: autoReboot, skipSetup: skipSetup)
                } else if view == "恢复更改" {
                    LogView(resetting: true, autoReboot: autoReboot, skipSetup: skipSetup)
                }
            }
            .alert("错误", isPresented: $showErrorAlert) {
                Button("完成") {}
            } message: {
                Text(lastError ?? "???")
            }
        }
    }
    
    init() {
        // Fix file picker
        if let fixMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, Selector(("fix_initForOpeningContentTypes:asCopy:"))), let origMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.init(forOpeningContentTypes:asCopy:))) {
            method_exchangeImplementations(origMethod, fixMethod)
        }
    }
    
    func applyChanges(reverting: Bool) {
        if ApplyHandler.shared.trollstore || ready() {
            if !reverting && ApplyHandler.shared.allEnabledTweaks().isEmpty {
                // if there are no enabled tweaks then tell the user
                UIApplication.shared.alert(body: "您没有启用任何调整！请转到工具页面选择一些。")
            } else if ApplyHandler.shared.isExploitOnly() {
                path.append(reverting ? "恢复更改" : "应用变更")
            } else if !ApplyHandler.shared.trollstore {
                // if applying non-exploit files, warn about setup
                UIApplication.shared.confirmAlert(title: "警告！", body: "您正在应用与漏洞利用无关的文件。这将显示设置屏幕。如果不想继续，请单击“取消”。\n\n设置时，您必须单击\“不传输应用程序和数据\”。\n\n如果您看到屏幕上显示\“iPhone部分设置\”，请不要点击蓝色大按钮。您必须单击\“继续部分安装\”.", onOK: {
                    path.append(reverting ? "恢复更改" : "应用变更")
                }, noCancel: false)
            }
        } else if pairingFile == nil {
            lastError = "请选择您的配对文件以继续。"
            showErrorAlert.toggle()
        } else {
            lastError = "minimuxer 尚未准备好。请确保您已设置 WiFi 和 WireGuard VPN。
"
            showErrorAlert.toggle()
        }
    }
    
    struct LinkCell: View {
        var imageName: String
        var url: String
        var title: String
        var contribution: String
        var systemImage: Bool = false
        var circle: Bool = false
        
        var body: some View {
            HStack(alignment: .center) {
                Group {
                    if systemImage {
                        Image(systemName: imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        if imageName != "" {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                }
                .cornerRadius(circle ? .infinity : 0)
                .frame(width: 24, height: 24)
                
                VStack {
                    HStack {
                        Button(action: {
                            if url != "" {
                                UIApplication.shared.open(URL(string: url)!)
                            }
                        }) {
                            Text(title)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal, 6)
                        Spacer()
                    }
                    HStack {
                        Text(contribution)
                            .padding(.horizontal, 6)
                            .font(.footnote)
                        Spacer()
                    }
                }
            }
            .foregroundColor(.blue)
        }
    }
    
    func startMinimuxer() {
        guard pairingFile != nil else {
            return
        }
        target_minimuxer_address()
        do {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].absoluteString
            try start(pairingFile!, documentsDirectory)
        } catch {
            lastError = error.localizedDescription
            showErrorAlert.toggle()
        }
    }
    
    public func withArrayOfCStrings<R>(
        _ args: [String],
        _ body: ([UnsafeMutablePointer<CChar>?]) -> R
    ) -> R {
        var cStrings = args.map { strdup($0) }
        cStrings.append(nil)
        defer {
            cStrings.forEach { free($0) }
        }
        return body(cStrings)
    }
}
