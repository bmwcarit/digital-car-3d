#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision highp float;

uniform vec3 u_CameraWorldPosition;

uniform vec3 u_tint;
uniform float u_reflectionIntensity;

// fresnel
uniform float u_fresnelScale;
uniform float u_fresnelBias;
uniform float u_fresnelPower;

uniform samplerCube u_environmentMap;

in vec3 v_Position;
in vec3 v_Normal;

out vec4 FragColor;


void main() {
    vec3 v = normalize(u_CameraWorldPosition - v_Position);     // vector from surface point to camera
    vec3 reflection = reflect(v, normalize(v_Normal));
    vec3 specularLight = u_tint + textureLod(u_environmentMap, reflection, 1.0).rgb * u_reflectionIntensity;

    vec3 p = normalize (v_Position - u_CameraWorldPosition);
    float fresnel = u_fresnelBias + u_fresnelScale * pow(1.0 + dot(p, v_Normal), u_fresnelPower);

    FragColor.xyz = specularLight;
    FragColor.w = fresnel;
}
