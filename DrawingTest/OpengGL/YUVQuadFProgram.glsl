
precision mediump float;

varying vec2 v_TextureCoordinate;


attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New
attribute lowp vec4 SourceColor;
varying lowp vec4 SourceColor1;
void main(void) {
    gl_Position = Position;
    TexCoordOut = TexCoordIn;
    SourceColor1 = SourceColor;
}

