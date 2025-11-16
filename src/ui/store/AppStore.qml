import QtQuick 2.15

pragma Singleton

QtObject {
    id: store

    property var keyMaps: ({})
    property double cpu: 0
    property double upload: 0
    property double download: 0

    // 主题设置
    property bool followSystemTheme: true
    property bool darkMode: true

    function addKeyMap(trigger, action) {
        keyMaps[trigger] = action
        if (Backend && Backend.saveConfig) {
            Backend.saveConfig()
        }
    }
}


