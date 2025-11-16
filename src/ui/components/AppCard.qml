import QtQuick 2.15
import QtQuick.Controls 2.15
import KeyBuddy 1.0

Pane {
	id: root
	padding: 0

	// 为内容区定义具名容器，并将默认属性指向其 data
	contentItem: Item { id: contentRoot }
	default property alias content: contentRoot.data

	background: Rectangle {
		radius: Theme.radius
		color: Theme.card
		border.color: Theme.border
		border.width: 1
	}
}


