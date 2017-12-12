

attribute vec4 a_TexturePosition;
attribute vec2 a_TextureCoordinate;
varying vec2 v_TextureCoordinate;

void main(void) {
    gl_Position = a_TexturePosition;
    v_TextureCoordinate = a_TextureCoordinate;
}


