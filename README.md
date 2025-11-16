# **键盘改建工具 - 完整项目规划（MD）**

> **项目名**：`KeyBuddy` > **定位**：现代 Win11 风格键盘改建工具（改键 + 截屏 + 贴图 + CPU/网速监控）
> **技术栈**：**QML (FluentUI) + C++ + Qt 6.10 + qml-live 热重载** > **目标**：**前端开发者 3 天出 MVP，1 周打包发布**

---

## 当前状态（2025-11-16，已实现的现代化 UI）

- UI：基于 Qt 6.10 的 Qt Quick Controls 2 + Material 主题（不依赖 Qt5Compat）
- 布局：左右分栏（左侧类 Tabs 导航、右侧页面），矢量 SVG 图标，卡片阴影（Material.elevation）
- 主题：支持“跟随系统主题”与“手动明/暗切换”（`Settings` 页面）
- 设计令牌：`src/ui/store/Theme.qml` 统一圆角/间距/字号/颜色基线
- 页面：
  - Home（键盘映射配置）
  - Capture（截图，占位）
  - SystemInfo（硬件信息：CPU/网络卡片）
  - Settings（主题设置：跟随系统/明暗切换）
- 资源：开发期从源码目录直读（无需 rcc），`ASSETS_DIR` 注入到 QML
- 构建：Qt Creator 直接运行；或使用 CMake 脚本（Windows）
  - `pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/build-cmake.ps1 -QtPath "D:\Qt\6.10.0\mingw_64"`

> 注：本仓库当前 UI 走“纯 Qt 6”方案，未启用 FluentUI；你仍可按需替换为 FluentUI 或 Kirigami 等。

---

## 一、项目总览

| 功能                  | 技术实现                           | 优先级 |
| --------------------- | ---------------------------------- | ------ |
| 改键（一键 → 组合键） | C++ 全局钩子 + `SendInput`         | ★★★★★  |
| 截屏（全屏/区域）     | C++ `BitBlt` + 剪贴板              | ★★★★★  |
| 贴图（截屏后悬浮）    | QML `Window` + `DropShadow`        | ★★★★☆  |
| CPU 使用率            | C++ `PDH` API                      | ★★★★☆  |
| 网速监控              | C++ `GetIfTable`                   | ★★★★☆  |
| 托盘 + 配置面板       | QML `FluentUI` + `QSystemTrayIcon` | ★★★★★  |

---

## 二、技术选型（前端开发者友好）

| 模块         | 技术                   | 理由                           |
| ------------ | ---------------------- | ------------------------------ |
| **UI 框架**  | **QML + FluentUI.QML** | Win11 毛玻璃、暗黑模式、热重载 |
| **状态管理** | **QML Singleton**      | 类似 Zustand                   |
| **组件复用** | **qtpm 包管理**        | 类似 npm                       |
| **热重载**   | **qml-live**           | 类似 Vite                      |
| **后台逻辑** | **C++ Q_INVOKABLE**    | 性能 + 系统权限                |
| **打包**     | **windeployqt + NSIS** | 15MB 单文件 EXE                |

---

## 三、项目目录结构

```bash
KeyBuddy/
├── src/                      # 源码
│   ├── main.cpp              # 入口 + 托盘 + C++ 注册
│   ├── backend/              # C++ 模块
│   │   ├── KeyHook.cpp       # 全局键盘钩子
│   │   ├── Screenshot.cpp    # 截屏 + 区域选择
│   │   ├── OverlayWindow.cpp # 贴图悬浮窗
│   │   ├── SystemMonitor.cpp # CPU + 网速
│   │   └── Backend.h         # QML 暴露接口
│   ├── ui/                   # QML 界面
│   │   ├── Main.qml          # 主配置面板
│   │   ├── components/       # 复用组件
│   │   │   ├── KeyMapItem.qml
│   │   │   ├── ActionButton.qml
│   │   │   └── MonitorCard.qml
│   │   ├── pages/            # 页面
│   │   │   ├── HomePage.qml
│   │   │   └── SettingsPage.qml
│   │   └── store/            # 状态管理
│   │       └── AppStore.qml
│   └── resources/           # 资源
│       ├── icons/            # 托盘图标
│       └── qml.qrc           # QML 资源文件
├── build/                    # 构建输出（.gitignore）
├── dist/                     # 打包输出
├── scripts/                  # 脚本
│   └── build.bat             # 一键打包
├── .gitignore
├── KeyBuddy.pro             # qmake 项目文件
├── CMakeLists.txt            # CMake（可选）
└── package.json              # qtpm 包管理
```

---

## 四、核心模块实现

### 1. **改键（KeyHook.cpp）**

```cpp
LRESULT CALLBACK LowLevelKeyboardProc(int nCode, WPARAM wParam, LPARAM lParam) {
    if (wParam == WM_KEYDOWN) {
        auto* p = (KBDLLHOOKSTRUCT*)lParam;
        if (p->vkCode == VK_F1) {
            sendCombo(VK_CONTROL, VK_MENU, VK_SHIFT, 'S');
            return 1;
        }
    }
    return CallNextHookEx(nullptr, nCode, wParam, lParam);
}
```

### 2. **截屏 + 贴图（Screenshot.cpp + OverlayWindow.cpp）**

```cpp
// 截全屏
HBITMAP CaptureScreen() { /* BitBlt */ }

// 贴图悬浮窗（QML 调用）
Q_INVOKABLE void showOverlay(const QImage& img) {
    overlay->setImage(img);
    overlay->show();
}
```

### 3. **CPU + 网速（SystemMonitor.cpp）**

```cpp
Q_INVOKABLE double getCpuUsage() { /* PDH */ }
Q_INVOKABLE QJsonObject getNetworkSpeed() { /* GetIfTable */ }
```

### 4. **QML 状态管理（AppStore.qml）**

```qml
pragma Singleton
QtObject {
    property var keyMaps: ({})
    property double cpu: 0
    property double upload: 0
    property double download: 0

    function addKeyMap(trigger, action) {
        keyMaps[trigger] = action
        Backend.saveConfig()
    }
}
```

---

## 五、UI 设计（FluentUI.QML）

```qml
// components/MonitorCard.qml
FluAcrylicRectangle {
    width: 200; height: 100
    FluText { text: "CPU" }
    FluProgressRing { value: AppStore.cpu; width: 60; height: 60 }
    FluText { text: AppStore.cpu.toFixed(1) + "%" }
}
```

```qml
// Main.qml
FluAcrylicWindow {
    FluAppBar { title: "KeyBuddy" }
    FluNavigationView {
        items: [
            FluNavigationItem { title: "主页"; icon: FluentIcons.Home },
            FluNavigationItem { title: "设置"; icon: FluentIcons.Settings }
        ]
        pageMode: FluNavigationView.PageMode.Stack
    }
}
```

---

## 六、开发工作流（前端式）

```bash
# 1. 启动热重载
qml-live src/ui/Main.qml --port 8080

# 2. 修改 QML → 0.3s 刷新
# 3. C++ 修改 → 重新编译（qmake）
```

---

## 七、构建与打包

### 1. **编译（qmake）**

```bat
# scripts/build.bat
qmake KeyBuddy.pro
nmake
```

### 2. **打包（windeployqt + NSIS）**

```bat
# 复制依赖
windeployqt.exe dist/KeyBuddy.exe

# 生成安装包
makensis installer.nsi
```

**输出**：`dist/KeyBuddy-Setup.exe`（~18MB）

---

## 八、一键启动脚本

```bash
# install.bat
qtpm install @fluentui/qml qml-live
qml-live src/ui/Main.qml
```

---

## 九、未来扩展

| 功能       | 技术                          |
| ---------- | ----------------------------- |
| 云同步配置 | C++ + Qt Network              |
| 宏录制     | C++ 事件队列                  |
| 插件系统   | QML Module + C++ Plugin       |
| macOS 支持 | QML 复用，C++ 换 `CGEventTap` |

---

## 十、资源链接

| 资源             | 链接                                    |
| ---------------- | --------------------------------------- |
| **项目模板**     | https://github.com/KeyBuddy-qml/starter |
| **FluentUI.QML** | https://github.com/zhuzichu520/FluentUI |
| **qml-live**     | https://github.com/qml-live/qml-live    |
| **Qt 6.10 下载** | https://www.qt.io/download              |

---

## 总结：**你只需要 3 天**

| 天数      | 任务                          |
| --------- | ----------------------------- |
| **Day 1** | 搭建 QML + C++ 框架，跑通改键 |
| **Day 2** | 加截屏 + 贴图 + FluentUI 界面 |
| **Day 3** | 加 CPU/网速 + 打包发布        |

---

**现在就开始**：

```bash
git clone https://github.com/KeyBuddy-qml/starter KeyBuddy
cd KeyBuddy
install.bat
```

> **你不是在学 Qt，你是在用“前端超能力”写原生工具！**

---
