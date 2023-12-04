import QtQuick 2.12
import QtQuick.Window 2.12 as QQ2

import QtQuick.Scene3D 2.12

import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0
import Qt3D.Render 2.0

QQ2.Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Scene3D{
        id: scene3d
        anchors.fill: parent
        aspects: ["logic","render","input"]
        Entity{
            id: entity_root
            Camera {
                id: camera
                projectionType: CameraLens.PerspectiveProjection
                fieldOfView: 45
                aspectRatio: 16/9
                nearPlane : 0.1
                farPlane : 1000.0
                position: Qt.vector3d( 0.0, 0.0, -40.0 )
                upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
                viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
            }

            OrbitCameraController {
                camera: camera
            }

            components: [
                RenderSettings {
                    activeFrameGraph: ForwardRenderer {
                        clearColor: Qt.rgba(0, 0.5, 1, 1)
                        camera: camera
                    }
                },
                // Event Source will be set by the Qt3DQuickWindow
                InputSettings { }
            ]

            Tetrahedron{
                id: tetrahedron
            }

        }

    }

}
