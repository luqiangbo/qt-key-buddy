TEMPLATE = app
CONFIG += c++17 console
CONFIG -= app_bundle
QT += core gui qml quick

greaterThan(QT_MAJOR_VERSION, 5): QT += quickcontrols2

TARGET = KeyBuddy

DEFINES += UNICODE _UNICODE

SOURCES += \
	src/main.cpp \
	src/backend/Backend.cpp \
	src/backend/KeyHook.cpp \
	src/backend/Screenshot.cpp \
	src/backend/OverlayWindow.cpp \
	src/backend/SystemMonitor.cpp

HEADERS += \
	src/backend/Backend.h

# Windows system libs
win32:msvc: LIBS += user32.lib gdi32.lib
win32:!msvc: LIBS += -luser32 -lgdi32

QMAKE_CXXFLAGS += /permissive- /Zc:__cplusplus


