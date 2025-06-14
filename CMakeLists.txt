cmake_minimum_required(VERSION 3.25)

list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake
    ${CMAKE_SOURCE_DIR}/cmake/modules
    ${CMAKE_SOURCE_DIR}/cmake/find-modules
)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug;Release")
endif()

set(CMAKE_REQUIRED_QUIET ON)
set(CMAKE_POLICY_VERSION_MINIMUM 3.15)

#######################################################
#                Custom Build Configuration
#######################################################

add_definitions(
    -DVK_USER_ID=""
    -DVK_SDK_LICENSE=""
)

include(CustomOptions)

if(IS_DIRECTORY ${CMAKE_SOURCE_DIR}/custom)
    message(STATUS "Enabling custom build")
    set(QGC_CUSTOM_BUILD ON)
    list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/custom/cmake)
    include(CustomOverrides)
endif()

#######################################################
#                   Project Info
#######################################################

# include(Prechecks)

# include(Git)

project(${QGC_APP_NAME}
    VERSION ${QGC_APP_VERSION}
    DESCRIPTION ${QGC_APP_DESCRIPTION}
    HOMEPAGE_URL ${QGC_ORG_DOMAIN}
    LANGUAGES C CXX
)

#######################################################
#            CMake Configuration Options
#######################################################

include(GNUInstallDirs)
include(FetchContent)
include(CMakePrintHelpers)
include(CPM)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_COLOR_DIAGNOSTICS ON)
# set(CMAKE_EXPORT_BUILD_DATABASE ON) # Causes Configuration Error?
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
# set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)

if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if(LINUX)
        set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE "${CMAKE_BINARY_DIR}/AppDir/usr")
    else()
        set_property(CACHE CMAKE_INSTALL_PREFIX PROPERTY VALUE "${CMAKE_BINARY_DIR}/staging")
    endif()
endif()

if(QGC_USE_CACHE)
    if(CMAKE_HOST_UNIX)
        find_program(CCACHE_PROGRAM ccache)
        if(CCACHE_PROGRAM)
            message(STATUS "Using CCache")
            set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_C_LINKER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
            set(CMAKE_CXX_LINKER_LAUNCHER "${CCACHE_PROGRAM}")
        endif()
    elseif(CMAKE_HOST_WIN32)
        find_program(SCCACHE_PROGRAM sccache)
        if(SCCACHE_PROGRAM)
            message(STATUS "Using SCCache")
            set(CMAKE_C_COMPILER_LAUNCHER "${SCCACHE_PROGRAM}")
            # set(CMAKE_C_LINKER_LAUNCHER "${SCCACHE_PROGRAM}")
            set(CMAKE_CXX_COMPILER_LAUNCHER "${SCCACHE_PROGRAM}")
            # set(CMAKE_CXX_LINKER_LAUNCHER "${SCCACHE_PROGRAM}")
        endif()
    endif()
endif()

if(MSVC)
    set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT Embedded)
endif()

if(CMAKE_CROSSCOMPILING)
    if(ANDROID)
        set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
        set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
        set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)
    endif()

    if(NOT IS_DIRECTORY ${QT_HOST_PATH})
        message(FATAL_ERROR "You need to set QT_HOST_PATH to cross compile Qt.")
    endif()
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIGURATION>/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIGURATION>)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIGURATION>)

# https://cmake.org/cmake/help/latest/policy/CMP0168.html#policy:CMP0168
if(POLICY CMP0168)
    cmake_policy(SET CMP0168 NEW)
    set(CMAKE_POLICY_DEFAULT_CMP0168 NEW)
endif()

# https://cmake.org/cmake/help/latest/policy/CMP0075.html#policy:CMP0075
if(POLICY CMP0075)
    cmake_policy(SET CMP0075 NEW)
    set(CMAKE_POLICY_DEFAULT_CMP0075 NEW)
endif()

#######################################################
#               Qt6 Configuration
#######################################################

find_package(Qt6
    REQUIRED
    COMPONENTS
        # Charts
        Concurrent
        Core
        Gui
        # LinguistTools
        Location
        Multimedia
        Network
        OpenGL
        Positioning
        Qml
        QmlIntegration
        Quick
        QuickControls2
        QuickWidgets
        Sql
        Svg
        # TextToSpeech
        Widgets
        Xml
    OPTIONAL_COMPONENTS
        MultimediaQuickPrivate
        Quick3D
        SerialPort
        Test
)

if(LINUX)
    find_package(Qt6 COMPONENTS WaylandClient)
endif()

# Set extra standard project setup options for Qt 6.7.0 and above
set(EXTRA_STANDARD_PROJECT_SETUP_OPTIONS)
if(Qt6_VERSION VERSION_GREATER_EQUAL 6.7.0)
    list(APPEND EXTRA_STANDARD_PROJECT_SETUP_OPTIONS I18N_SOURCE_LANGUAGE en)
endif()

qt_standard_project_setup(
    REQUIRES ${QGC_QT_MINIMUM_VERSION}
    SUPPORTS_UP_TO ${QGC_QT_MAXIMUM_VERSION}
    ${EXTRA_STANDARD_PROJECT_SETUP_OPTIONS}
)

qt_policy(
    SET QTP0001 NEW
    SET QTP0002 NEW
    SET QTP0003 NEW
    SET QTP0004 NEW
    SET QTP0005 NEW
)

#######################################################
#                QGroundControl Options
#######################################################

if(CMAKE_BUILD_TYPE STREQUAL "Release")
    add_compile_definitions(
        NDEBUG
        QT_NO_DEBUG
    )
else()
    add_compile_definitions(
        QT_DISABLE_DEPRECATED_UP_TO=0x060800
        QT_ENABLE_STRICT_MODE_UP_TO=0x060800
        $<$<BOOL:${QGC_DEBUG_QML}>:QT_QML_DEBUG>
    )
endif()

if(NOT QGC_BUILD_TESTING)
    set(BUILD_TESTING OFF CACHE INTERNAL "" FORCE)
endif()

#######################################################
#                Custom Build Configuration
#######################################################

if(QGC_CUSTOM_BUILD)
    add_subdirectory(custom)
endif()

#######################################################
#                QGroundControl Resources
#######################################################

# Note: Adding Resources to Library instead requires using Q_INIT_RESOURCE(qgcresources)

if(NOT QGC_CUSTOM_BUILD)
    # Custom builds can override the resources
    list(APPEND QGC_RESOURCES
        ${CMAKE_SOURCE_DIR}/qgcimages.qrc
        ${CMAKE_SOURCE_DIR}/qgcresources.qrc
        ${CMAKE_SOURCE_DIR}/qgroundcontrol.qrc
    )
endif()

#######################################################
#               QGroundControl Target
#######################################################

qt_add_executable(${CMAKE_PROJECT_NAME}
    WIN32
    ${QGC_RESOURCES}
)

if(WIN32)

    message(STATUS "WIN32")

    # windows installer files shared with core and custom
    set(DEPLOY_WIN_FILES
        "${CMAKE_SOURCE_DIR}/deploy/windows/driver.msi"
        "${CMAKE_SOURCE_DIR}/deploy/windows/nullsoft_installer.nsi"
        "${QGC_WINDOWS_RESOURCE_FILE_PATH}"
        "${QGC_WINDOWS_INSTALL_HEADER_PATH}"
        "${QGC_WINDOWS_ICON_PATH}"
    )

    # Destination directory where files will be copied
    set(QGC_INSTALLER_SOURCE_WIN "${CMAKE_BINARY_DIR}/deploy/windows")
    file(MAKE_DIRECTORY ${QGC_INSTALLER_SOURCE_WIN})
    foreach(FILE ${DEPLOY_WIN_FILES})
        # filename without the path
        get_filename_component(FILE_NAME ${FILE} NAME)
        # re-copy the file if it changes
        add_custom_command(
            OUTPUT "${QGC_INSTALLER_SOURCE_WIN}/${FILE_NAME}"
            COMMAND ${CMAKE_COMMAND} -E copy_if_different "${FILE}" "${QGC_INSTALLER_SOURCE_WIN}/${FILE_NAME}"
            DEPENDS "${FILE}"  # Depend on the source file so that it re-copies when it changes
        )
        list(APPEND QGC_INSTALLER_SOURCE_WIN_FILES "${QGC_INSTALLER_SOURCE_WIN}/${FILE_NAME}")
    endforeach()

    target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${QGC_INSTALLER_SOURCE_WIN_FILES})
    set_target_properties(${CMAKE_PROJECT_NAME}
        PROPERTIES
            WIN32_EXECUTABLE TRUE
            # QT_TARGET_WINDOWS_RC_FILE "${QGC_WINDOWS_RESOURCE_FILE_PATH}"
            QT_TARGET_COMPANY_NAME "${QGC_ORG_NAME}"
            QT_TARGET_DESCRIPTION "${CMAKE_PROJECT_DESCRIPTION}"
            QT_TARGET_VERSION "${CMAKE_PROJECT_VERSION}"
            QT_TARGET_COPYRIGHT "${QGC_APP_COPYRIGHT}"
            QT_TARGET_PRODUCT_NAME "${CMAKE_PROJECT_NAME}"
            # QT_TARGET_COMMENTS: RC Comments
            # QT_TARGET_ORIGINAL_FILENAME: RC Original FileName
            # QT_TARGET_TRADEMARKS: RC LegalTrademarks
            # QT_TARGET_INTERNALNAME: RC InternalName
            QT_TARGET_RC_ICONS "${QGC_WINDOWS_ICON_PATH}"
    )
    target_compile_definitions(${CMAKE_PROJECT_NAME} PRIVATE _USE_MATH_DEFINES)
elseif(APPLE)
    if(CMAKE_GENERATOR STREQUAL "Xcode")
        # set(CMAKE_XCODE_ATTRIBUTE_DEVELOPMENT_TEAM
        # set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_STYLE
        # set(CMAKE_XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER
        # set(CMAKE_XCODE_ATTRIBUTE_INSTALL_PATH
        # set(CMAKE_XCODE_ATTRIBUTE_DEBUG_INFORMATION_FORMAT
        # set(CMAKE_XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS
        # set(CMAKE_XCODE_ATTRIBUTE_LD_ENTRY_POINT
        # set(CMAKE_XCODE_ATTRIBUTE_MARKETING_VERSION
        # set(CMAKE_XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION
        set(CMAKE_XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "${QGC_MACOS_ENTITLEMENTS_PATH}")
    endif()

    set_target_properties(${CMAKE_PROJECT_NAME}
        PROPERTIES
            MACOSX_BUNDLE TRUE
            MACOSX_BUNDLE_INFO_PLIST "${QGC_MACOS_PLIST_PATH}"
            MACOSX_BUNDLE_BUNDLE_NAME "${CMAKE_PROJECT_NAME}"
            MACOSX_BUNDLE_BUNDLE_VERSION "${CMAKE_PROJECT_VERSION}"
            MACOSX_BUNDLE_COPYRIGHT "${QGC_APP_COPYRIGHT}"
            MACOSX_BUNDLE_GUI_IDENTIFIER "${QGC_MACOS_BUNDLE_ID}"
            MACOSX_BUNDLE_ICON_FILE "${MACOSX_BUNDLE_ICON_FILE}"
            MACOSX_BUNDLE_INFO_STRING "${CMAKE_PROJECT_DESCRIPTION}"
            MACOSX_BUNDLE_LONG_VERSION_STRING "${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}.${CMAKE_PROJECT_VERSION_PATCH}"
            MACOSX_BUNDLE_SHORT_VERSION_STRING "${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}"
    )

    if(MACOS)
        set(MACOSX_BUNDLE_ICON_FILE "macx.icns")
        set(app_icon_macos "${QGC_MACOS_ICON_PATH}/${MACOSX_BUNDLE_ICON_FILE}")
        set_source_files_properties(${app_icon_macos} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
        target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${app_icon_macos})

        set_source_files_properties(${QGC_MACOS_ENTITLEMENTS_PATH} PROPERTIES MACOSX_PACKAGE_LOCATION "Resources")
        target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${QGC_MACOS_ENTITLEMENTS_PATH})
    elseif(IOS)
        enable_language(OBJC)

        set(QT_IOS_LAUNCH_SCREEN "${CMAKE_SOURCE_DIR}/deploy/ios/QGCLaunchScreen.xib")

        # set(CMAKE_XCODE_ATTRIBUTE_ARCHS
        # set(CMAKE_XCODE_ATTRIBUTE_ENABLE_BITCODE
        set(CMAKE_XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "14.0")
        set(CMAKE_XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2") # iPhone,iPad
        set(CMAKE_XCODE_ATTRIBUTE_INFOPLIST_FILE "${CMAKE_SOURCE_DIR}/deploy/ios/iOS-Info.plist")

        set_target_properties(${CMAKE_PROJECT_NAME}
            PROPERTIES
                QT_IOS_LAUNCH_SCREEN "${CMAKE_SOURCE_DIR}/deploy/ios/QGCLaunchScreen.xib"
                XCODE_ATTRIBUTE_PRODUCT_BUNDLE_IDENTIFIER "${QGC_PACKAGE_NAME}"
                XCODE_ATTRIBUTE_PRODUCT_NAME "${CMAKE_PROJECT_NAME}"
                XCODE_ATTRIBUTE_CURRENT_PROJECT_VERSION ${CMAKE_PROJECT_VERSION}
                XCODE_ATTRIBUTE_MARKETING_VERSION "${CMAKE_PROJECT_VERSION_MAJOR}.${CMAKE_PROJECT_VERSION_MINOR}"
                XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon"
                XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "14.0"
                XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2" # iPhone,iPad
                XCODE_ATTRIBUTE_INFOPLIST_KEY_CFBundleDisplayName ${CMAKE_PROJECT_NAME}
                XCODE_ATTRIBUTE_INFOPLIST_KEY_LSApplicationCategoryType "public.app-category.mycategory"
                XCODE_ATTRIBUTE_GCC_GENERATE_DEBUGGING_SYMBOLS "YES"
        )
        qt_add_ios_ffmpeg_libraries(${CMAKE_PROJECT_NAME})
    endif()

elseif(ANDROID)
    CPMAddPackage(
        NAME android_openssl
        URL "file://${CMAKE_SOURCE_DIR}/external/android_openssl.zip"
        # URL https://github.com/KDAB/android_openssl/archive/refs/heads/master.zip
    )
    include(${android_openssl_SOURCE_DIR}/android_openssl.cmake)
    add_android_openssl_libraries(${CMAKE_PROJECT_NAME})

    # Generation of android version numbers must be consistent release to release such that they are always increasing
    if(${PROJECT_VERSION_MAJOR} GREATER 9)
        message(FATAL_ERROR "Major version larger than 1 digit: ${CMAKE_PROJECT_VERSION_MAJOR}")
    endif()
    if(${PROJECT_VERSION_MINOR} GREATER 9)
        message(FATAL_ERROR "Minor version larger than 1 digit: ${CMAKE_PROJECT_VERSION_MINOR}")
    endif()
    if(${PROJECT_VERSION_PATCH} GREATER 99)
        message(FATAL_ERROR "Patch version larger than 2 digits: ${CMAKE_PROJECT_VERSION_PATCH}")
    endif()

    # Bitness for android version number is 66/34 instead of 64/32 in because of a required version number bump screw-up ages ago
    set(ANDROID_BITNESS_CODE)
    if(${CMAKE_ANDROID_ARCH_ABI} STREQUAL "armeabi-v7a" OR ${CMAKE_ANDROID_ARCH_ABI} STREQUAL "x86")
        set(ANDROID_BITNESS_CODE 34)
    elseif(${CMAKE_ANDROID_ARCH_ABI} STREQUAL "arm64-v8a" OR ${CMAKE_ANDROID_ARCH_ABI} STREQUAL "x86_64")
        set(ANDROID_BITNESS_CODE 66)
    else()
        message(FATAL_ERROR "Unsupported Android ABI: ${CMAKE_ANDROID_ARCH_ABI}")
    endif()

    set(ANDROID_PATCH_VERSION ${CMAKE_PROJECT_VERSION_PATCH})
    if(${CMAKE_PROJECT_VERSION_PATCH} LESS 10)
        set(ANDROID_PATCH_VERSION "0${CMAKE_PROJECT_VERSION_PATCH}")
    endif()

    # Version code format: BBMIPPDDD (B=Bitness, M=Major, I=Minor, P=Patch, D=Dev) - Dev not currently supported and always 000
    set(ANDROID_VERSION_CODE "${ANDROID_BITNESS_CODE}${CMAKE_PROJECT_VERSION_MAJOR}${CMAKE_PROJECT_VERSION_MINOR}${ANDROID_PATCH_VERSION}000")
    message(STATUS "Android version code: ${ANDROID_VERSION_CODE}")

    set_target_properties(${CMAKE_PROJECT_NAME}
        PROPERTIES
            # QT_ANDROID_ABIS ${CMAKE_ANDROID_ARCH_ABI}
            # QT_ANDROID_SDK_BUILD_TOOLS_REVISION
            QT_ANDROID_MIN_SDK_VERSION ${QGC_QT_ANDROID_MIN_SDK_VERSION}
            QT_ANDROID_TARGET_SDK_VERSION ${QGC_QT_ANDROID_TARGET_SDK_VERSION}
            # QT_ANDROID_COMPILE_SDK_VERSION
            QT_ANDROID_PACKAGE_NAME "${QGC_ANDROID_PACKAGE_NAME}"
            QT_ANDROID_PACKAGE_SOURCE_DIR "${QGC_ANDROID_PACKAGE_SOURCE_DIR}"
            QT_ANDROID_VERSION_NAME "${CMAKE_PROJECT_VERSION}"
            QT_ANDROID_VERSION_CODE ${ANDROID_VERSION_CODE}
            # QT_ANDROID_APP_NAME
            # QT_ANDROID_APP_ICON
            # QT_QML_IMPORT_PATH
            QT_QML_ROOT_PATH ${CMAKE_SOURCE_DIR}
            # QT_ANDROID_SYSTEM_LIBS_PREFIX
    )

    # if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    #     set(QT_ANDROID_APPLICATION_ARGUMENTS)
    # endif()

    list(APPEND QT_ANDROID_MULTI_ABI_FORWARD_VARS QGC_STABLE_BUILD QT_HOST_PATH)
endif()

if(WIN32)
    # 优先级1：允许用户通过命令行参数显式指定路径
    if(NOT DEFINED GStreamer_ROOT_DIR)
        # 优先级2：检查标准环境变量
        set(_gst_env_vars
            GSTREAMER_1_0_ROOT
            GSTREAMER_1_0_ROOT_X86_64
            GSTREAMER_1_0_ROOT_MSVC_X86_64
        )

        foreach(_var IN LISTS _gst_env_vars)
            if(DEFINED ENV{${_var}} AND EXISTS $ENV{${_var}})
                set(GStreamer_ROOT_DIR $ENV{${_var}})
                cmake_path(CONVERT "${GStreamer_ROOT_DIR}" TO_CMAKE_PATH_LIST GStreamer_ROOT_DIR NORMALIZE)
                message(STATUS "Found GStreamer via env ${_var}: ${GStreamer_ROOT_DIR}")
                break()
            endif()
        endforeach()

        # 优先级3：自动探测常见安装位置
        if(NOT GStreamer_ROOT_DIR)
            set(_common_paths
                "D:/gstreamer/1.0/msvc_x86_64"  # 添加D盘路径
                "C:/gstreamer/1.0/msvc_x86_64"
                "C:/Program Files/gstreamer/1.0/msvc_x86_64"
                "$ENV{ProgramFiles}/gstreamer/1.0/msvc_x86_64"
            )

            foreach(_path IN LISTS _common_paths)
                if(EXISTS "${_path}")
                    set(GStreamer_ROOT_DIR "${_path}")
                    message(STATUS "Auto-detected GStreamer at: ${GStreamer_ROOT_DIR}")
                    break()
                endif()
            endforeach()
        endif()
    endif()

    # 路径验证
    if(NOT GStreamer_ROOT_DIR)
        message(FATAL_ERROR
            "GStreamer not found!\n"
            "Please do ONE of the following:\n"
            "1. Set GStreamer_ROOT_DIR via -DGStreamer_ROOT_DIR=<path>\n"
            "2. Define environment variable GSTREAMER_1_0_ROOT\n"
            "3. Install to default location D:/gstreamer/1.0/msvc_x86_64\n"
        )
    endif()

    # 配置pkg-config路径
    find_program(PKG_CONFIG_EXECUTABLE
        NAMES pkg-config.exe
        HINTS "${GStreamer_ROOT_DIR}/bin"
        NO_DEFAULT_PATH
        NO_CACHE
    )

    if(NOT PKG_CONFIG_EXECUTABLE)
        message(FATAL_ERROR
            "pkg-config.exe not found in:\n"
            "  ${GStreamer_ROOT_DIR}/bin\n"
            "Check your GStreamer installation!"
        )
    else()
        message(STATUS "Using pkg-config: ${PKG_CONFIG_EXECUTABLE}")
        set(PKG_CONFIG_EXECUTABLE "${PKG_CONFIG_EXECUTABLE}" CACHE FILEPATH "" FORCE)
    endif()

    find_package(PkgConfig REQUIRED)
endif()

target_compile_definitions(${CMAKE_PROJECT_NAME}
    PRIVATE
        QGC_APP_NAME="${QGC_APP_NAME}"
        QGC_ORG_NAME="${QGC_ORG_NAME}"
        QGC_ORG_DOMAIN="${QGC_ORG_DOMAIN}"
        QGC_APP_VERSION_STR="${QGC_APP_VERSION_STR}"
        QGC_SETTINGS_VERSION=${QGC_SETTINGS_VERSION}
        $<$<NOT:$<BOOL:${QGC_STABLE_BUILD}>>:QGC_DAILY_BUILD>
)

set_target_properties(${CMAKE_PROJECT_NAME}
    PROPERTIES
        QT_RESOURCE_PREFIX "/qgc"
        OUTPUT_NAME ${CMAKE_PROJECT_NAME}
)

# 添加vkqtsdk头文件目录
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/vkqtsdk/include
)

#######################################################
#           VKQTSdk Library Configuration
#######################################################

# 定义库查找函数
function(find_vkqtsdk_library)
    set(VKQTSDK_LIB_DIR "${CMAKE_CURRENT_SOURCE_DIR}/vkqtsdk/lib")

    # 确定库名称（Debug版本加'd'后缀）
    set(LIB_NAME "vkqtsdk")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(LIB_NAME_DEBUG "vkqtsdkd")
    endif()

    # 根据平台确定搜索路径和库扩展名
    if(WIN32)
        set(LIB_EXTENSIONS ".lib" ".dll")
        set(SEARCH_PATHS "${VKQTSDK_LIB_DIR}/windows")
    elseif(ANDROID)
        set(LIB_EXTENSIONS ".a" ".so")
        set(SEARCH_PATHS "${VKQTSDK_LIB_DIR}/android")
    elseif(UNIX)
        set(LIB_EXTENSIONS ".a" ".so")
        set(SEARCH_PATHS "${VKQTSDK_LIB_DIR}/linux")
    endif()

    # 查找库文件
    set(FOUND_LIBRARY "")
    foreach(SEARCH_PATH IN LISTS SEARCH_PATHS)
        foreach(EXT IN LISTS LIB_EXTENSIONS)
            # 优先查找Debug版本
            if(CMAKE_BUILD_TYPE STREQUAL "Debug" AND LIB_NAME_DEBUG)
                set(DEBUG_LIB "${SEARCH_PATH}/lib${LIB_NAME_DEBUG}${EXT}")
                if(WIN32)
                    set(DEBUG_LIB "${SEARCH_PATH}/${LIB_NAME_DEBUG}${EXT}")
                endif()
                if(EXISTS "${DEBUG_LIB}")
                    set(FOUND_LIBRARY "${DEBUG_LIB}")
                    break()
                endif()
            endif()

            # 查找Release版本或通用版本
            set(RELEASE_LIB "${SEARCH_PATH}/lib${LIB_NAME}${EXT}")
            if(WIN32)
                set(RELEASE_LIB "${SEARCH_PATH}/${LIB_NAME}${EXT}")
            endif()
            if(EXISTS "${RELEASE_LIB}")
                set(FOUND_LIBRARY "${RELEASE_LIB}")
                break()
            endif()
        endforeach()
        if(FOUND_LIBRARY)
            break()
        endif()
    endforeach()

    # 输出结果
    if(FOUND_LIBRARY)
        message(STATUS "Found VKQTSdk library: ${FOUND_LIBRARY}")
        set(VKQTSDK_LIBRARY "${FOUND_LIBRARY}" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "VKQTSdk library not found in ${VKQTSDK_LIB_DIR}")
    endif()
endfunction()

# 调用库查找函数
find_vkqtsdk_library()

# 链接找到的库文件
if(VKQTSDK_LIBRARY)
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ${VKQTSDK_LIBRARY})
endif()

target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE
    Qt6::Core
    # Qt6::Quick
    Qt6::Network
    Qt6::Qml
    Qt6::SerialPort
    Qt6::Positioning
)

add_subdirectory(src)

if(QGC_CUSTOM_BUILD)
    target_sources(${CMAKE_PROJECT_NAME} PRIVATE ${CUSTOM_SOURCES})
    target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ${CUSTOM_LIBRARIES})
    target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CUSTOM_DIRECTORIES})
endif()

target_precompile_headers(${CMAKE_PROJECT_NAME}
    PRIVATE
        <QtCore/QObject>
        <QtNetwork/QNetworkReply>
        <QtPositioning/QGeoCoordinate>
)

