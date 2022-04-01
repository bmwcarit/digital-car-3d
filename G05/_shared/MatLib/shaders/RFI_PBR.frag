#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

Parts taken https://github.com/bwasty/gltf-viewer/blob/master/src/shaders/pbr-frag.glsl and reworked
Copyright (c) 2016-2017 Mohamad Moneimne and Contributors
Published under MIT license.

In turn Originally taken from https://github.com/KhronosGroup/glTF-WebGL-PBR
Commit a94655275e5e4e8ae580b1d95ce678b74ab87426
Published under Apache 2.0 license.

This fragment shader defines a reference implementation for Physically Based Shading of
a microfacet surface material defined by a glTF model.

References:
[1] Real Shading in Unreal Engine 4
    http://blog.selfshadow.com/publications/s2013-shading-course/karis/s2013_pbs_epic_notes_v2.pdf
[2] Physically Based Shading at Disney
    http://blog.selfshadow.com/publications/s2012-shading-course/burley/s2012_pbs_disney_brdf_notes_v3.pdf
[3] README.md - Environment Maps
    https://github.com/KhronosGroup/glTF-WebGL-PBR/#environment-maps
[4] "An Inexpensive BRDF Model for Physically based Rendering" by Christophe Schlick
    https://www.cs.virginia.edu/~jdl/bib/appearance/analytic%20models/schlick94b.pdf
*/

precision highp float;

#define USE_IBL
#define HAS_NORMALS
#define HAS_COLORS

#if defined(USE_IBL)
    uniform samplerCube u_DiffuseEnvSampler;
    uniform samplerCube u_SpecularEnvSampler;
    uniform sampler2D u_brdfLUT;
#endif

#if defined(HAS_NORMALS)
    #if defined(HAS_TANGENTS)
        in mat3 v_TBN;
    #else
        in vec3 v_Normal;
    #endif
#endif

#if defined(USE_SHEEN)
    uniform float u_sheenRoughness;
    uniform float u_sheenScale;
#endif

#if defined(HAS_NORMALMAP)
    uniform sampler2D u_NormalSampler;
    uniform float u_NormalScale;
#endif


uniform vec3 u_CameraWorldPosition;

const float PI = 3.14159265359;
const float MIN_ROUGHNESS = 0.04;

uniform vec4 u_BaseColorFactor;
uniform vec3 u_EmissiveFactor; // Emission from the whole object
uniform vec2 u_MetallicRoughnessValues;

uniform float u_AlphaBlend;

#if defined(HAS_ALPHACUTOFF)
    uniform float u_AlphaCutoff;
#endif

uniform float u_ScaleIBLAmbient;

in vec3 v_Position;
in vec4 v_Color;
in vec2 v_TextureCoordinate;

out vec4 FragColor;


// Encapsulate the various inputs used by the various functions in the shading equation
// We store values in this struct to simplify the integration of alternative implementations
// of the shading terms, outlined in the Readme.MD Appendix.
struct PBRInfo
{
    float NdotL;                // cos angle between normal and light direction
    float NdotV;                // cos angle between normal and view direction
    float NdotH;                // cos angle between normal and half vector
    float LdotH;                // cos angle between light direction and half vector
    float VdotH;                // cos angle between view direction and half vector
    float perceptualRoughness;  // roughness value, as authored by the model creator (input to shader)
    float metalness;            // metallic value at the surface
    vec3 reflectance0;          // full reflectance color (normal incidence angle)
    vec3 reflectance90;         // reflectance color at grazing angle
    float alphaRoughness;       // roughness mapped to a more linear change in the roughness (proposed by [2])
    vec3 diffuseColor;          // color contribution from diffuse lighting
    vec3 specularColor;         // color contribution from specular lighting
};


// Find the normal for this fragment, pulling either from a predefined normal map
// or from the interpolated mesh normal and tangent attributes.
vec3 getNormal(float nscale)
{
    // Retrieve the tangent space matrix
    #ifndef HAS_TANGENTS
        vec3 pos_dx = dFdx(v_Position);
        vec3 pos_dy = dFdy(v_Position);
        vec3 tex_dx = dFdx(vec3(v_TextureCoordinate, 0.0));
        vec3 tex_dy = dFdy(vec3(v_TextureCoordinate, 0.0));
        vec3 t = (tex_dy.t * pos_dx - tex_dx.t * pos_dy) / (tex_dx.s * tex_dy.t - tex_dy.s * tex_dx.t);

        #if defined(HAS_NORMALS)
            vec3 ng = normalize(v_Normal);
        #else
            vec3 ng = cross(pos_dx, pos_dy);
        #endif

        t = normalize(t - ng * dot(ng, t));
        vec3 b = normalize(cross(ng, t));
        mat3 tbn = mat3(t, b, ng);

    #else
        mat3 tbn = v_TBN;
    #endif

    #if defined(HAS_NORMALMAP)
        vec3 n = texture(u_NormalSampler, v_TextureCoordinate).rgb;
        n = normalize(tbn * ((2.0 * n - 1.0) * vec3(u_NormalScale * nscale, u_NormalScale * nscale, 1.0)));
    #else
        vec3 n = normalize(tbn[2].xyz); // The tbn matrix is linearly interpolated, so we need to re-normalize
    #endif

    n *= (2.0 * float(gl_FrontFacing) - 1.0); // Reverse backfacing normals

    return n;
}


#if defined(USE_IBL) // #define is included in this shader; -> can never be false!

    // Calculation of the lighting contribution from an optional Image Based Light source.
    // Precomputed Environment Maps are required uniform inputs and are computed as outlined in [1].
    // See our README.md on Environment Maps [3] for additional discussion.

    vec3 GetIBLSpecular(PBRInfo pbrInputs, vec3 reflection, float roughness)
    {
        float iblExposure = 3.0;
        vec3 brdf = texture(u_brdfLUT, vec2(pbrInputs.NdotV, roughness)).rgb;

        float mipCount = 5.0;
        float lod = roughness * mipCount;
        vec3 specularLight = textureLod(u_SpecularEnvSampler, reflection,lod).rgb;

        specularLight *= vec3(iblExposure);
        vec3 specular = specularLight * (pbrInputs.specularColor * brdf.x + (brdf.y*1.2)); // boosting grazing angle reflection color
        specular *= u_ScaleIBLAmbient;
        return specular;
    }


    vec3 GetIBLDiffuse(PBRInfo pbrInputs, vec3 n)
    {
        vec3 diffuseLight = texture(u_DiffuseEnvSampler, n).rgb;
        vec3 diffuse = diffuseLight * pbrInputs.diffuseColor;
        return diffuse;
    }

#endif


// Basic Lambertian diffuse
// Implementation from Lambert's Photometria https://archive.org/details/lambertsphotome00lambgoog
// See also [1], Equation 1
vec3 diffuse(PBRInfo pbrInputs)
{
    return pbrInputs.diffuseColor / PI;
}


// The following equation models the Fresnel reflectance term of the spec equation (aka F())
// Implementation of fresnel from [4], Equation 15
vec3 specularReflection(PBRInfo pbrInputs)
{
    return pbrInputs.reflectance0 + (pbrInputs.reflectance90 - pbrInputs.reflectance0) * pow(clamp(1.0 - pbrInputs.VdotH, 0.0, 1.0), 5.0);
}


// This calculates the specular geometric attenuation (aka G()),
// where rougher material will reflect less light back to the viewer.
// This implementation is based on [1] Equation 4, and we adopt their modifications to
// alphaRoughness as input as originally proposed in [2].
float geometricOcclusion(PBRInfo pbrInputs)
{
    float NdotL = pbrInputs.NdotL;
    float NdotV = pbrInputs.NdotV;
    float r = pbrInputs.alphaRoughness;

    float attenuationL = 2.0 * NdotL / (NdotL + sqrt(r * r + (1.0 - r * r) * (NdotL * NdotL)));
    float attenuationV = 2.0 * NdotV / (NdotV + sqrt(r * r + (1.0 - r * r) * (NdotV * NdotV)));
    return attenuationL * attenuationV;
}


// The following equation(s) model the distribution of microfacet normals across the area being drawn (aka D())
// Implementation from "Average Irregularity Representation of a Roughened Surface for Ray Reflection" by T. S. Trowbridge, and K. P. Reitz
// Follows the distribution function recommended in the SIGGRAPH 2013 course notes from EPIC Games [1], Equation 3.
float microfacetDistribution(PBRInfo pbrInputs)
{
    float roughnessSq = pbrInputs.alphaRoughness * pbrInputs.alphaRoughness;
    float f = (pbrInputs.NdotH * roughnessSq - pbrInputs.NdotH) * pbrInputs.NdotH + 1.0;
    return roughnessSq / (PI * f * f);
}


float simpleBrightness(vec3 color)
{
    return (color.r + color.b + color.r) / 3.0;
}


void main()
{
    // Metallic and Roughness material properties are packed together
    float perceptualRoughness = u_MetallicRoughnessValues.y;
    float metallic = u_MetallicRoughnessValues.x;

    perceptualRoughness = clamp(perceptualRoughness, MIN_ROUGHNESS, 1.0);
    metallic = clamp(metallic, 0.0, 1.0);

    // Roughness is authored as perceptual roughness; as is convention,
    // convert to material roughness by squaring the perceptual roughness [2].
    float alphaRoughness = perceptualRoughness * perceptualRoughness;

    vec4 baseColor = u_BaseColorFactor; // Albedo as flat color
    baseColor *= v_Color; // Spec: COLOR_0 ... acts as an additional linear multiplier to baseColor (AO baked into Vertex Colors)

    vec3 f0 = vec3(MIN_ROUGHNESS);
    vec3 diffuseColor = baseColor.rgb * (vec3(1.0) - f0);
    diffuseColor *= 1.0 - metallic;
    vec3 specularColor = mix(f0, baseColor.rgb, metallic);

    float reflectance = max(max(specularColor.r, specularColor.g), specularColor.b); // Compute reflectance

    // For typical incident reflectance range (between 4% to 100%) set the grazing reflectance to 100% for typical fresnel effect
    // For very low reflectance range on highly diffuse objects (below 4%), incrementally reduce grazing reflecance to 0%
    float reflectance90 = clamp(reflectance * 25.0, 0.0, 1.0);
    vec3 specularEnvironmentR0 = specularColor.rgb;
    vec3 specularEnvironmentR90 = vec3(1.0, 1.0, 1.0) * reflectance90;

    vec3 n = getNormal(1.0); // Normal at surface point
    vec3 v = normalize(u_CameraWorldPosition - v_Position); // Vector from surface point to camera
    vec3 l = normalize(vec3(-0.22, 0.17, 0.26)); // Vector from surface point to light
    vec3 h = normalize(l + v); // Half vector between both l and v
    vec3 reflection = -normalize(reflect(v, n));

    float NdotL = clamp(dot(n, l), 0.001, 1.0);
    float NdotV = clamp(abs(dot(n, v)), 0.001, 1.0);
    float NdotH = clamp(dot(n, h), 0.0, 1.0);
    float LdotH = clamp(dot(l, h), 0.0, 1.0);
    float VdotH = clamp(dot(v, h), 0.0, 1.0);

    PBRInfo pbrInputs = PBRInfo
    (
        NdotL,
        NdotV,
        NdotH,
        LdotH,
        VdotH,
        perceptualRoughness,
        metallic,
        specularEnvironmentR0,
        specularEnvironmentR90,
        alphaRoughness,
        diffuseColor,
        specularColor
    );

    float alpha = mix(1.0, baseColor.a, u_AlphaBlend); // Note: the spec mandates to ignore any alpha value in 'OPAQUE' mode

    #if defined(HAS_ALPHACUTOFF)
        if (u_AlphaCutoff > 0.0)
        {
            alpha = step(u_AlphaCutoff, baseColor.a);
        }
    #endif

    // Calculate the shading terms for the microfacet specular shading model
    vec3 F = specularReflection(pbrInputs);
    float G = geometricOcclusion(pbrInputs);
    float D = microfacetDistribution(pbrInputs);

    // Calculation of analytical lighting contribution
    vec3 diffuseContrib = (1.0 - F) * diffuse(pbrInputs);
    vec3 specContrib = F * G * D / (4.0 * NdotL * NdotV);
    vec3 color = NdotL * vec3(0.7) * (diffuseContrib + specContrib);

    // Calculate lighting contribution from image based lighting source (IBL)
    #if defined(USE_IBL)
        vec3 specularIbl = GetIBLSpecular(pbrInputs, reflection, pbrInputs.perceptualRoughness);

        #if defined(USE_SHEEN)
            vec3 nSheen = getNormal(0.0); // needs to be optimized
            vec3 reflectionSheen = -normalize(reflect(v, nSheen));

            vec3 specularIblSheen = GetIBLSpecular(pbrInputs, reflectionSheen, u_sheenRoughness);
            specularIbl += specularIblSheen * u_sheenScale;
        #endif

        vec3 diffuseIbl = GetIBLDiffuse(pbrInputs, n);
        color += specularIbl;
        color += diffuseIbl;

        // Add the reflection to the alpha - looks better
        alpha += clamp(simpleBrightness(specularIbl), 0.0, 1.0);
    #endif

    color += u_EmissiveFactor; // Add emission

    alpha = clamp(alpha, 0.0, 1.0);
    color.rgb = pow(color.rgb, vec3(1.0 / 2.2));
    color.rgb *= v_Color.rgb; // Ambient occlusion from Vertex Colors

    FragColor = vec4(color, alpha);
}
