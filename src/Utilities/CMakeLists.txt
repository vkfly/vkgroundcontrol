target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        DeviceInfo.cc
        DeviceInfo.h
        JsonHelper.cc
        JsonHelper.h
        KML/KMLDomDocument.cc
        KML/KMLDomDocument.h
        KML/KMLHelper.cc
        KML/KMLHelper.h
        QGC.cc
        QGC.h
        FileSystem/QGCCachedFileDownload.cc
        FileSystem/QGCCachedFileDownload.h
        FileSystem/QGCFileDownload.cc
        FileSystem/QGCFileDownload.h
        QGCLoggingCategory.cc
        QGCLoggingCategory.h
        FileSystem/QGCTemporaryFile.cc
        FileSystem/QGCTemporaryFile.h
        Shape/ShapeFileHelper.cc
        Shape/ShapeFileHelper.h
        Shape/SHPFileHelper.cc
        Shape/SHPFileHelper.h
        StateMachine.cc
        StateMachine.h
)

if(LINUX)
    target_sources(${CMAKE_PROJECT_NAME}
        PRIVATE
            SignalHandler.cc
            SignalHandler.h
    )
elseif(IOS)
    target_sources(${CMAKE_PROJECT_NAME}
        PRIVATE
            MobileScreenMgr.mm
            MobileScreenMgr.h
    )
endif()

target_include_directories(${CMAKE_PROJECT_NAME}
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        FileSystem
        KML
        Shape
)

#===========================================================================#

CPMAddPackage(
    NAME Shapelib
    VERSION 1.6.1
    # GITHUB_REPOSITORY OSGeo/shapelib
    URL "file://${CMAKE_SOURCE_DIR}/external/shapelib-1.6.1.zip"
    OPTIONS
        "BUILD_SHAPELIB_CONTRIB OFF"
        "BUILD_APPS OFF"
        "BUILD_TESTING OFF"
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE shp)

CPMAddPackage(
    NAME zlib
    # GITHUB_REPOSITORY madler/zlib
    # GIT_TAG develop
    URL "file://${CMAKE_SOURCE_DIR}/external/zlib.zip"
    OPTIONS
        "ZLIB_BUILD_TESTING OFF"
        "ZLIB_BUILD_SHARED OFF"
        "ZLIB_BUILD_STATIC ON"
        "ZLIB_BUILD_MINIZIP OFF"
        "ZLIB_INSTALL OFF"
        "ZLIB_PREFIX OFF"
        "${ZLIB_EXTRA_OPTIONS}"
)

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ZLIB::ZLIBSTATIC)

#===========================================================================#

# add_subdirectory(Audio)
add_subdirectory(Geo)
