target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        GimbalController.h
        GimbalController.cpp
        Protocols/DytProtocol.h
        Protocols/DytProtocol.cpp
        Protocols/GenericProtocol.h
        Protocols/GenericProtocol.cpp
        Protocols/IGimbalProtocol.h
        Link/ClientFactory.h
        Link/ClientFactory.cpp
        Link/GimbalLinkClient.h
        Link/GimbalTcpClient.h
        Link/GimbalTcpClient.cpp
        Link/GimbalUartClient.h
        Link/GimbalUartClient.cpp
        Link/GimbalUdpClient.h
        Link/GimbalUdpClient.cpp
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})

