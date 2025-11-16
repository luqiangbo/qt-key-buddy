import QtQuick 2.15

pragma Singleton

QtObject {
	id: theme

	// 基线尺寸
	readonly property int radius: 12
	readonly property int spacingXS: 8
	readonly property int spacingSM: 12
	readonly property int spacingMD: 16
	readonly property int spacingLG: 20
	readonly property int edge: 24

	// 字号
	readonly property int fontTitle: 18
	readonly property int fontSubTitle: 14
	readonly property int fontBody: 12

	// 颜色（深色基线）
	readonly property color bg: "#101317"
	readonly property color card: "#151a21"
	readonly property color border: "#2a2f36"
	readonly property color text: "#cfd8dc"
	readonly property color textWeak: "#90a4ae"

	// 强调色（可根据 Material.accent 变化）
	readonly property color accent: "#00bfa5" // Teal
}


