#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision mediump float;

in vec3 a_Position;
in vec3 a_Normal;

out vec3 v_Normal;

uniform mat4 u_MMatrix;
uniform mat4 u_MVPMatrix;

void main() {
    v_Normal = -normalize(vec3(u_MMatrix * vec4(a_Normal, 0.0)));

    gl_Position = u_MVPMatrix * vec4(a_Position.x, a_Position.yz, 1.0);
}
