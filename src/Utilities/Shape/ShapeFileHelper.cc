/****************************************************************************
 *
 * (c) 2009-2024 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "ShapeFileHelper.h"
#include "KMLHelper.h"
#include "SHPFileHelper.h"

QVariantList ShapeFileHelper::determineShapeType(const QString &file) {
    QString errorString;
    const ShapeType shapeType = determineShapeType(file, errorString);
    QVariantList varList;
    varList.append(QVariant::fromValue(shapeType));
    varList.append(QVariant::fromValue(errorString));
    return varList;
}

bool ShapeFileHelper::_fileIsKML(const QString &file, QString &errorString) {
    errorString.clear();
    if (file.endsWith(kmlFileExtension)) {
        return true;
    } else if (file.endsWith(shpFileExtension)) {
        return false;
    } else {
        errorString = QString(_errorPrefix).arg(QObject::tr("Unsupported file type. Only .%1 and .%2 are supported.").arg(kmlFileExtension, shpFileExtension));
    }
    return true;
}

ShapeFileHelper::ShapeType ShapeFileHelper::determineShapeType(const QString &file, QString &errorString) {
    errorString.clear();
    const bool fileIsKML = _fileIsKML(file, errorString);
    ShapeType shapeType = Error;
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            shapeType = KMLHelper::determineShapeType(file, errorString);
        } else {
            shapeType = SHPFileHelper::determineShapeType(file, errorString);
        }
    }
    return shapeType;
}

bool ShapeFileHelper::loadPolygonFromFile(const QString &file, QList<QGeoCoordinate> &vertices, QString &errorString) {
    bool success = false;
    errorString.clear();
    vertices.clear();
    const bool fileIsKML = _fileIsKML(file, errorString);
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            success = KMLHelper::loadPolygonFromFile(file, vertices, errorString);
        } else {
            success = SHPFileHelper::loadPolygonFromFile(file, vertices, errorString);
        }
    }
    return success;
}

bool ShapeFileHelper::loadPolylineFromFile(const QString &file, QList<QGeoCoordinate> &coords, QString &errorString) {
    errorString.clear();
    coords.clear();
    const bool fileIsKML = _fileIsKML(file, errorString);
    if (errorString.isEmpty()) {
        if (fileIsKML) {
            KMLHelper::loadPolylineFromFile(file, coords, errorString);
        } else {
            errorString = QString(_errorPrefix).arg(QObject::tr("Polyline not support from SHP files."));
        }
    }
    return errorString.isEmpty();
}

QStringList ShapeFileHelper::fileDialogKMLFilters() {
    return QStringList(QObject::tr("KML Files (*.%1)").arg(kmlFileExtension));
}

QStringList ShapeFileHelper::fileDialogKMLOrSHPFilters() {
    return QStringList(QObject::tr("KML/SHP Files (*.%1 *.%2)").arg(kmlFileExtension, shpFileExtension));
}
