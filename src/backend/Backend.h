#pragma once

#include <QObject>
#include <QImage>
#include <QJsonObject>

class Backend : public QObject {
	Q_OBJECT
public:
	explicit Backend(QObject* parent = nullptr);

	Q_INVOKABLE void saveConfig();
	Q_INVOKABLE void showOverlay(const QImage& image);
	Q_INVOKABLE double getCpuUsage();
	Q_INVOKABLE QJsonObject getNetworkSpeed();
	Q_INVOKABLE QImage captureScreen();
};


