
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
qt_add_library(VKServerModule STATIC)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE VKServerModuleplugin)
qt_add_qml_module(VKServerModule
    URI VKServer
    VERSION 1.0
    RESOURCE_PREFIX /qml
    # QML 文件
    QML_FILES
        LoginRegisterPopup.qml
        CustomTextEdit.qml
        Login.qml
        Register.qml
        ChangePassword.qml
)
