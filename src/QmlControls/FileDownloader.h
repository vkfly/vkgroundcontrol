#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H
#include <QFile>
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class FileDownloader : public QObject
{
    Q_OBJECT
public:
    explicit FileDownloader(QObject *parent = nullptr);
    void installAPK(const QString &apkFilePath);
    Q_INVOKABLE void downloadFile(const QString &url, const QString &savePath);
    Q_INVOKABLE void  downloadFileapk(const QString &url, const QString &savePath);
    //Q_INVOKABLE void downloadFiletxt(const QString &url);
signals:
    void downloadProgressChanged(qint64 bytesReceived, qint64 bytesTotal);
    void fullpathchanged(QString fullpath);
    void fileend();
private slots:
    void onDownloadFinished();
    void onReadyRead();
signals:
    void downloadFinished(const QByteArray &data);
    void downloadError(const QString &errorString);

private slots:
    void fileDownloaded(QNetworkReply *reply);
private:
    QNetworkAccessManager *manager;
    QNetworkReply *reply;
    QFile *file;
    bool isapk=false;
    void installApk(const QString &apkPath);
    void openFile(const QString &filePath);
};

#endif // FILEDOWNLOADER_H
