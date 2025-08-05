# qt_add_qml_module(QGC
#     URI QGroundControl
#     VERSION 1.0
#     IMPORT_PATH ${QT_QML_OUTPUT_DIRECTORY}
# )

target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        main.cc
        CmdLineOptParser.cc
        CmdLineOptParser.h
        QGCApplication.cc
        QGCApplication.h
)

if(NOT ANDROID AND NOT IOS)
    target_sources(${CMAKE_PROJECT_NAME}
        PRIVATE
            RunGuard.cc
            RunGuard.h
    )
endif()

target_link_libraries(${CMAKE_PROJECT_NAME}
    PRIVATE
        # Qt6::Charts
        Qt6::Concurrent
        Qt6::Core
        # Qt6::Core5Compat
        Qt6::CorePrivate
        Qt6::Gui
        Qt6::Location
        Qt6::LocationPrivate
        Qt6::Multimedia
        Qt6::MultimediaQuickPrivate
        Qt6::Network
        Qt6::Positioning
        Qt6::PositioningPrivate
        Qt6::Qml
        Qt6::QmlIntegration
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Svg
        # Qt6::TextToSpeech
        Qt6::Widgets
        Qt6::Xml
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(FactSystem)
add_subdirectory(UI)
add_subdirectory(Settings)
add_subdirectory(Terrain)
add_subdirectory(QmlControls)
add_subdirectory(VideoManager)
add_subdirectory(QtLocationPlugin)
add_subdirectory(Utilities)
add_subdirectory(Android)
add_subdirectory(VKServer)

