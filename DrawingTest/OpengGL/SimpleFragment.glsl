varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) { // 2
    //gl_FragColor = DestinationColor;
    lowp vec4 tc = texture2D(Texture, TexCoordOut);
 
    if(tc.a == 0.0){
        gl_FragColor = DestinationColor  ;
    } else
    gl_FragColor = texture2D(Texture, TexCoordOut); // 3
}
