#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision highp float;

uniform mat4 u_MVPMatrix;
uniform mat4 u_MMatrix;

in vec3 a_Position;
in vec3 a_Normal;

out vec3 v_Position;
out vec3 v_Normal;


void main() {
    v_Normal = normalize(vec3(u_MMatrix * vec4(a_Normal, 0.0)));
    vec4 pos = u_MMatrix * vec4(a_Position, 1.0);
    v_Position = pos.xyz;

    gl_Position = u_MVPMatrix * vec4(a_Position, 1.0);
}
