target_sources(${CMAKE_PROJECT_NAME}
    PRIVATE
        AppSettings.cc
        AppSettings.h
        FlightMapSettings.cc
        FlightMapSettings.h
        SettingsGroup.cc
        SettingsGroup.h
        SettingsManager.cc
        SettingsManager.h
        UnitsSettings.cc
        UnitsSettings.h
        VideoSettings.cc
        VideoSettings.h
        MapsSettings.cc
        MapsSettings.h
)

target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
