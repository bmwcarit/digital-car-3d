#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision highp float;

uniform vec3 u_BaseColor;
uniform float u_Opacity;

#if defined(HAS_ALPHAMAP) || defined(HAS_COLORMAP)
    in vec2 v_TextureCoordinate;

    #if defined(HAS_ALPHAMAP)
        uniform sampler2D u_AlphaMap;

        #if defined(HAS_ALPHACUTOFF)
            uniform float u_AlphaCutoffIntensity;
        #endif
    #endif

    #if defined(HAS_COLORMAP)
        uniform sampler2D u_BaseColorMap;
    #endif
#endif

out vec4 FragColor;


void main()
{
    vec4 col = vec4(1.0); // Generate temporary variable to change BaseColor in optional define codes

    #if defined(HAS_COLORMAP) // Use Color Texture for your model
        vec4 tex_color = texture(u_BaseColorMap, v_TextureCoordinate);
        col.rgb *= tex_color.rgb;
    #endif

    #if defined(HAS_ALPHAMAP) // Use an Alpha Mask for transparency
        vec4 tex_alpha = texture(u_AlphaMap, v_TextureCoordinate);
        col.a *= tex_alpha.r;

        #if defined(HAS_ALPHACUTOFF) // Flatten Alpha visibility to simple cutoff value
            col.a =  step(u_AlphaCutoffIntensity, col.a);
        #endif
    #endif

    FragColor.rgb = u_BaseColor.rgb * col.rgb;
    FragColor.a = u_Opacity * col.a;
}
