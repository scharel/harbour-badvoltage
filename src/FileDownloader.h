#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QStandardPaths>
#include <QDir>
#include <QFile>
#include <QDebug>

class FileDownloader : public QObject {
    Q_OBJECT
    Q_PROPERTY(QUrl url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString filePath READ filePath WRITE setFilePath NOTIFY filePathChanged)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(QString fullName READ fullName WRITE setFullName NOTIFY fullNameChanged)
    Q_PROPERTY(bool isDownloaded READ isDownloaded NOTIFY isDownloadedChanged)
    Q_PROPERTY(bool isDownloading READ isDownloading NOTIFY isDownloadingChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)

public:
    explicit FileDownloader(QObject *parent = 0);
    virtual ~FileDownloader();

    // functions available from QML
    Q_INVOKABLE void startDownload();
    Q_INVOKABLE void abortDownload();
    Q_INVOKABLE void deleteFile();

    // read functions for the properties
    QUrl url() { return _url; }
    QString filePath() { QFileInfo info (_file); return info.absolutePath(); }
    QString fileName() { QFileInfo info (_file); return info.fileName(); }
    QString fullName() { QFileInfo info (_file); return info.absoluteFilePath(); }
    int fileSize() { return _file.size(); }
    bool isDownloaded() { return (_file.exists() && !_downloading); }
    bool isDownloading() { return _downloading; } // TODO
    double progress() { return _progress; } // TODO

private slots:
    // when data recieved
    void readData();
    // when progress made
    void progressMade(qint64 bytesReceived, qint64 bytesTotal);
    // when all data recieved
    void finishedData();
    // when error occurred
    void error(QNetworkReply::NetworkError error);

signals:
    // signals for the properties
    void urlChanged();
    void filePathChanged();
    void fileNameChanged();
    void fullNameChanged();
    void isDownloadedChanged();
    void isDownloadingChanged();
    void progressChanged();

private:
    QUrl _url;
    QFile _file;
    QNetworkAccessManager _manager;
    QNetworkReply* _reply;

    qint64 _lastBytesReceived;

    // variable for property downloading
    bool _downloading;
    // variable for property progress
    double _progress;

    // write function for the properties
    void setUrl(QUrl url);
    void setFilePath(QString path = "");
    void setFileName(QString name = "");
    void setFullName(QString full = "");
};

#endif // FILEDOWNLOADER_H
