varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) { // 2
    gl_FragColor = DestinationColor * texture2D(Texture, TexCoordOut); // 3
}
