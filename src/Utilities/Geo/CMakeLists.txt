target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        QGCGeo.cc
        QGCGeo.h
        QGCQGeoCoordinate.h
        QGCQGeoCoordinate.cc
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
