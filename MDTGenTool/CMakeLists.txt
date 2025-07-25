cmake_minimum_required(VERSION 3.16)

project(MDTGenTool VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)
find_package(Qt6 REQUIRED COMPONENTS Core)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appMDTGenTool
    main.cpp
)

qt_add_qml_module(appMDTGenTool
    URI MDTGenTool
    VERSION 1.0
    QML_FILES
        Main.qml
        SOURCES mdtgentool.h mdtgentool.cpp
        SOURCES
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appMDTGenTool PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appMDTGenTool
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appMDTGenTool
    PRIVATE Qt6::Quick
)
target_link_libraries(appMDTGenTool PRIVATE Qt6::Core)

include(GNUInstallDirs)
install(TARGETS appMDTGenTool
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
