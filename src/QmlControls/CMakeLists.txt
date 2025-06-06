target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        AppMessages.cc
        AppMessages.h
        FactValueGrid.cc
        FactValueGrid.h
        QGCImageProvider.cc
        QGCImageProvider.h
        VKPalette.cc
        VKPalette.h
        QGroundControlQmlGlobal.cc
        QGroundControlQmlGlobal.h
        QmlObjectListModel.cc
        QmlObjectListModel.h
        ScreenToolsController.cc
        ScreenToolsController.h
        FileDownloader.cpp
        FileDownloader.h
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

# file(GLOB_RECURSE QML_SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/*.qml)
# qt_add_qml_module(QmlControls
#     URI QGroundControl.Controls
#     VERSION 1.0
#     QML_FILES ${QML_SOURCES}
#     RESOURCES
#       arrow-down.png
#       checkbox-check.svg
#       EditPositionDialog.FactMetaData.json
#       RCToParamDialog.FactMetaData.json
#     OUTPUT_TARGETS QmlControls_targets
#     IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
#     IMPORTS
#       QtQuick
#       QtQuick.Controls
#       QtQuick.Window
#       QtQuick.Dialogs
#       QtQuick.Layouts
#       Qt.labs.platform
#       QGroundControl
#       QGroundControl.Controllers
#       QGroundControl.FactControls
#       QGroundControl.Palette
#       QGroundControl.ScreenTools
#     DEPENDENCIES
#         QtCore
# )
