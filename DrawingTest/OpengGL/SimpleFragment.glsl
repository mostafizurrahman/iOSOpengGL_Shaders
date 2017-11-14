
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
uniform sampler2D TextureTop;






const vec4  kRGBToYPrime = vec4 (0.299, 0.587, 0.114, 0.0);
const vec4  kRGBToI     = vec4 (0.596, -0.275, -0.321, 0.0);
const vec4  kRGBToQ     = vec4 (0.212, -0.523, 0.311, 0.0);

const vec4  kYIQToR   = vec4 (1.0, 0.956, 0.621, 0.0);
const vec4  kYIQToG   = vec4 (1.0, -0.272, -0.647, 0.0);
const vec4  kYIQToB   = vec4 (1.0, -1.107, 1.704, 0.0);

varying vec4 vertTexCoord;
uniform sampler2D texture;
uniform float hue;

void main ()
{
    // Sample the input pixel
    vec4 color = texture2D(Texture, TexCoordOut.st).rgba;
    
    // Convert to YIQ
    float   YPrime  = dot (color, kRGBToYPrime);
    float   I      = dot (color, kRGBToI);
    float   Q      = dot (color, kRGBToQ);
    
    // Calculate the chroma
    float   chroma  = sqrt (I * I + Q * Q);
    
    // Convert desired hue back to YIQ
    Q = chroma * sin (hue);
    I = chroma * cos (hue);
    
    // Convert back to RGB
    vec4    yIQ   = vec4 (YPrime, I, Q, 0.0);
    color.r = dot (yIQ, kYIQToR);
    color.g = dot (yIQ, kYIQToG);
    color.b = dot (yIQ, kYIQToB);
    
    // Save the result
    gl_FragColor    = color;
}
/*
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
 
 */
