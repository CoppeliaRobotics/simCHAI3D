QT -= core
QT -= gui

TARGET = simExtCHAI3D
TEMPLATE = lib

DEFINES -= UNICODE
DEFINES += QT_COMPIL
CONFIG += shared

INCLUDEPATH += "../include"

*-msvc* {
    QMAKE_CXXFLAGS += -O2
    QMAKE_CXXFLAGS += -W3
}
*-g++* {
    QMAKE_CXXFLAGS += -O3
    QMAKE_CXXFLAGS += -Wall
    QMAKE_CXXFLAGS += -Wno-unused-parameter
    QMAKE_CXXFLAGS += -Wno-strict-aliasing
    QMAKE_CXXFLAGS += -Wno-empty-body
    QMAKE_CXXFLAGS += -Wno-write-strings

    QMAKE_CXXFLAGS += -Wno-unused-but-set-variable
    QMAKE_CXXFLAGS += -Wno-unused-local-typedefs
    QMAKE_CXXFLAGS += -Wno-narrowing

    QMAKE_CFLAGS += -O3
    QMAKE_CFLAGS += -Wall
    QMAKE_CFLAGS += -Wno-strict-aliasing
    QMAKE_CFLAGS += -Wno-unused-parameter
    QMAKE_CFLAGS += -Wno-unused-but-set-variable
    QMAKE_CFLAGS += -Wno-unused-local-typedefs
}

win32 {
    DEFINES += WIN_SIM
    DEFINES += M_PI 3.14159265358979323846
    INCLUDEPATH += "e:/chai3d-3.2.0/external/Eigen"
    INCLUDEPATH += "e:/chai3d-3.2.0/external/glew/include"
    INCLUDEPATH += "e:/chai3d-3.2.0/src"
    LIBS += "e:/chai3d-3.2.0/lib/Release/x64/chai3d.lib"
    LIBS += opengl32.lib
    LIBS += glu32.lib
    LIBS += User32.lib
    LIBS += Winmm.lib
    LIBS += Ole32.lib
    LIBS += Shell32.lib
}

macx {
    DEFINES += MAC_SIM
    DEFINES += MACOSX # for CHAI3D
    INCLUDEPATH += "../../../chai3d-3.2.0/src"
    INCLUDEPATH += "/usr/local/include/eigen3"
    LIBS += -framework GLUT -framework OpenGL
    LIBS += "../../../chai3d-3.2.0/build/libchai3d.a"
}

unix:!macx {
    DEFINES += LIN_SIM
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/lib
    } else {
        target.path = /usr/lib
    }
    INSTALLS += target
}

HEADERS += \
    simExtCHAI3D.h \
    ../include/simLib/scriptFunctionData.h \
    ../include/simLib/scriptFunctionDataItem.h \
    ../include/simLib/simLib.h

SOURCES += \
    simExtCHAI3D.cpp \
    ../include/simLib/scriptFunctionData.cpp \
    ../include/simLib/scriptFunctionDataItem.cpp \
    ../include/simLib/simLib.cpp

