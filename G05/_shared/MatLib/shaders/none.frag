#version 300 es

/*
This work is licensed under the Creative Commons Attribution 4.0 International License.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/
or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

precision lowp float; // low precision suffices for light blocking geometry

out vec4 FragColor;

void main() {
    FragColor.rgb = vec3(0.0);
    FragColor.a = 1.0;
}
