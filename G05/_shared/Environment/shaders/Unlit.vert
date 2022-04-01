#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision highp float;

uniform mat4 u_MVPMatrix;

in vec3 a_Position;

#if defined(HAS_ALPHAMAP) || defined(HAS_COLORMAP)
    in vec2 a_TextureCoordinate;
    out vec2 v_TextureCoordinate;
#endif


void main()
{
    #if defined(HAS_ALPHAMAP) || defined(HAS_COLORMAP)
        vec2 uv = a_TextureCoordinate;

        #if defined(HAS_UV_MIRRORED_U)
            uv.x *= 2.0;
        #endif
        #if defined(HAS_UV_MIRRORED_V)
            uv.y *= 2.0;
        #endif

        v_TextureCoordinate = uv;
    #endif

    gl_Position = u_MVPMatrix * vec4(a_Position.xyz, 1.0);
}
