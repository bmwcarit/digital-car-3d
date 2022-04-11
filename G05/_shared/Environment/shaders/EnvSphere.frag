#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision mediump float;

in vec3 v_Normal;

out vec4 FragColor;

uniform samplerCube u_SpecularEnvSampler;

void main() {
    vec3 tex = texture(u_SpecularEnvSampler, v_Normal).rgb;

    FragColor = vec4(tex, 1.0);
}
