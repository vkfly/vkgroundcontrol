/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include <QtQuick/QQuickWindow>
#include <QtWidgets/QApplication>

#include "QGCApplication.h"
#include "AppMessages.h"
#include "CmdLineOptParser.h"

#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    #include <QtWidgets/QMessageBox>
    #include "RunGuard.h"
#endif

#ifdef Q_OS_ANDROID
    #include "AndroidInterface.h"
#endif

#ifdef Q_OS_LINUX
    #ifndef Q_OS_ANDROID
        #include "SignalHandler.h"
    #endif
#endif

#ifdef QT_DEBUG

#ifdef Q_OS_WIN

#include <crtdbg.h>
#include <windows.h>
#include <iostream>

/// @brief CRT Report Hook installed using _CrtSetReportHook. We install this hook when
/// we don't want asserts to pop a dialog on windows.
int WindowsCrtReportHook(int reportType, char* message, int* returnValue) {
    Q_UNUSED(reportType);
    std::cerr << message << std::endl;  // Output message to stderr
    *returnValue = 0;                   // Don't break into debugger
    return true;                        // We handled this fully ourselves
}

#endif // Q_OS_WIN

#endif // QT_DEBUG

//-----------------------------------------------------------------------------
/**
 * @brief Starts the application
 *
 * @param argc Number of commandline arguments
 * @param argv Commandline arguments
 * @return exit code, 0 for normal exit and !=0 for error cases
 */

int main(int argc, char *argv[]) {
#if !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS)
    // We make the runguard key different for custom and non custom
    // builds, so they can be executed together in the same device.
    // Stable and Daily have same QGC_APP_NAME so they would
    // not be able to run at the same time
    const QString runguardString = QStringLiteral("%1 RunGuardKey").arg(QGC_APP_NAME);
    RunGuard guard(runguardString);
    if (!guard.tryToRun()) {
        QApplication errorApp(argc, argv);
        QMessageBox::critical(nullptr, QObject::tr("Error"),
                              QObject::tr("A second instance of %1 is already running. Please close the other instance and try again.").arg(QGC_APP_NAME)
                             );
        return -1;
    }
#endif
#ifdef Q_OS_LINUX
#ifndef Q_OS_ANDROID
    if (getuid() == 0) {
        QApplication errorApp(argc, argv);
        QMessageBox::critical(nullptr, QObject::tr("Error"),
                              QObject::tr("You are running %1 as root. "
                    "You should not do this since it will cause other issues with %1."
                    "%1 will now exit.<br/><br/>").arg(QGC_APP_NAME)
                             );
        return -1;
    }
#endif
#endif
#ifdef Q_OS_UNIX
    if (!qEnvironmentVariableIsSet("QT_ASSUME_STDERR_HAS_CONSOLE")) {
        qputenv("QT_ASSUME_STDERR_HAS_CONSOLE", "1");
    }
#endif
    AppMessages::installHandler();
#ifdef Q_OS_WIN
    // Set our own OpenGL buglist
    // qputenv("QT_OPENGL_BUGLIST", ":/opengl/resources/opengl/buglist.json");
    // Allow for command line override of renderer
    for (int i = 0; i < argc; i++) {
        const QString arg(argv[i]);
        if (arg == QStringLiteral("-desktop")) {
            QCoreApplication::setAttribute(Qt::AA_UseDesktopOpenGL);
            break;
        } else if (arg == QStringLiteral("-swrast")) {
            QCoreApplication::setAttribute(Qt::AA_UseSoftwareOpenGL);
            break;
        }
    }
#endif
    bool simpleBootTest = false;
#ifdef QT_DEBUG
#else
    CmdLineOpt_t rgCmdLineOptions[] = {
        { "--simple-boot-test", &simpleBootTest, nullptr },
    };
    ParseCmdLineOptions(argc, argv, rgCmdLineOptions, std::size(rgCmdLineOptions), false);
#endif // QT_DEBUG
    QGCApplication app(argc, argv, simpleBootTest);
#ifdef Q_OS_LINUX
#ifndef Q_OS_ANDROID
    SignalHandler::instance();
    (void) SignalHandler::setupSignalHandlers();
#endif
#endif
    app.init();
    int exitCode = 0;
    {
#ifdef Q_OS_ANDROID
        AndroidInterface::checkStoragePermissions();
#endif
        if (!simpleBootTest) {
            exitCode = app.exec();
        }
    }
    app.shutdown();
    return exitCode;
}
