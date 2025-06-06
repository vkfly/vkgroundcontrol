#include "FileDownloader.h"
#include <QFile>
#include <QFileInfo>
#include <QUrl>
#include <QDebug>
#include <QDir>
#include <QStandardPaths>
#include "QGCApplication.h"
#include "QToolBox"
#include "SettingsManager.h"

#include <QObject>
#include <QDesktopServices>
#include <QUrl>
#include <QDebug>

// #ifdef Q_OS_ANDROID
//     #include <QAndroidJniObject>
//     #include <QAndroidJniEnvironment>
//     #include <QtAndroid>
// #endif
#include <QFile>
FileDownloader::FileDownloader(QObject *parent) : QObject(parent) {
    manager = new QNetworkAccessManager(this);
    connect(manager, &QNetworkAccessManager::finished, this, &FileDownloader::onDownloadFinished);
}

QString fullPath;
void FileDownloader::downloadFile(const QString &url, const QString &savePath) {
    // isapk = false;
    // QUrl downloadUrl(url);
    // QNetworkRequest request(downloadUrl);
    // reply = manager->get(request);
    // QString dir = qgcApp()->toolbox()->settingsManager()->appSettings()->apkSavePath();
    // fullPath = dir + "/" + QFileInfo(downloadUrl.path()).fileName();
    // emit fullpathchanged(fullPath);
    // qDebug() << "open file for writing" << fullPath;
    // file = new QFile(fullPath);
    // if (!file->open(QIODevice::WriteOnly)) {
    //     qDebug() << "Could not open file for writing";
    //     delete file;
    //     return;
    // }
    // connect(reply, &QNetworkReply::readyRead, this, &FileDownloader::onReadyRead);
    // connect(reply, &QNetworkReply::downloadProgress, this, [this](qint64 bytesReceived, qint64 bytesTotal) {
    //     emit downloadProgressChanged(bytesReceived, bytesTotal);
    // });
}
void FileDownloader::downloadFileapk(const QString &url, const QString &savePath) {
    // isapk = true;
    // QUrl downloadUrl(url);
    // QNetworkRequest request(downloadUrl);
    // reply = manager->get(request);
    // QString dir = qgcApp()->toolbox()->settingsManager()->appSettings()->apkSavePath();
    // fullPath = dir + "/" + QFileInfo(downloadUrl.path()).fileName();
    // emit fullpathchanged(fullPath);
    // qDebug() << "open file for writing" << fullPath;
    // file = new QFile(fullPath);
    // if (!file->open(QIODevice::WriteOnly)) {
    //     //qDebug() << "Could not open file for writing";
    //     delete file;
    //     return;
    // }
    // connect(reply, &QNetworkReply::readyRead, this, &FileDownloader::onReadyRead);
    // connect(reply, &QNetworkReply::downloadProgress, this, [this](qint64 bytesReceived, qint64 bytesTotal) {
    //     qDebug() << "Could not open file for writing" << bytesReceived << bytesTotal;
    //     emit downloadProgressChanged(bytesReceived, bytesTotal);
    // });
}

void FileDownloader::fileDownloaded(QNetworkReply *reply) {
    if (reply->error() == QNetworkReply::NoError) {
        QByteArray data = reply->readAll();
        emit downloadFinished(data);
    } else {
        emit downloadError(reply->errorString());
    }
    reply->deleteLater();
}

void FileDownloader::onReadyRead() {
    file->write(reply->readAll());
}



void FileDownloader::onDownloadFinished() {
    file->flush();
    file->close();
    reply->deleteLater();
    if(isapk) {
        installAPK(fullPath);
    }
    emit fileend();
    //qDebug() << "File downloaded successfully";
}
void FileDownloader:: installAPK(const QString &apkFilePath) {
// #ifdef Q_OS_ANDROID
//     // 确保文件路径不为空
//     if (apkFilePath.isEmpty()) {
//         return;
//     }
//     // 将 Qt QString 转换为 Java 字符串
//     QAndroidJniObject jApkFilePath = QAndroidJniObject::fromString(apkFilePath);
//     // 获取上下文对象
//     QAndroidJniObject context = QtAndroid::androidContext();
//     // 调用 Java 的 installAPK 方法
//     QAndroidJniObject::callStaticMethod<void>("org/mavlink/qgroundcontrol/QGCActivity",
//             "installAPK",
//             "(Landroid/content/Context;Ljava/lang/String;)V",
//             context.object<jobject>(),  // 传递 context 对象
//             jApkFilePath.object<jstring>());  // 传递文件路径
// #endif
}
void FileDownloader::installApk(const QString &apkPath) {
}




void FileDownloader::openFile(const QString &filePath) {
}
