#ifdef _WIN32
#include <windows.h>
#endif
#include <QJsonObject>

// Placeholder: real implementation using PDH and GetIfTable
namespace SystemMonitor {
	double cpuUsage() {
		return 0.0;
	}
	QJsonObject network() {
		QJsonObject o;
		o.insert("upload", 0.0);
		o.insert("download", 0.0);
		return o;
	}
}


