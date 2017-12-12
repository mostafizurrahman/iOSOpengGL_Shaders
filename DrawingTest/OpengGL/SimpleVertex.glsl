attribute vec4 Position;
attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New
attribute lowp vec4 SourceColor;
varying lowp vec4 SourceColor1;
void main(void) {
    gl_Position = Position;
    TexCoordOut = TexCoordIn;
    SourceColor1 = SourceColor;
}

