

varying lowp vec2 TexCoordOut; // New
uniform sampler2D TextureFloor; // New
varying lowp vec4 SourceColor1;
void main(void) { // 2
    
    gl_FragColor = texture2D(TextureFloor, TexCoordOut) * 0.3 ; // 3
}

