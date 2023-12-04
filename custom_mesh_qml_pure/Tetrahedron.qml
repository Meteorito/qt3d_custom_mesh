// import QtQuick 2.2

import Qt3D.Core 2.0
import Qt3D.Extras 2.0
import Qt3D.Input 2.0
import Qt3D.Logic 2.0
import Qt3D.Render 2.0

import QtQml 2.0

Entity {
    /*          2
               /|\
              / | \
             / /3\ \
             0/___\ 1
    */
    id:control
    property int floatSize: 4
    property vector3d v0: Qt.vector3d(-1.0, 0.0, -1.0)
    property vector3d v1: Qt.vector3d( 1.0, 0.0, -1.0)
    property vector3d v2: Qt.vector3d( 0.0, 1.0,  0.0)
    property vector3d v3: Qt.vector3d( 0.0, 0.0,  1.0)

    property vector3d red:   Qt.vector3d(1.0, 0.0, 0.0)
    property vector3d green: Qt.vector3d(0.0, 1.0, 0.0)
    property vector3d blue:  Qt.vector3d(0.0, 0.0, 1.0)
    property vector3d white: Qt.vector3d(1.0, 1.0, 1.0)

    // Faces Normals
    property vector3d n023: __normal(v0,v2,v3)
    property vector3d n012: __normal(v0,v1,v2)
    property vector3d n310: __normal(v3,v1,v0)
    property vector3d n132: __normal(v1,v3,v2)

    // Vector Normals
    property vector3d n0: __calcuNormals(n023 ,n012 ,n310)
    property vector3d n1: __calcuNormals(n132 ,n012 ,n310)
    property vector3d n2: __calcuNormals(n132 ,n012 ,n023)
    property vector3d n3: __calcuNormals(n132 ,n310 ,n023)

    function __normal(v_0,v_1,v_2){
        var v_a = v_1.minus( v_0)
        var v_b = v_2.minus( v_0)

        var v_c = v_a.crossProduct(v_b)
        return v_c.normalized()
    }

    function __calcuNormals(v_0,v_1,v_2){
        var v = v_0.plus(v_1).plus( v_2)
        return v.normalized()
    }

    components: [geometry_render, color_material,transform]

    GeometryRenderer{
        id:geometry_render
        instanceCount: 1
        firstVertex: 0
        firstInstance: 0
        geometry: geometry
        primitiveType: GeometryRenderer.Triangles
        vertexCount: 3*4
    }
    Geometry{
        id:geometry
        attributes: [
            position_attribute,
            color_attribute,
            normal_attribute,
            index_attribute
        ]
    }
    /*
    Int8Array	-128 到 127	1	8 位有符号整型（补码）	byte	int8_t
    Uint8Array	0 到 255	1	8 位无符号整型	octet	uint8_t
    Uint8ClampedArray	0 到 255	1	8 位无符号整型（一定在 0 到 255 之间）	octet	uint8_t
    Int16Array	-32768 到 32767	2	16 位有符号整型（补码）	short	int16_t
    Uint16Array	0 到 65535	2	16 位无符号整型	unsigned short	uint16_t
    Int32Array	-2147483648 到 2147483647	4	32 位有符号整型（补码）	long	int32_t
    Uint32Array	0 到 4294967295	4	32 位无符号整型	unsigned long	uint32_t
    Float32Array	-3.4E38 到 3.4E38 并且 1.2E-38 是最小的正数	4	32 位 IEEE 浮点数（7 位有效数字，例如 1.234567）	unrestricted float	float
    Float64Array	-1.8E308 到 1.8E308 并且 5E-324 是最小的正数	8	64 位 IEEE 浮点数（16 位有效数字，例如 1.23456789012345）	unrestricted double	double
    BigInt64Array	-263 到 263 - 1	8	64 位有符号整型（补码）	bigint	int64_t (signed long long)
    BigUint64Array (en-US)	0 到 264 - 1	8	64 位无符号整型	bigint	uint64_t (unsigned long long)
    **/
    Buffer{
        id:vertex_buffer
        type: BufferBase.VertexBuffer
        data: new Float32Array(
                  [
                      v0.x, v0.y, v0.z,
                      n0.x, n0.y, n0.z,
                      red.x, red.y, red.z,

                      v1.x, v1.y, v1.z,
                      n1.x, n1.y, n1.z,
                      blue.x, blue.y, blue.z,

                      v2.x, v2.y, v2.z,
                      n2.x, n2.y, n2.z,
                      green.x, green.y, green.z,

                      v3.x, v3.y, v3.z,
                      n3.x, n3.y, n3.z,
                      white.x, white.y, white.z
                  ])
    }
    Buffer{
        id: index_buffer
        type: BufferBase.IndexBuffer
        data:new Uint16Array(
                  [
                      0, 1, 2,
                      3, 1, 0,
                      0, 2, 3,
                      1, 3, 2
                  ])
    }

    Attribute{
        id: position_attribute
        attributeType: Attribute.VertexAttribute
        buffer: vertex_buffer
        vertexBaseType: Attribute.Float
        vertexSize: 3  //vector3d
        byteOffset:  0
        byteStride: (3 + 3 + 3)*floatSize
        count: 4
        name:defaultPositionAttributeName

    }

    Attribute{
        id: normal_attribute
        buffer: vertex_buffer
        attributeType: Attribute.VertexAttribute
        vertexBaseType: Attribute.Float
        vertexSize: 3  //vector3d
        byteOffset:  (0 + 3)*floatSize
        byteStride: (3 + 3 + 3)*floatSize
        count: 4
        name: defaultNormalAttributeName
    }
    Attribute{
        id: color_attribute
        buffer: vertex_buffer
        attributeType: Attribute.VertexAttribute
        vertexBaseType: Attribute.Float
        vertexSize: 3  //vector3d
        byteOffset:  (0 + 3 + 3)*floatSize
        byteStride: (3 + 3 + 3)*floatSize
        count: 4
        name: defaultColorAttributeName
    }
    Attribute{
        id: index_attribute
        buffer: index_buffer
        attributeType: Attribute.IndexAttribute
        vertexBaseType: Attribute.UnsignedShort
        vertexSize: 1  //
        byteOffset: 0
        byteStride: 0
        count: 12
    }

    PerVertexColorMaterial{
        id:color_material
    }

    Transform {
        id: transform
        scale: 8.0
    }

}
