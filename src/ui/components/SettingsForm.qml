import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import KeyBuddy 1.0

/*
  数据驱动设置表单：
  - model: 数组，每项形如：
    { type: "switch", label: "跟随系统主题", get: function(){...}, set: function(v){...} }
    { type: "select", label: "主题色", options: ["Teal","Blue"], get:..., set:... }
*/
ColumnLayout {
	id: form
	property var model: []
	spacing: Theme.spacingSM

	Repeater {
		model: form.model
		delegate: Item {
			Layout.fillWidth: true
			implicitHeight: row.implicitHeight

			RowLayout {
				id: row
				anchors.fill: parent
				spacing: Theme.spacingSM

				Label {
					text: modelData.label || ""
					Layout.preferredWidth: 140
					Layout.alignment: Qt.AlignVCenter
				}

				// Switch 类型
				Loader {
					Layout.fillWidth: true
					sourceComponent: modelData.type === "switch" ? switchDelegate
					               : modelData.type === "select" ? selectDelegate
					               : null
				}
			}
		}
	}

	Component {
		id: switchDelegate
		RowLayout {
			spacing: Theme.spacingSM
			Switch {
				id: sw
				checked: (typeof modelData.get === "function") ? modelData.get() : false
				onToggled: { if (typeof modelData.set === "function") modelData.set(checked) }
			}
			Label {
				text: sw.checked ? "开启" : "关闭"
				color: Theme.textWeak
			}
		}
	}

	Component {
		id: selectDelegate
		ComboBox {
			model: modelData.options || []
			currentIndex: Math.max(0, (typeof modelData.get === "function") ? modelData.get() : 0)
			onCurrentIndexChanged: { if (typeof modelData.set === "function") modelData.set(currentIndex) }
		}
	}
}


