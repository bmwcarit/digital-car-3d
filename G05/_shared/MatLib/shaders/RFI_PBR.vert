#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Parts taken https://github.com/bwasty/gltf-viewer/blob/master/src/shaders/pbr-vert.glsl and reworked
Copyright (c) 2016-2017 Mohamad Moneimne and Contributors
Published under MIT license.

Originally taken from https://github.com/KhronosGroup/glTF-WebGL-PBR
Commit a94655275e5e4e8ae580b1d95ce678b74ab87426
Published under Apache 2.0 license.
*/

precision highp float;

#define HAS_NORMALS
#define HAS_COLORS

in vec3 a_Position;

#if defined(HAS_NORMALS)
    in vec3 a_Normal;

    #if defined(HAS_TANGENTS)
        in vec3 a_Tangent;
        out mat3 v_TBN;
    #else
        out vec3 v_Normal;
    #endif
#endif

#if defined(HAS_COLORS)
    in vec4 a_Color; // COLOR_0
#endif

#if defined(HAS_UV)
    in vec2 a_TextureCoordinate; // TEXCOORD_0
    // Offset & Tiling
    uniform vec2 uv_Tiling;
    uniform vec2 uv_Offset;
#endif


uniform mat4 u_MVPMatrix; // u_ModelViewProjectionMatrix
uniform mat4 u_MMatrix; // u_ModelMatrix

uniform vec3 rotation;
uniform ivec3 u_mirror;

uniform float flipNormal;

out vec3 v_Position;
out vec4 v_Color;
out vec2 v_TextureCoordinate;


// Degree to radian and returns cosinus and sinus of this radian
vec2 RCS(float deg)
{
    float angle = radians(deg);
    return vec2(cos(angle), sin(angle));
}


mat4 rotAll(vec3 angles)
{
    vec2 radX = RCS(angles.x);
    vec2 radY = RCS(angles.y);
    vec2 radZ = RCS(angles.z);

    mat4 matX = mat4(   1, 0, 0, 0,
                        0, radX.x, -radX.y, 0,
                        0, radX.y, radX.x, 0,
                        0, 0, 0, 1);

    mat4 matY = mat4(   radY.x, 0, radY.y, 0,
                        0, 1, 0, 0,
                        -radY.y, 0, radY.x, 0,
                        0, 0, 0, 1);

    mat4 matZ = mat4(   radZ.x, -radZ.y, 0, 0,
                        radZ.y, radZ.x, 0, 0,
                        0, 0, 1, 0,
                        0, 0, 0, 1);

    return matX * matY * matZ;
}


void main()
{
    vec3 mirror = vec3(1.0);
    vec3 miNor = vec3(1.0);

    if (gl_InstanceID > 0 && u_mirror != ivec3(0.0))
    {
        mirror.x *= (u_mirror.x != 0) ? -1.0 : 1.0;
        mirror.y *= (u_mirror.y != 0) ? -1.0 : 1.0;
        mirror.z *= (u_mirror.z != 0) ? -1.0 : 1.0;
        miNor = vec3(-1.0, -1.0, 1.0);
    }

    mat4 rot = rotAll(vec3(0.0) * float(gl_InstanceID));

    vec4 pos = u_MMatrix * rot * vec4(a_Position * mirror, 1.0);
    v_Position = pos.xyz;

    #if defined(HAS_NORMALS)
        #if defined(HAS_TANGENTS)
            vec3 normalW = normalize(vec3(u_MMatrix * vec4(a_Normal * miNor, 0.0)));
            vec3 tangentW = normalize(vec3(u_MMatrix * vec4(a_Tangent, 0.0)));
            vec3 bitangentW = cross(normalW, tangentW);
            v_TBN = mat3(tangentW, bitangentW, normalW);
            v_TBN *= 2.0 * flipNormal + 1.0;
        #else
            v_Normal = normalize(vec3(u_MMatrix * rot * vec4(a_Normal * miNor, 0.0)));
            #if defined(FLIP_NORMAL)
                v_Normal *= -1.0;
            #endif
            v_Normal *= 2.0 * flipNormal + 1.0;
        #endif
    #endif

    #if defined(HAS_UV)
        v_TextureCoordinate = a_TextureCoordinate * uv_Tiling + uv_Offset;
    #endif

    #if defined(HAS_COLORS)
        v_Color = a_Color;
    #else
        v_Color = vec4(1.0); // Use 'white' if the mesh has no Vertex Colors
    #endif

    gl_Position = u_MVPMatrix * rot * vec4(a_Position * mirror, 1.0);
}
