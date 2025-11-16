cmake_minimum_required(VERSION 3.21)
project(KeyBuddy LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

# 暂时采用旧策略，允许单一模块包含来自多个子目录的 QML 文件而无需为每个目录提供 qmldir
qt_policy(SET QTP0004 OLD)

# 避免构建期 qmlcachegen 因为样式/第三方模块或内联脚本导致失败，开发期先禁用
set(QT_QMLCACHEGEN_DISABLED TRUE)

set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(UI_DIR src/ui)
set(RES_DIR src/resources)

qt_add_executable(KeyBuddy
	${SRC_DIR}/main.cpp
	${SRC_DIR}/backend/Backend.h
	${SRC_DIR}/backend/Backend.cpp
	${SRC_DIR}/backend/KeyHook.cpp
	${SRC_DIR}/backend/Screenshot.cpp
	${SRC_DIR}/backend/OverlayWindow.cpp
	${SRC_DIR}/backend/SystemMonitor.cpp
)

target_include_directories(KeyBuddy PRIVATE ${SRC_DIR})

# 采用 Qt 6 模块化方式：打包 QML 与资源为 QML Module
qt_add_qml_module(KeyBuddy
	URI KeyBuddy
	VERSION 1.0
	RESOURCE_PREFIX "/"
	QML_FILES
		${UI_DIR}/Main.qml
		${UI_DIR}/store/AppStore.qml
		${UI_DIR}/store/Theme.qml
		${UI_DIR}/components/MonitorCard.qml
		${UI_DIR}/components/AppCard.qml
		${UI_DIR}/components/ActionButton.qml
		${UI_DIR}/components/KeyMapItem.qml
		${UI_DIR}/components/SettingsForm.qml
		${UI_DIR}/components/NavTabButton.qml
		${UI_DIR}/components/NavigationSidebar.qml
		${UI_DIR}/pages/HomePage.qml
		${UI_DIR}/pages/CapturePage.qml
		${UI_DIR}/pages/SettingsPage.qml
		${UI_DIR}/pages/SystemInfoPage.qml
	RESOURCES
		${RES_DIR}/icons/camera.svg
		${RES_DIR}/icons/info.svg
		${RES_DIR}/icons/keyboard.svg
		${RES_DIR}/icons/save.svg
		${RES_DIR}/icons/settings.svg
		myfiles.ico
)

# 为资源设置稳定的别名，确保以 qrc:/icons/... 访问
set_source_files_properties(
	${RES_DIR}/icons/camera.svg
	PROPERTIES QT_RESOURCE_ALIAS "icons/camera.svg"
)
set_source_files_properties(
	${RES_DIR}/icons/info.svg
	PROPERTIES QT_RESOURCE_ALIAS "icons/info.svg"
)
set_source_files_properties(
	${RES_DIR}/icons/keyboard.svg
	PROPERTIES QT_RESOURCE_ALIAS "icons/keyboard.svg"
)
set_source_files_properties(
	${RES_DIR}/icons/save.svg
	PROPERTIES QT_RESOURCE_ALIAS "icons/save.svg"
)
set_source_files_properties(
	${RES_DIR}/icons/settings.svg
	PROPERTIES QT_RESOURCE_ALIAS "icons/settings.svg"
)
set_source_files_properties(
	myfiles.ico
	PROPERTIES QT_RESOURCE_ALIAS "icons/app.ico"
)

target_link_libraries(KeyBuddy PRIVATE
	Qt6::Core
	Qt6::Gui
	Qt6::Qml
	Qt6::Quick
	Qt6::QuickControls2
)

if (WIN32)
	target_link_libraries(KeyBuddy PRIVATE user32 gdi32)
	# 为 EXE 设置应用图标
	target_sources(KeyBuddy PRIVATE app_icon.rc)
endif()

# 将 qtquickcontrols2.conf 复制到可执行文件目录，便于运行期加载样式
add_custom_command(TARGET KeyBuddy POST_BUILD
	COMMAND ${CMAKE_COMMAND} -E copy_if_different
		"${CMAKE_SOURCE_DIR}/qtquickcontrols2.conf"
		"$<TARGET_FILE_DIR:KeyBuddy>/qtquickcontrols2.conf"
)


install(TARGETS KeyBuddy RUNTIME DESTINATION bin)


