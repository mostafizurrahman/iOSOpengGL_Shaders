

varying lowp vec2 TexCoordOut; // New
uniform sampler2D TextureFloor; // New
varying lowp vec4 SourceColor1;
void main(void) { // 2
    lowp float rr = SourceColor1[0];
    
    gl_FragColor = texture2D(TextureFloor, vec2(TexCoordOut.x, 1.0 - TexCoordOut.y)) +
    (rr > 0.0 ? SourceColor1 : vec4(0.5) ); // 3
}

