import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import KeyBuddy 1.0

Item {
	id: root

	// [{ title, icon, index }]
	property var items: []
	property int currentIndex: 0
	signal itemClicked(int index)

	ColumnLayout {
		anchors.fill: parent
		anchors.margins: Theme.spacingSM
		spacing: Theme.spacingXS

		ButtonGroup { id: navGroup; exclusive: true }

		Repeater {
			model: root.items
			delegate: NavTabButton {
				Layout.fillWidth: true
				accentColor: Theme.accent
				text: modelData.title
				icon.source: modelData.icon
				checked: root.currentIndex === modelData.index
				ButtonGroup.group: navGroup
				onClicked: root.itemClicked(modelData.index)
			}
		}

		Item { Layout.fillHeight: true }
	}
}


