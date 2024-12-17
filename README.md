<p align="center"><img src="https://socialify.git.ci/136478738/Nugget-Mobile/image?description=1&descriptionEditable=ALLG%E6%B1%89%E5%8C%96&font=Bitter&forks=1&issues=1&language=1&name=1&owner=1&pattern=Floating%20Cogs&pulls=1&stargazers=1&theme=Auto" alt="Nugget-Mobile"/></p>

![Artboard](https://github.com/leminlimez/Nugget-Mobile/blob/1881fdc2b721fd2675a2909e7fbc24769d11bb53/readme-images/icon.png)

# Nugget (mobile)
# 金块（移动版）

汉化版本Nugget-Mobile下载地址：<a href="https://nightly.link/136478738/Nugget-Mobile/workflows/build/main/artifact.zip"><img src="https://nightly.link/logo.svg" alt style="width: 20px;" /></a> [nightly.link](https://nightly.link/136478738/Nugget-Mobile/workflows/build/main/artifact.zip)
<br>Unlock your device's full potential! Should work on all versions iOS 16.0 - 18.2 developer beta 2 (public beta 1).
<br>释放您设备的全部潜力！应适用于所有版本的iOS 16.0-18.2开发者测试版2（公测版1）。
<br>This will not work on iOS 18.2 beta 2 or newer. Please do not make issues about this, it will not be fixed. You will have to use the [pc version of Nugget](https://github.com/leminlimez/Nugget) unless a fix comes in the future.
<br>这在iOS 18.2 beta 2或更高版本上不起作用。请不要对此提出问题，它不会被修复。你必须使用[pc版的Nugget](https://github.com/leminlimez/Nugget)除非将来有解决办法。
<br>A `.mobiledevicepairing` file and wireguard are required in order to use this. Read the [sections](#getting-your-mobiledevicepairing-file) below to see how to get those.
<br>使用此功能需要一个“.mobiledvicepairing”文件和wireguard。阅读下面的[获取您的 mobiledevicepairing 文件](#获取您的-mobiledevicepairing-文件)，了解如何获取这些文件。
<br>If you are having issues with minimuxer, see the [Solving Minimuxer Issues](#solving-minimuxer-issues) thread.
<br>如果您在使用minimuxer时遇到问题，请参阅[解决minimuxer问题]（#解决minimuxers问题）线程。
<br>This uses the sparserestore exploit to write to files outside of the intended restore location, like mobilegestalt.
<br>这使用sparserestore漏洞来写入预期还原位置之外的文件，如mobilegestalt。
<br>Note: I am not responsible if your device bootloops, use this software with caution. Please back up your data before using!
<br>注意：如果您的设备启动循环，我不负责，请谨慎使用此软件。请在使用前备份您的数据！
## Getting Your mobiledevicepairing File
## 获取您的 mobiledevicepairing 文件
To get the pairing file, use the following steps:
<br>要获取配对文件，请使用以下步骤：
1. Download `jitterbugpair` for your system from here: <https://github.com/osy/Jitterbug/releases/latest>
   <br>从这里为您的系统下载`jitterbugpair`：<https://github.com/osy/Jitterbug/releases/latest>
   - **Note:** On mac or linux, you may have to run the terminal command `chmod +x ./jitterbugpair` in the same directory.
   - 注意:在mac或linux上，您可能需要运行终端命令`chmod+x/jitterbugpair位于同一目录中。
2. Run the program by either double clicking it or using terminal/powershell
   <br>双击程序或使用终端/powershell运行程序
3. Share the `.mobiledevicepairing` file to your iOS device
   <br>将“.mobiledvicepairing”文件共享到您的iOS设备
4. Open the app and select the pairing file
   <br>打开应用程序并选择配对文件

You should only have to do this once unless you lose the file and delete the app's data.
<br>除非你丢失了文件并删除了应用程序的数据，否则你应该只做一次。

## Setting Up WireGuard
## 设置WireGuard
1. Download [WireGuard](<https://apps.apple.com/us/app/wireguard/id1441195209>) on the iOS App Store.
   <br>在 iOS App Store 下载 [WireGuard](<https://apps.apple.com/us/app/wireguard/id1441195209>)。
2. Download [SideStore's config file](https://github.com/sidestore/sidestore/releases/download/0.1.1/sidestore.conf) on your iOS device
   <br>在您的 iOS 设备上下载 [SideStore 的配置文件](https://github.com/sidestore/sidestore/releases/download/0.1.1/sidestore.conf)
3. Share the config file to WireGuard using the share menu
   <br>使用共享菜单将配置文件共享给 WireGuard
4. Enable it and run Nugget
   <br>启用它并运行 Nugge

## Solving Minimuxer Issues
## 解决 Minimuxer 问题
If you have used Cowabunga Lite before, you may experience issues with minimuxer. This is due to how it skipped the setup process.
<br>如果您之前使用过 Cowabunga Lite，您可能会遇到 minimuxer 问题。这是因为它跳过了设置过程。
<br>These steps should solve the problem, however it is not an end-all be-all solution.
<br>这些步骤应该可以解决问题，但是并不是万能的解决方案。
1. Download [Nugget Python](https://github.com/leminlimez/Nugget) and follow the steps in the readme to install python and the requirements
   <br>下载 [Nugget Python](https://github.com/leminlimez/Nugget) 并按照自述文件中的步骤安装 python 和满足要求
2. Connect your device and (in terminal) type `python3 fix-minimuxer.py` (or `python fix-minimuxer.py` if it doesn't work)
   <br>连接你的设备并（在终端中）输入“python3 fix-minimuxer.py”（如果不起作用，则输入“python fix-minimuxer.py”）

Your device should reboot. After it reboots, try Nugget mobile now. If it still doesn't work, follow the steps below:
<br>您的设备应重新启动。重新启动后，立即尝试 Nugget mobile。如果仍然不起作用，请按照以下步骤操作：

3. After your device reboots, go to `[Settings] -> General -> Transfer or Reset iPhone`
   <br>设备重启后，转到“[设置] -> 通用 -> 传输或重置 iPhone”
4. Tap `Reset` and then `Reset Location & Privacy`
   <br>点击“重置”，然后点击“重置位置和隐私”
5. Nugget mobile should work now. If it doesn't, try getting a new pairing file.
   <br>Nugget mobile 现在应该可以正常工作了。如果不行，请尝试获取新的配对文件。

If the steps above don't work for you, try using `Cowabunga Lite` and clicking the `Deep Clean` button, then try the steps again.
<br>如果上述步骤对您不起作用，请尝试使用“Cowabunga Lite”并单击“深度清洁”按钮，然后再次尝试这些步骤。
If not even that works, the only solution I know is to wipe the device (not ideal). I would recommend using [Nugget Python](https://github.com/leminlimez/Nugget) instead in this case.
<br>如果这还不起作用，我知道的唯一解决方案就是擦除设备（不太理想）。在这种情况下，我建议改用 [Nugget Python](https://github.com/leminlimez/Nugget)。

## Credits
## 致谢
- [JJTech](https://github.com/JJTech0130) for Sparserestore/[TrollRestore](https://github.com/JJTech0130/TrollRestore)
- khanhduytran for [Sparsebox](https://github.com/khanhduytran0/SparseBox)
- [pymobiledevice3](https://github.com/doronz88/pymobiledevice3)
- [disfordottie](https://x.com/disfordottie) for some global flag features
- f1shy-dev for the old [AI Enabler](https://gist.github.com/f1shy-dev/23b4a78dc283edd30ae2b2e6429129b5#file-eligibility-plist)
- [SideStore](https://sidestore.io/) for em_proxy and minimuxer
- [libimobiledevice](https://libimobiledevice.org) for the restore library
