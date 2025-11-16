import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
	id: root
	checkable: true
	focusPolicy: Qt.NoFocus
	implicitHeight: 44
	implicitWidth: 180

	// 由上层传入，用于保持与主题一致
	property color accentColor: "#00bfa5"

	background: Rectangle {
		radius: 8
		color: root.checked
		       ? (Qt.styleHints.colorScheme === Qt.ColorScheme.Dark ? "#1b222a" : "#e0f2f1")
		       : "transparent"
		border.color: root.checked ? root.accentColor : "transparent"
		border.width: root.checked ? 1 : 0
	}

	contentItem: RowLayout {
		anchors.fill: parent
		anchors.margins: 8
		spacing: 8

		Rectangle { // 左侧选中条
			visible: root.checked
			color: root.accentColor
			Layout.preferredWidth: 3
			Layout.fillHeight: true
			radius: 2
		}

		Image {
			source: root.icon.source
			width: 18; height: 18
			fillMode: Image.PreserveAspectFit
			opacity: root.checked ? 1.0 : 0.8
		}
		Label {
			text: root.text
			color: root.checked
			       ? root.accentColor
			       : (Qt.styleHints.colorScheme === Qt.ColorScheme.Dark ? "#cfd8dc" : "#263238")
			font.bold: root.checked
			font.pixelSize: root.checked ? 14 : 12
			Layout.fillWidth: true
			elide: Label.ElideRight
		}
	}
}


