varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
void main(void) { // 2
    //gl_FragColor = DestinationColor;
    lowp vec4 S = texture2D(TextureFloor, TexCoordOut);
    lowp vec4 D = texture2D(Texture, TexCoordOut);;
    lowp float Da = DestinationColor.a;
    lowp float Sa = S.a;
//    lowp float Da =
//    lowp float Sa =
//    if(tc.a == 0.0){
//        gl_FragColor = DestinationColor  ;
//    } else
//    gl_FragColor =S;//vec4( 0.0, 0.0 , 0.0 , 0.0 ) ; // 3//kCGBlendModeCopy
//    gl_FragColor =S*Da ;//vec4( 0.0, 0.0 , 0.0 , 0.0 ) ; // 3//kCGBlendModeSourceIn
//    gl_FragColor = D*(1.0 - Sa) ;//vec4( 0.0, 0.0 , 0.0 , 0.0 ) ; // 3//kCGBlendModeSourceOut
    gl_FragColor = S * Da + D * (1.0 - Sa);
//    gl_FragColor = DestinationColor * texture2D(TextureFloor, TexCoordOut);
    
    
}


//keep in mind:
//background is Destination -> AKA 'D'
//foreground is Source -> AKA 'S'
//Source is Stroke brush in this context
