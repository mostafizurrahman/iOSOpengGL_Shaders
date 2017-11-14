
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
uniform sampler2D TextureTop;




const int pixelsPerRow = 100;

void main(void)
{
    vec2 p = TexCoordOut.st;
    float pixelSize = 1.0 / float(pixelsPerRow);
    
    float dx = mod(p.x, pixelSize) - pixelSize*0.5;
    float dy = mod(p.y, pixelSize) - pixelSize*0.5;
    
    p.x -= dx;
    p.y -= dy;
    vec3 col = texture2D(Texture, p).rgb;
    float bright = 0.3333*(col.r+col.g+col.b);
    
    float dist = sqrt(dx*dx + dy*dy);
    float rad = bright * pixelSize * 0.8;
    float m = step(dist, rad);
    
    vec3 col2 = mix(col,col, m);
    gl_FragColor = vec4(col2, 1.0);
}


/*
 
 
 */
