# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)
project(qtmqtt LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Network)

set(CMAKE_CXX_STANDARD 20)

add_library(qtmqtt STATIC
    qmqttauthenticationproperties.cpp qmqttauthenticationproperties.h
    qmqttclient.cpp qmqttclient.h qmqttclient_p.h
    qmqttconnection.cpp qmqttconnection_p.h
    qmqttconnectionproperties.cpp qmqttconnectionproperties.h qmqttconnectionproperties_p.h
    qmqttcontrolpacket.cpp qmqttcontrolpacket_p.h
    qmqttglobal.h
    qmqttmessage.cpp qmqttmessage.h qmqttmessage_p.h
    qmqttpublishproperties.cpp qmqttpublishproperties.h qmqttpublishproperties_p.h
    qmqttsubscription.cpp qmqttsubscription.h qmqttsubscription_p.h
    qmqttsubscriptionproperties.cpp qmqttsubscriptionproperties.h
    qmqtttopicfilter.cpp qmqtttopicfilter.h
    qmqtttopicname.cpp qmqtttopicname.h
    qmqtttype.cpp qmqtttype.h
)

# Add include directories to simulate QtMqtt module structure
target_include_directories(qtmqtt PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_link_libraries(qtmqtt PRIVATE
    Qt6::Core
    Qt6::CorePrivate
    Qt6::Network
)
