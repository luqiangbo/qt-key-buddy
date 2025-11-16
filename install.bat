@echo off
setlocal

echo Installing QML tooling...
qtpm install @fluentui/qml qml-live

echo Starting qml-live (hot reload) on port 8080...
qml-live src/ui/Main.qml --port 8080

endlocal


