varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
void main(void) { // 2
    
//    lowp vec4 S = texture2D(Texture, TexCoordOut);
//    lowp float Da = DestinationColor.a;
//    lowp vec4 D = DestinationColor;
//    lowp float Sa = S.a;
//    lowp vec4 R = D*(1.0 - Sa);
    gl_FragColor = DestinationColor;
//    if(R.a < 1.0){
//        gl_FragColor = R * B;
//    } else {
//        gl_FragColor = R;
//    }
    
    
}


//keep in mind:
//background is Destination -> AKA 'D'
//foreground is Source -> AKA 'S'
//Source is Stroke brush in this context
