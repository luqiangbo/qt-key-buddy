#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QFile>
#include <QUrl>
#include <QIcon>
#include "backend/Backend.h"

int main(int argc, char *argv[]) {
	QGuiApplication app(argc, argv);
	QCoreApplication::setOrganizationName("KeyBuddy");
	QCoreApplication::setApplicationName("KeyBuddy");
	QGuiApplication::setWindowIcon(QIcon(QStringLiteral(":/icons/app.ico")));

	QQmlApplicationEngine engine;

	Backend backend;
	engine.rootContext()->setContextProperty("Backend", &backend);

	// 更现代的加载方式：从 QML 模块加载入口类型
	engine.loadFromModule(QStringLiteral("KeyBuddy"), QStringLiteral("Main"));

	return app.exec();
}


