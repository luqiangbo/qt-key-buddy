import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import KeyBuddy 1.0
import "components"
import "pages"

ApplicationWindow {
    id: root
    width: 960
    height: 640
    visible: true
    title: "KeyBuddy"

    header: null

    // 路由表（数据驱动）：title/icon/component
    Component { id: compHome; HomePage {} }
    Component { id: compCapture; CapturePage {} }
    Component { id: compInfo; SystemInfoPage {} }
    Component { id: compSettings; SettingsPage {} }
    property var routes: [
        { title: "键盘映射", icon: "qrc:/icons/keyboard.svg", component: compHome },
        { title: "截图",     icon: "qrc:/icons/camera.svg",  component: compCapture },
        { title: "硬件信息", icon: "qrc:/icons/info.svg",     component: compInfo },
        { title: "设置",     icon: "qrc:/icons/settings.svg", component: compSettings }
    ]
    property int currentRouteIndex: 0

    // 左右布局：左侧导航，右侧页面
    RowLayout {
        anchors.fill: parent
        anchors.margins: 0
        spacing: 0

        // 左侧导航
        Frame {
            id: nav
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            background: Rectangle { color: Theme.card }

            NavigationSidebar {
                anchors.fill: parent
                anchors.margins: Theme.spacingSM
                currentIndex: currentRouteIndex
                items: routes.map(function(r, i){ return ({ title: r.title, icon: r.icon, index: i }) })
                onItemClicked: function(i) { currentRouteIndex = i }
            }
        }

        // 右侧内容（数据驱动）
        Loader {
            id: contentLoader
            Layout.fillWidth: true
            Layout.fillHeight: true
            sourceComponent: routes[currentRouteIndex].component
        }
    }
}


