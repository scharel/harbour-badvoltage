#include "FileDownloader.h"

#include <QNetworkRequest>

FileDownloader::FileDownloader(QObject *parent) :
    QObject(parent), _lastBytesReceived(0), _downloading(false), _progress(0.0)
{
    setFilePath();
}

FileDownloader::~FileDownloader() {
    abortDownload();
}

void FileDownloader::setUrl(QUrl url) {
    _url = url;
    if (fileName().isEmpty())
        setFileName(_url.fileName());
    emit urlChanged();
}

void FileDownloader::setFilePath(QString path) {
    bool isDownloaded = _file.exists();
    if (path.isEmpty())
        QDir().setCurrent(QStandardPaths::writableLocation(QStandardPaths::DataLocation));
    else if (!QDir().setCurrent(path))
        setFilePath();
    emit filePathChanged();
    if (isDownloaded != _file.exists())
        emit isDownloadedChanged();
}

void FileDownloader::setFileName(QString name) {
    bool isDownloaded = _file.exists();
    if (name.isEmpty())
        _file.setFileName(_url.fileName());
    else
        _file.setFileName(name);
    emit fileNameChanged();
    if (isDownloaded != _file.exists())
        emit isDownloadedChanged();
}

void FileDownloader::startDownload() {
    if (!isDownloaded() && !isDownloading()) {
        if (QDir().mkpath(QDir().currentPath())) {
            if (_file.open(QIODevice::WriteOnly)) {
                qDebug() << "Starting download" << _url;
                QNetworkRequest request(_url);
                request.setRawHeader("User-Agent", QByteArray("SailfishApp"));
                _reply = _manager.get(request);
                _downloading = true;
                emit isDownloadingChanged();

                connect(_reply, SIGNAL(readyRead()),
                        this, SLOT(readData()));
                connect(_reply, SIGNAL(downloadProgress(qint64, qint64)),
                        this, SLOT(progressMade(qint64, qint64)));
                connect(_reply, SIGNAL(finished()),
                        this, SLOT(finishedData()));
                connect(_reply, SIGNAL(error(QNetworkReply::NetworkError)),
                        this, SLOT(error(QNetworkReply::NetworkError)));
            }
            else {
                qDebug() << "Error creating file" << fileName();
            }
        }
        else {
            qDebug() << "Cannot write to this directory" << QDir().currentPath();
        }
    }
    else {
        qDebug() << "File has already been downloaded or is currently being downloaded!";
    }
}

void FileDownloader::abortDownload() {
    if (_downloading) {
        qDebug() << "Aborting download of" << _url;
        disconnect(_reply, SIGNAL(readyRead()),
                   this, SLOT(readData()));
        disconnect(_reply, SIGNAL(downloadProgress(qint64, qint64)),
                   this, SLOT(progressMade(qint64,qint64)));
        disconnect(_reply, SIGNAL(finished()),
                   this, SLOT(finishedData()));
        disconnect(_reply, SIGNAL(error(QNetworkReply::NetworkError)),
                   this, SLOT(error(QNetworkReply::NetworkError)));

        _reply->abort();
        _file.remove();
        _reply->deleteLater();

        _downloading = false;
        emit isDownloadingChanged();
    }
}

void FileDownloader::deleteFile() {
    qDebug() << "Deleting file" << _file.fileName();
    _file.remove();
    emit isDownloadedChanged();
}

void FileDownloader::readData() {
    _file.write(_reply->read(_reply->bytesAvailable()));
}

void FileDownloader::progressMade(qint64 bytesReceived, qint64 bytesTotal) {
    if (bytesReceived != _lastBytesReceived) {
        _lastBytesReceived = bytesReceived;
        _progress = (double)bytesReceived / (double)bytesTotal;
        emit progressChanged();
        //qDebug() << QFileInfo(_file).fileName() << ":" << _progress; //<< bytesReceived / 1024 / 1024 << "/" << bytesTotal / 1024 / 1024 << "MB";
    }
}

void FileDownloader::finishedData() {
    _downloading = false;
    emit isDownloadingChanged();
    if (_reply->error() == QNetworkReply::NoError) {
        qDebug() << "Finished downloading" << QFileInfo(_file).fileName() << QFileInfo(_file).size() / 1024 / 1024 << "MB";
        disconnect(_reply, SIGNAL(readyRead()),
                   this, SLOT(readData()));
        disconnect(_reply, SIGNAL(downloadProgress(qint64, qint64)),
                   this, SLOT(progressMade(qint64,qint64)));
        disconnect(_reply, SIGNAL(finished()),
                   this, SLOT(finishedData()));
        disconnect(_reply, SIGNAL(error(QNetworkReply::NetworkError)),
                   this, SLOT(error(QNetworkReply::NetworkError)));
        _reply->deleteLater();
        _file.close();
        emit isDownloadedChanged();
    }
    else
        abortDownload();
}

void FileDownloader::error(QNetworkReply::NetworkError error) {
    abort();
    if (error != QNetworkReply::NoError) {
        qDebug() << "Error while downloading file from" << _reply->url().toString() << ":" << _reply->errorString();
    }
}
