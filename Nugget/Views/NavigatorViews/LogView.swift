//
//  LogView.swift
//  Nugget
//
//  Created by lemin on 9/9/24.
//

import SwiftUI

let logPipe = Pipe()

struct LogView: View {
    let resetting: Bool
    let autoReboot: Bool
    let skipSetup: Bool
    
    @State var log: String = ""
    @State var ran = false
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                ScrollView {
                    Text(log)
                        .font(.system(size: 12).monospaced())
                        .fixedSize(horizontal: false, vertical: false)
                        .textSelection(.enabled)
                    Spacer()
                        .id(0)
                }
                .onAppear {
                    guard !ran else { return }
                    ran = true
                    
                    logPipe.fileHandleForReading.readabilityHandler = { fileHandle in
                        let data = fileHandle.availableData
                        if !data.isEmpty, let logString = String(data: data, encoding: .utf8) {
                            log.append(logString)
                            proxy.scrollTo(0)
                        }
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        print("APPLYING")
                        if ApplyHandler.shared.trollstore {
                            // apply with trollstore
                            var succeeded: Bool = false
                            if resetting {
                                succeeded = ApplyHandler.shared.reset(udid: "", trollstore: true)
                            } else {
                                succeeded = ApplyHandler.shared.apply(udid: "", skipSetup: false, trollstore: true)
                            }
                            if succeeded {
                                // respring device
                                UIApplication.shared.alert(title: "成功！", body: "请重新启动您的设备以应用更改。")
                            } else {
                                UIApplication.shared.alert(body: "请阅读日志以获取完整的错误信息")
                            }
                            return
                        }
                        // get the device and create a directory for the backup files
                        let deviceList = MobileDevice.deviceList()
                        var udid: String
                        guard deviceList.count == 1 else {
                            print("Invalid device count: \(deviceList.count)")
                            return
                        }
                        
                        udid = deviceList.first!
                        var succeeded: Bool = false
                        if resetting {
                            succeeded = ApplyHandler.shared.reset(udid: udid, trollstore: false)
                        } else {
                            succeeded = ApplyHandler.shared.apply(udid: udid, skipSetup: skipSetup, trollstore: false)
                        }
                        if succeeded && (log.contains("恢复成功") || log.contains("crash_on_purpose")) {
                            if autoReboot {
                                print("正在重新启动设备...")
                                MobileDevice.rebootDevice(udid: udid)
                            } else {
                                UIApplication.shared.alert(title: "成功！", body: "请重新启动您的设备才能查看更改。")
                            }
                        /* Error Dialogs Below */
                        } else if log.contains("查找我的") {
                            UIApplication.shared.alert(body: "必须禁用“查找”才能使用此工具。\n\n从“设置”中禁用“查找”（设置 -> [您的姓名] ->“查找”），然后重试。")
                        } else if log.contains("无法从 mobilebackup2 接收") {
                            UIApplication.shared.alert(body: "无法接收来自 mobilebackup2 的请求。请重新启动应用程序并重试。")
                        }
                    }
                }
            }
        }
        .navigationTitle("日志输出")
    }
    
    init(resetting: Bool, autoReboot: Bool, skipSetup: Bool) {
        self.resetting = resetting
        self.autoReboot = autoReboot
        self.skipSetup = skipSetup
        setvbuf(stdout, nil, _IOLBF, 0) // make stdout line-buffered
        setvbuf(stderr, nil, _IONBF, 0) // make stderr unbuffered
        
        // create the pipe and redirect stdout and stderr
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stdout))
        dup2(logPipe.fileHandleForWriting.fileDescriptor, fileno(stderr))
    }
}
