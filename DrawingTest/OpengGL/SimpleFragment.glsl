
precision mediump float;
precision mediump int;


varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
uniform sampler2D TextureTop;


varying vec4 vertTexCoord;

void main(void) { // 2
    
    lowp vec4 maskTexture = texture2D(Texture, TexCoordOut);
    lowp vec4 coloredTexture = texture2D(TextureFloor, TexCoordOut);
    lowp vec4 b_wTexture =  texture2D(TextureTop, TexCoordOut);
    lowp float Da = DestinationColor.a;
    lowp float maskAlpha = maskTexture.a;
    
    float a = coloredTexture.a * 255.0,
    r  = coloredTexture.r * 255.0,
    g  = coloredTexture.g * 255.0,
    b = coloredTexture.b * 255.0;
    float avg = (r + g + b) / 3.0;
    
    gl_FragColor = coloredTexture * 0.5 + (avg / 170.0 < 0.5 ? vec4(0.0, 0.0, 0.0, 0.50) : vec4(1.0, 0.0, 0.0, 0.50));
//    gl_FragColor = coloredTexture * maskAlpha + (1.0 - maskAlpha) * b_wTexture;
}
/*
float 		width = 400.0;
float 		height = 400.0 ;

void make_kernel(inout vec4 n[9], sampler2D tex, vec2 coord)
{
    float w = 1.0 / width;
    float h = 1.0 / height;
    
    n[0] = texture2D(tex, coord + vec2( -w, -h));
    n[1] = texture2D(tex, coord + vec2(0.0, -h));
    n[2] = texture2D(tex, coord + vec2(  w, -h));
    n[3] = texture2D(tex, coord + vec2( -w, 0.0));
    n[4] = texture2D(tex, coord);
    n[5] = texture2D(tex, coord + vec2(  w, 0.0));
    n[6] = texture2D(tex, coord + vec2( -w, h));
    n[7] = texture2D(tex, coord + vec2(0.0, h));
    n[8] = texture2D(tex, coord + vec2(  w, h));
}

void main(void)
{
    vec4 n[9];
    make_kernel( n, Texture, TexCoordOut.st );
    
    vec4 sobel_edge_h = n[2] + (2.0*n[5]) + n[8] - (n[0] + (2.0*n[3]) + n[6]);
    vec4 sobel_edge_v = n[0] + (2.0*n[1]) + n[2] - (n[6] + (2.0*n[7]) + n[8]);
    vec4 sobel = sqrt((sobel_edge_h * sobel_edge_h) + (sobel_edge_v * sobel_edge_v));
    
    gl_FragColor = vec4( 1.0 - sobel.rgb, 1.0 );
}


*/

/*
vec2 resolution = vec2(400, 400);
const vec4 luminance_vector = vec4(0.3, 0.6, 0.7, 0.0);
void main() {
    vec2 uv = vec2(1.0) - (gl_FragCoord.xy / resolution.xy);
    vec2 n = 1.0/resolution.xy;
    vec4 CC = texture2D(Texture, uv);
    vec4 RD = texture2D(Texture, uv + vec2( n.x, -n.y));
    vec4 RC = texture2D(Texture, uv + vec2( n.x,  0.0));
    vec4 RU = texture2D(Texture, uv + n);
    vec4 LD = texture2D(Texture, uv - n);
    vec4 LC = texture2D(Texture, uv - vec2( n.x,  0.0));
    vec4 LU = texture2D(Texture, uv - vec2( n.x, -n.y));
    vec4 CD = texture2D(Texture, uv - vec2( 0.0,  n.y));
    vec4 CU = texture2D(Texture, uv + vec2( 0.0,  n.y));
    vec4 color = vec4(2.0 * abs(length(
                                       vec2(
                                            -abs(dot(luminance_vector, LD - RD))
                                            +4.0*abs(dot(luminance_vector, LC - RC))
                                            -abs(dot(luminance_vector, LU - RU)),
                                            
                                            -abs(dot(luminance_vector, LU - LD))
                                            +4.0*abs(dot(luminance_vector, CU - CD))
                                            -abs(dot(luminance_vector, RU - RD))
                                            )
                                       )-0.5));//.5 is pixel area
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    
    gl_FragColor = vec4(gray, gray, gray, 1.0);
}
*/

 
 
/*

const float RADIUS = 0.75;
vec2 resolution = vec2(900, 1600);
//softness of our vignette, between 0.0 and 1.0
const float SOFTNESS = 0.45;

//sepia colour, adjust to taste
const vec3 SEPIA = vec3(.82, .50, 0.6);

void main() {
    //sample our texture
    vec4 texColor = texture2D(Texture, TexCoordOut);
    
    //1. VIGNETTE
    
    //determine center position
    vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);
    
    //determine the vector length of the center position
    float len = length(position);
    
    //use smoothstep to create a smooth vignette
    float vignette = smoothstep(RADIUS, RADIUS-SOFTNESS, len);
    
    //apply the vignette with 50% opacity
    texColor.rgb = mix(texColor.rgb, texColor.rgb * vignette, 0.5);
    
    //2. GRAYSCALE
    
    //convert to grayscale using NTSC conversion weights
    float gray = dot(texColor.rgb, vec3(0.299, 0.587, 0.114));
    
    //3. SEPIA
    
    //create our sepia tone from some constant value
    vec3 sepiaColor = vec3(gray) * SEPIA;
    
    //again we'll use mix so that the sepia effect is at 75%
    texColor.rgb = mix(texColor.rgb, sepiaColor, 0.75);
    
    //final colour, multiplied by vertex colour
    gl_FragColor = texColor ;
}*/

/*
 float brightness = 1.2;
 float contrast = 0.39;
 float saturation = 0.7;

void main(void) {
    vec3 texColor = texture2D(Texture, TexCoordOut.st).rgb;
    
    const vec3 LumCoeff = vec3(0.2125, 0.7154, 0.0721);
    vec3 AvgLumin = vec3(0.5, 0.5, 0.5);
    vec3 intensity = vec3(dot(texColor, LumCoeff));
    
    vec3 satColor = mix(intensity, texColor, saturation);
    vec3 conColor = mix(AvgLumin, satColor, contrast);
    
    gl_FragColor = vec4(brightness * conColor, 1.0);
}
*/
/*
//consider this as uniforms
const float modr = 0.3;
const float modg = 0.55;
const float modb = 0.25;

void main(void)
{
    vec3 col = texture2D(Texture, TexCoordOut.st).rgb;
    
    col.r -= mod(col.r, modr);
    col.g -= mod(col.g, modg);
    col.b -= mod(col.b, modb);
    
    gl_FragColor = vec4(col, 1.0);
}

*/

/*
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

*/
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
