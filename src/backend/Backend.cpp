#include "Backend.h"
#include <QDebug>
#include <QJsonObject>

#ifdef _WIN32
#include <windows.h>
#endif

Backend::Backend(QObject* parent) : QObject(parent) {
}

void Backend::saveConfig() {
	qDebug() << "[Backend] saveConfig called";
}

void Backend::showOverlay(const QImage& image) {
	Q_UNUSED(image);
	qDebug() << "[Backend] showOverlay called";
}

double Backend::getCpuUsage() {
	// Placeholder: integrate with PDH later
	return 0.0;
}

QJsonObject Backend::getNetworkSpeed() {
	// Placeholder: integrate with GetIfTable later
	QJsonObject obj;
	obj.insert("upload", 0.0);
	obj.insert("download", 0.0);
	return obj;
}

QImage Backend::captureScreen() {
	// Placeholder: integrate with BitBlt later
	return QImage();
}


