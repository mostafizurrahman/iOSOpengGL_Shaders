//
//  Header.h
//  IPVFaceDetectioniOS
//
//  Created by Nishu on 2/13/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

NSString *const FRAGMENT_SHADER_BLEACH = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 const vec4 one = vec4(1.0);
 const vec4 two = vec4(2.0);
 const vec4 lumcoeff = vec4(0.5125,0.2154,0.8721,0.0);
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 float amount = 0.5;
	 
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec4 pixel = vec4(r,g,b,1.0);
	 vec4 luma = vec4(vec3(dot(pixel,lumcoeff)), pixel.a);
	 
	 float luminance = dot(pixel,lumcoeff);
	 float mixamount = clamp((luminance - 0.45) * 10.0, 0.0, 1.0);
	 
	 vec4 branch1 = two * pixel * luma;
	 vec4 branch2 = one - (two * (one - pixel) * (one - luma));
	 
	 vec4 result = mix(branch1, branch2, vec4(mixamount) );
	 
	 vec4 final = mix(pixel, result, amount);
	 
	 vec3 secondColor = vec3(0.9,0.7,0.6);
	 
	 vec3 multiplyBlend = (final.rgb * secondColor) * 0.75 + final.rgb * (1.0 - 0.75);
	 
	 gl_FragColor = vec4(multiplyBlend,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_GRADIENT = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform vec2 resolution;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec4 rgba = vec4(r,g,b,1.0);
	 
	 float radius = resolution.x/4.0;
	 
	 vec2 center = vec2(resolution.x/2.0, resolution.y/2.0);
	 
	 vec2 position = gl_FragCoord.xy - center;
	 
	 vec4 blendrgb = vec4(0.87,0.76,0.63,1.0);
	 vec4 secondColor = vec4(0.62,0.52,0.37,1.0);
	 
	 // Scale to UV space coords
	 vec2 spaceCoord = gl_FragCoord.xy / resolution.xy;
	 
	 // Transform to [(-1.0, -1.0), (1.0, 1.0)] range
	 spaceCoord = 2.0 * spaceCoord - 1.0;
	 
	 // Have something to vary the radius (can also just be a linear counter (time))
	 float wave = sin(0.25);
	 
	 // Calculate how near to the center (0.0) or edge (1.0) this fragment is
	 float circle = spaceCoord.x * spaceCoord.x + spaceCoord.y * spaceCoord.y;
	 
	 vec4 colorBlend = mix(secondColor, blendrgb, circle + wave);
	 
	 vec3 multiplyBlend = (colorBlend.rgb * vec3(r,g,b)) * 0.75 + colorBlend.rgb * (1.0 - 0.75);
	 
	 gl_FragColor = vec4(multiplyBlend,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_OVERLAY = SHADER_STRING
(
 precision mediump float;
 
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform sampler2D blend_texture;
 uniform float u_AlphaFactor;
 
 varying vec2 v_texCoord;
 
 float BlendOverlayf(float base, float blend) {
	 return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));
 }
 
 vec3 BlendOverlay(vec3 base, vec3 blend) {
	 return vec3(BlendOverlayf(base.r, blend.r), BlendOverlayf(base.g, blend.g), BlendOverlayf(base.b, blend.b));
 }
 
 void main () {
	 
	 float r;float g;float b;float y;float u;float v;
	 float scale = (2.0 * 0.0 - 1.0);
	 
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec4 basecolor = vec4(r,g,b,1.0);
	 
	 mediump vec4 blendColor = texture2D(blend_texture, v_texCoord );
	 //blendColor.r /= blendColor.a; blendColor.g /= blendColor.a; blendColor.b /= blendColor.a;
	 basecolor.rgb = BlendOverlay(basecolor.rgb,blendColor.rgb);
	 //basecolor.a = blendColor.a * 0.50;
	 gl_FragColor = basecolor;
 }
 );

NSString *const FRAGMENT_SHADER_TEMP = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 float scale = (2.0 * 0.0 - 1.0);
	 
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 color = vec3(r,g,b);
	 vec3 new_color = color.rgb;
	 new_color.r = color.r + color.r * ( 1.0 - color.r) * scale;
	 new_color.b = color.b - color.b * ( 1.0 - color.b) * scale;
	 if (scale > 0.0) {
		 new_color.g = color.g + color.g * ( 1.0 - color.g) * scale * 0.25;
	 }
	 float max_value = max(new_color.r, max(new_color.g, new_color.b));
	 if (max_value > 1.0) {
		 new_color /= max_value;
	 }
	 
	 gl_FragColor = vec4(new_color, 1.0);
	 
 }
 );

NSString *const FRAGMENT_SHADER_INTERPOLATIVE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform sampler2D blend_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 vec4 texture_color = texture2D(blend_texture,v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 color = vec3(r,g,b) * 0.25;
	 
	 vec3 dst_rgb = vec3(texture_color.r,texture_color.g,texture_color.b)*0.75;
	 
	 gl_FragColor = vec4((color + dst_rgb),1.0);
 }
 );

NSString *const FRAGMENT_SHADER_DARKEN = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform sampler2D blend_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 vec4 texture_color = texture2D(blend_texture,v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 fgcolor = vec3(r,g,b);
	 
	 float final_r;float final_g;float final_b;
	 
	 final_r = min(texture_color.r,r);
	 final_g = min(texture_color.g,g);
	 final_b = min(texture_color.b,b);
	 
	 vec3 finalcolor = vec3(final_r,final_g,final_b);
	 
	 gl_FragColor = vec4(finalcolor,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_COLOR_BURN = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform sampler2D blend_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 vec4 texture_color = texture2D(blend_texture,v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 fgcolor = vec3(r,g,b);
	 
	 float final_r;float final_g;float final_b;
	 
	 if(texture_color.r < 0.0)  final_r = texture_color.r;
	 else final_r = max((1.0-((1.0-r)/texture_color.r)),0.0);
	 
	 if(texture_color.g < 0.0)  final_g = texture_color.g;
	 else final_g = max((1.0-((1.0-g)/texture_color.g)),0.0);
	 
	 if(texture_color.b < 0.0)  final_b = texture_color.b;
	 else final_b = max((1.0-((1.0-b)/texture_color.b)),0.0);
	 
	 vec3 finalcolor = vec3(final_r,final_g,final_b);
	 
	 gl_FragColor = vec4(finalcolor,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_POSTERIZE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 
	 float gamma = 0.6; // 0.6
	 float numColors = 8.0; // 8.0
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 vec3 rgb = vec3(r,g,b);
	 
	 rgb = pow(rgb, vec3(gamma, gamma, gamma));
	 rgb = rgb * numColors;
	 rgb = floor(rgb);
	 rgb = rgb / numColors;
	 rgb = pow(rgb, vec3(1.0/gamma));
	 gl_FragColor = vec4(rgb, 1.0);
 }
 );

NSString *const FRAGMENT_SHADER_CROSS_PROCESS = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;float value;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 vec4 color = vec4(r,g,b,1.0);
	 
	 vec3 ncolor = vec3(0.0, 0.0, 0.0);
	 if(color.r < 0.5) {
		 value = color.r;
	 } else {
		 value = 1.0 - color.r;
	 }
	 float red = 4.0 * value * value * value;
	 if(color.r < 0.5) {
		 ncolor.r = red;
	 } else {
		 ncolor.r = 1.0 - red;
	 }
	 if(color.g < 0.5) {
		 value = color.g;
	 } else {
		 value = 1.0 - color.g;
	 }
	 float green = 2.0 * value * value;
	 
	 if(color.g < 0.5) {
		 ncolor.g = green;
	 } else {
		 ncolor.g = 1.0 - green;
	 }
	 ncolor.b = color.b * 0.5 + 0.25;
	 gl_FragColor = vec4(ncolor.rgb, color.a);
 }
 );

NSString *const FRAGMENT_SHADER_INVERT = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 float colorR = (1.0 - r) / 1.0;
	 float colorG = (1.0 - g) / 1.0;
	 float colorB = (1.0 - b) / 1.0;
	 
	 gl_FragColor = vec4(colorR,colorG,colorB,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_SEPIA = SHADER_STRING
(
 
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;float gray;
	 const vec3 SEPIA = vec3(1.2, 1.0, 0.8);
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 gray = dot(vec3(r,g,b), vec3(0.299, 0.587, 0.114));
	 
	 gl_FragColor = vec4(vec3(gray) * SEPIA, 1.0);
	 
 }
 );

NSString *const FRAGMENT_SHADER_GRAYSCALE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;float gray;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 gray = dot(vec3(r,g,b), vec3(0.299, 0.587, 0.114));
	 
	 gl_FragColor = vec4(vec3(gray),1.0);
 }
 );

NSString *const FRAGMENT_SHADER_HUE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 vec4 kRGBToYPrime = vec4(0.299, 0.587, 0.114, 0.0);
	 vec4 kRGBToI = vec4 (0.595716, -0.274453, -0.321263, 0.0);
	 vec4 kRGBToQ = vec4 (0.211456, -0.522591, 0.31135, 0.0);
	 
	 vec4 kYIQToR = vec4 (1.0, 0.9563, 0.6210, 0.0);
	 vec4 kYIQToG = vec4 (1.0, -0.2721, -0.6474, 0.0);
	 vec4 kYIQToB = vec4 (1.0, -1.1070, 1.7046, 0.0);
	 
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec4 color = vec4(r,g,b,1.0);
	 
	 float YPrime = dot(color,kRGBToYPrime);
	 float I = dot(color, kRGBToI);
	 float Q = dot(color, kRGBToQ);
	 
	 float hue = atan(Q);
	 float chroma = sqrt (I * I + Q * Q);
	 
	 hue += 0.50;
	 
	 Q = chroma * sin (hue);
	 
	 I = chroma * cos (hue);
	 
	 vec4 yIQ = vec4 (YPrime, I, Q, 0.0);
	 
	 color.r = dot (yIQ, kYIQToR);
	 color.g = dot (yIQ, kYIQToG);
	 color.b = dot (yIQ, kYIQToB);
	 gl_FragColor = color;
 }
 );

NSString *const FRAGMENT_SHADER_HALFTONE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform vec2 resolution;
 
 varying vec2 v_texCoord;
 
 
 float amount = 128.0;
 float smoothness = 0.25;
 
 void main () {
	 
	 float ar = resolution.x / resolution.y;
	 vec2 nearest = 2.0 * fract( amount * vec2( 1.0, 1.0 / ar ) * v_texCoord ) - 1.0;
	 float distX = length( nearest.x );
	 float distY = length( nearest.y );
	 float dist = length( nearest );
	 
	 vec2 d = vec2( 1.0 / amount ) * vec2( 1.0, ar );
	 vec2 tUv = floor( v_texCoord / d ) * d;
	 
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 vec3 dotColorCalculation = vec3(r,g,b);
	 vec3 luma = vec3( 0.299, 0.587, 0.114 );
	 vec3 gradientColor = dotColorCalculation ;//texture2D( tInput, vUv ).rgb;
	 float radius = sqrt( dot( dotColorCalculation, luma ) );
	 
	 vec3 bkgColor = vec3( 0.0 );//1.0, 1.0, 1.0 );
	 
	 float afwidth = amount * ( 1.0 / 200.0 );
	 float antialiasStep = smoothstep( radius - afwidth, radius, dist );
	 
	 vec4 halfToneDotColor = vec4( mix( gradientColor.rgb, bkgColor, antialiasStep), 1.0 );
	 
	 distX += 0.02;
	 distY += 0.02;
	 
	 vec2 position = vec2(distX,distY);
	 
	 float size_param = 0.8 * radius; // 0.5
	 
	 vec2 size = vec2(size_param);
	 
	 radius = 0.4 * radius;
	 
	 float roundedBox = length( max( abs( position ) - size, 0.0 ) ) - radius;
	 
	 vec4 halfToneSquircleColor = vec4( mix( bkgColor, gradientColor.rgb, smoothstep( smoothness, 0.0, roundedBox) ), 1.0 );
	 
	 vec3 blendrgb = vec3(0.0,0.02,0.38);
	 
	 vec3 middlergb = halfToneSquircleColor.rgb + blendrgb - 2.0 * halfToneSquircleColor.rgb * blendrgb;
	 
	 vec3 exclusionBlend = middlergb * 0.75 + halfToneSquircleColor.rgb * (1.0 - 0.75);
	 
	 
	 gl_FragColor = vec4(exclusionBlend,1.0);
 }
 );

NSString *const FRAGMENT_SHADER_VIGNETTE = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 //RADIUS of our vignette, where 0.5 results in a circle fitting the screen
 const float RADIUS = 0.6;
 
 //softness of our vignette, between 0.0 and 1.0
 const float SOFTNESS = 0.2;
 
 //sepia colour, adjust to taste
 const vec3 SEPIA = vec3(1.2, 1.0, 0.8);
 
 void main () {
	 float r;
	 float g;float b;
	 float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 color_rgb = vec3(r,g,b);
	 vec2 centerPosition = vec2(0.5,0.5);
	 
	 //determine origin
	 lowp float position = distance(v_texCoord, centerPosition);
	 
	 //determine the vector length of the center position
	 float len = length(position);
	 
	 //use smoothstep to create a smooth vignette
	 lowp float percent = smoothstep(RADIUS,SOFTNESS, len);
	 
	 //apply the vignette with 50% opacity
	 color_rgb.rgb = mix(color_rgb.rgb, color_rgb.rgb * percent, 0.6);
	 
	 //2. GRAYSCALE
	 
	 //convert to grayscale using NTSC conversion weights
	 float gray = dot(color_rgb.rgb, vec3(0.299, 0.587, 0.114));
	 
	 //3. SEPIA
	 
	 //create our sepia tone from some constant value
	 vec3 sepiaColor = vec3(gray) * SEPIA;
	 
	 //again we'll use mix so that the sepia effect is at 75%
	 color_rgb.rgb = mix(color_rgb.rgb, sepiaColor, 0.75);
	 
	 gl_FragColor = vec4(color_rgb,1.0);
	 
 }
 );

NSString *const FRAGMENT_SHADER_RETRO_VIGNETTE = SHADER_STRING
(
 precision highp float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 
 varying vec2 v_texCoord;
 
 //RADIUS of our vignette, where 0.5 results in a circle fitting the screen
 const float RADIUS = 0.8;
 
 //softness of our vignette, between 0.0 and 1.0
 const float SOFTNESS = 0.0;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 fgcolor = vec3(r,g,b);
	 
	 vec2 centerPosition = vec2(0.5,0.5);
	 
	 //determine origin
	 lowp float position = distance(v_texCoord, centerPosition);
	 
	 //determine the vector length of the center position
	 float len = length(position);
	 
	 //use smoothstep to create a smooth vignette
	 lowp float percent = smoothstep(RADIUS,SOFTNESS, len);
	 
	 //apply the vignette with 50% opacity
	 fgcolor.rgb = mix(fgcolor.rgb, fgcolor.rgb * percent, 1.0);
	 vec3 blendrgb = vec3(0.0,0.02,0.38);
	 
	 vec3 middlergb = fgcolor + blendrgb - 2.0 * fgcolor * blendrgb;
	 
	 vec3 exclusionBlend = middlergb * 0.75 + fgcolor * (1.0 - 0.75);
	 
	 vec3 secondColor = vec3(1.0,0.88,0.65);
	 
	 vec3 multiplyBlend = (exclusionBlend * secondColor) * 0.75 + exclusionBlend * (1.0 - 0.75);
	 
	 
	 gl_FragColor = vec4(multiplyBlend,1.0);
	}
 
 
 );

NSString *const FRAGMENT_SHADER_RETRO = SHADER_STRING
(
 precision mediump float;
 
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 uniform sampler2D blend_texture;
 varying vec2 v_texCoord;
 
 void main () {
	 float r;float g;float b;float y;float u;float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 vec4 texture_color = texture2D(blend_texture,v_texCoord);
	 
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 
	 y=1.1643*(y-0.0625);
	 
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.81290*v);
	 b= (y+2.017*u);
	 
	 vec3 fgcolor = vec3(r,g,b);
	 
	 vec3 blendrgb = vec3(0.0,0.02,0.38);
	 
	 vec3 middlergb = fgcolor + blendrgb - 2.0 * fgcolor * blendrgb;
	 
	 vec3 exclusionBlend = middlergb * 0.75 + fgcolor * (1.0 - 0.75);
	 
	 vec3 secondColor = vec3(1.0,0.88,0.65);
	 
	 vec3 multiplyBlend = (exclusionBlend * secondColor) * 0.75 + exclusionBlend * (1.0 - 0.75);
	 
	 vec3 brightness = multiplyBlend + vec3(0.3);
	 
	 vec3 contrast = brightness * 0.5;
	 
	 vec2 centerPosition = vec2(0.5,0.5);
	 
	 gl_FragColor = vec4(contrast,1.0);
	}
 
 );


NSString *const VERTEX_SHADER_OFFSCREEN_TO_ONSCREEN = SHADER_STRING
(
 attribute vec4 a_position;
 attribute vec2 a_texCoord;
 varying vec2 v_texCoord;
 
 void main() {
	 v_texCoord = vec2(a_texCoord.x, 1.0 - a_texCoord.y);
	 gl_Position = a_position;
 }
 );

NSString *const FRAGMENT_SHADER_OFFSCREEN_TO_ONSCREEN = SHADER_STRING
(
 precision mediump float;
 uniform sampler2D u_texture;
 varying vec2 v_texCoord;
 
 void main() {
	 gl_FragColor = texture2D(u_texture, v_texCoord);
 }
 );

NSString *const VERTEX_SHADER_BILATERAL = SHADER_STRING
(
 attribute vec4 a_position;
 attribute vec4 a_texCoord;
 uniform mat4 uMVPMatrix;
 
 const int GAUSSIAN_SAMPLES = 7;
 
 uniform float texelWidthOffset;
 uniform float texelHeightOffset;
 
 varying vec2 textureCoordinate;
 varying vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
 void main()
{
	
	gl_Position = a_position;
	textureCoordinate = a_texCoord.xy;
	
	// Calculate the positions for the blur
	int multiplier = 0;
	vec2 blurStep;
	vec2 singleStepOffset = vec2(texelWidthOffset, texelHeightOffset);
	
	for (int i = 0; i < GAUSSIAN_SAMPLES; i++)
	{
		multiplier = (i - ((GAUSSIAN_SAMPLES - 1) / 2));
		// Blur in x (horizontal)
		blurStep = float(multiplier) * singleStepOffset;
		blurCoordinates[i] = a_texCoord.xy + blurStep;
	}
}
 
 );

NSString *const FRAGMENT_SHADER_BILATERAL = SHADER_STRING
(
 uniform sampler2D inputImageTexture;
 
 const lowp int GAUSSIAN_SAMPLES = 7;
 
 varying mediump vec2 textureCoordinate;
 varying mediump vec2 blurCoordinates[GAUSSIAN_SAMPLES];
 
 uniform mediump float distanceNormalizationFactor;
 
 void main()
 {
	 lowp vec4 centralColor;
	 lowp float gaussianWeightTotal;
	 lowp vec4 sum;
	 lowp vec4 sampleColor;
	 lowp float distanceFromCentralColor;
	 lowp float gaussianWeight;
	 
	 centralColor = texture2D(inputImageTexture, blurCoordinates[3]);
	 gaussianWeightTotal = 0.214607;
	 sum = centralColor * 0.214607;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[0]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.071303 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[1]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.131514 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[2]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.189879 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[4]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.189879 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[5]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.131514 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 
	 sampleColor = texture2D(inputImageTexture, blurCoordinates[6]);
	 distanceFromCentralColor = min(distance(centralColor, sampleColor) * distanceNormalizationFactor, 1.0);
	 gaussianWeight = 0.071303 * (1.0 - distanceFromCentralColor);
	 gaussianWeightTotal += gaussianWeight;
	 sum += sampleColor * gaussianWeight;
	 gl_FragColor = sum / gaussianWeightTotal;
 }
 );


NSString *const FRAGMENT_SHADER_CAMERA_PREVIEW = SHADER_STRING
(
 precision mediump float;
 uniform sampler2D y_texture;
 uniform sampler2D uv_texture;
 varying vec2 v_texCoord;
 void main ()
 {
	 float r;
	 float g;
	 float b;
	 float y;
	 float u;
	 float v;
	 y = texture2D(y_texture, v_texCoord).r;
	 vec4 uv = texture2D(uv_texture, v_texCoord);
	 u = uv.r - 0.5;
	 v = uv.g - 0.5;
	 y=1.1643*(y-0.0625);
	 r= (y+1.5958*v);
	 g= (y-0.39173*u-0.8190*v);
	 b= (y+2.017*u);
	 gl_FragColor = vec4(r,g,b,1.0);
 }
 );

NSString *const VERTEX_SHADER_CAMERA_PREVIEW = SHADER_STRING
(
 attribute vec3 a_position;
 attribute vec2 a_texCoord;
 varying vec2 v_texCoord;
 void main()
 {
	 gl_Position = vec4(a_position, 1.0);
	 v_texCoord = a_texCoord;
 }
 );

NSString *const FRAGMENT_SHADER_ANIMATION_RENDERING = SHADER_STRING
(
 precision mediump float;
 uniform sampler2D u_texture;
 varying vec2 v_texCoord;
 
 void main () {
	 mediump vec4 srcColor = texture2D(u_texture, v_texCoord);
	 if (srcColor.a > 0.0) {
		 srcColor.r /= srcColor.a; srcColor.g /= srcColor.a; srcColor.b /= srcColor.a;
	 }
	 
	 gl_FragColor = srcColor;
 }
 );

NSString *const FRAGMENT_SHADER_MASK_RENDERING_NO_BLENDING = SHADER_STRING
(
 precision mediump float;
 uniform sampler2D u_texture;
 uniform float u_Alpha;
 varying vec2 v_texCoord;
 
 void main () {
	 mediump vec4 srcColor = texture2D(u_texture, v_texCoord);
	 if (srcColor.a > 0.0) {
		 srcColor.r /= srcColor.a; srcColor.g /= srcColor.a; srcColor.b /= srcColor.a;
		 srcColor.a *= u_Alpha;
	 }
	 
	 gl_FragColor = srcColor;
 }
 );

#define FRAGMENT_SHADER_MASK_RENDERING_MULTIPLY_BLENDING ""\
""\
" #extension GL_EXT_shader_framebuffer_fetch : require\n"\
" precision mediump float;\n"\
" uniform sampler2D u_texture;\n"\
" uniform float u_Alpha;\n"\
" varying vec2 v_texCoord;\n"\
"\n"\
"  void main () {\n"\
"      mediump vec4 destColor = gl_LastFragData[0];\n"\
"      mediump vec4 srcColor = texture2D(u_texture, v_texCoord);\n"\
"      if (srcColor.a > 0.0) {\n"\
"          srcColor.r /= srcColor.a; srcColor.g /= srcColor.a; srcColor.b /= srcColor.a;\n"\
"      }\n"\
"      gl_FragColor = srcColor * destColor;\n"\
"      gl_FragColor.a *= u_Alpha;\n"\
"  }\n"\

#define FRAGMENT_SHADER_MASK_RENDERING_PAINT_BLENDING ""\
""\
" #extension GL_EXT_shader_framebuffer_fetch : require\n"\
" precision mediump float;\n"\
" uniform sampler2D u_texture;\n"\
" uniform float u_Alpha;\n"\
" varying vec2 v_texCoord;\n"\
"\n"\
" void main () {\n"\
"     mediump vec4 destColor = gl_LastFragData[0];\n"\
"     mediump vec4 srcColor = texture2D(u_texture, v_texCoord);\n"\
"     if (srcColor.a > 0.0) {\n"\
"        srcColor.r /= srcColor.a; srcColor.g /= srcColor.a; srcColor.b /= srcColor.a;\n"\
"     }\n"\
"     float luma = dot(destColor.rgb, vec3(0.299, 0.587, 0.114));\n"\
"     float effect = ((luma / (1.0 * 1.0) - 1.0) * 0.5 + 1.0);\n"\
"     destColor.rgb = (0.72 * effect) * srcColor.rgb;\n"\
"     destColor.a = srcColor.a * u_Alpha;\n"\
"     gl_FragColor = destColor;\n"\
" }\n"\

#define FRAGMENT_SHADER_MASK_RENDERING_EXPERIMENT_Case1 "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"uniform sampler2D texture;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"void main () {\n"\
"    mediump vec4 color = gl_LastFragData[0];\n"\
"    mediump vec4 value = texture2D(texture, v_texCoord);\n"\
"    value.a = value.r;\n"\
"    color.a = value.a;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define FRAGMENT_SHADER_MASK_RENDERING_EXPERIMENT_Case2 "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"#define kBlendModeNoBlending 0\n"\
"#define kBlendModeMultiply 1\n"\
"\n"\
"uniform sampler2D texture;\n"\
"uniform int blendMode;\n"\
"uniform float u_Alpha;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"vec3 czm_saturation(vec3 rgb, float adjustment) { \n// Algorithm from Chapter 16 of OpenGL Shading Language \nconst vec3 W = vec3(0.2125, 0.7154, 0.0721); \nvec3 intensity = vec3(dot(rgb, W)); \nreturn mix(intensity, rgb, adjustment); \n} \n"\
"float BlendSoftLightf(float base, float blend) {\n"\
"    return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));\n"\
"}\n"\
"vec3 BlendSoftLight(vec3 base, vec3 blend) {\n"\
"    return vec3(BlendSoftLightf(base.r, blend.r), BlendSoftLightf(base.g, blend.g), BlendSoftLightf(base.b, blend.b));\n"\
"}\n"\
"float BlendOverlayf(float base, float blend) {\n"\
"    return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));\n"\
"}\n"\
"vec3 BlendOverlay(vec3 base, vec3 blend) {\n"\
"    return vec3(BlendOverlayf(base.r, blend.r), BlendOverlayf(base.g, blend.g), BlendOverlayf(base.b, blend.b));\n"\
"}\n"\
"void main () {\n"\
"    mediump vec4 color = gl_LastFragData[0];\n"\
"    mediump vec4 value = texture2D(texture, v_texCoord);\n"\
"    color.rgb = BlendSoftLight(color.rgb, value.rgb);\n"\
"    color.a = value.a * u_Alpha;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define FRAGMENT_SHADER_MASK_RENDERING_EXPERIMENT_Case4 "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"#define kBlendModeNoBlending 0\n"\
"#define kBlendModeMultiply 1\n"\
"\n"\
"uniform sampler2D texture;\n"\
"uniform int blendMode;\n"\
"uniform float u_Alpha;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"vec3 czm_saturation(vec3 rgb, float adjustment) { \n// Algorithm from Chapter 16 of OpenGL Shading Language \nconst vec3 W = vec3(0.2125, 0.7154, 0.0721); \nvec3 intensity = vec3(dot(rgb, W)); \nreturn mix(intensity, rgb, adjustment); \n} \n"\
"float BlendSoftLightf(float base, float blend) {\n"\
"    return (blend < 0.5) ? (2.0 * base * blend + base * base * (1.0 - 2.0 * blend)) : (sqrt(base) * (2.0 * blend - 1.0) + 2.0 * base * (1.0 - blend));\n"\
"}\n"\
"vec3 BlendSoftLight(vec3 base, vec3 blend) {\n"\
"    return vec3(BlendSoftLightf(base.r, blend.r), BlendSoftLightf(base.g, blend.g), BlendSoftLightf(base.b, blend.b));\n"\
"}\n"\
"float BlendOverlayf(float base, float blend) {\n"\
"    return base < 0.5 ? (2.0 * base * blend) : (1.0 - 2.0 * (1.0 - base) * (1.0 - blend));\n"\
"}\n"\
"vec3 BlendOverlay(vec3 base, vec3 blend) {\n"\
"    return vec3(BlendOverlayf(base.r, blend.r), BlendOverlayf(base.g, blend.g), BlendOverlayf(base.b, blend.b));\n"\
"}\n"\
"void main () {\n"\
"    lowp vec4 color = gl_LastFragData[0];\n"\
"    lowp vec4 value = texture2D(texture, v_texCoord);\n"\
"    color.rgb = czm_saturation(color.rgb, 0.5);;\n"\
"    vec3 color1 = BlendSoftLight(color.rgb, value.rgb);\n"\
"    vec3 color2 = BlendOverlay(color.rgb, value.rgb);\n"\
"    float v = dot(color.rgb, vec3(0.299, 0.587, 0.114));\n"\
"    color.rgb = mix(color1, color2, v);\n"\
"    color.a = value.a * u_Alpha;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define FRAGMENT_SHADER_MASK_RENDERING_HARD_LIGHT "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"#define kBlendModeNoBlending 0\n"\
"#define kBlendModeMultiply 1\n"\
"\n"\
"uniform sampler2D texture;\n"\
"uniform int blendMode;\n"\
"uniform float u_Alpha;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"float hardLight(float a, float b) {\n"\
"   float result = 0.0;\n"\
"   if (a < 0.5) {\n"\
"       result = 2.0 * a * b;\n"\
"   }\n"\
"   else {\n"\
"       result = (1.0 - 2.0 * (1.0 - a) * (1.0 - b));\n"\
"   }\n"\
"   return result;\n"\
"}\n"\
"\n"\
"void main () {\n"\
"    lowp vec4 destColor = gl_LastFragData[0];\n"\
"    lowp vec4 srcColor = texture2D(texture, v_texCoord);\n"\
"    lowp vec4 color = vec4(0, 0, 0, 0);\n"\
"    color.r = hardLight(srcColor.r, destColor.r);\n"\
"    color.g = hardLight(srcColor.g, destColor.g);\n"\
"    color.b = hardLight(srcColor.b, destColor.b);\n"\
"    color.a = hardLight(srcColor.a, destColor.a) * u_Alpha;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define FRAGMENT_SHADER_MASK_RENDERING_SOFT_LIGHT "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"#define kBlendModeNoBlending 0\n"\
"#define kBlendModeMultiply 1\n"\
"\n"\
"uniform sampler2D texture;\n"\
"uniform int blendMode;\n"\
"uniform float u_Alpha;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"float gW3C(float a) {\n"\
"   float result = 0.0;\n"\
"   if (a > 0.25) {\n"\
"       result = sqrt(a);\n"\
"   }\n"\
"   else {\n"\
"       result = ((a * 16.0 - 12.0) * a + 4.0) * a;\n"\
"   }\n"\
"   return result;\n"\
"}\n"\
"\n"\
"float fW3C(float a, float b) {\n"\
"   float result = 0.0;\n"\
"   if (b <= 0.5) {\n"\
"       result = a - (1.0 - b * 2.0) * a * (1.0 - a);\n"\
"   }\n"\
"   else {\n"\
"       result = a + (b * 2.0 - 1.0) * (gW3C(a) - a);\n"\
"   }\n"\
"   return result;\n"\
"}\n"\
"\n"\
"void main () {\n"\
"    lowp vec4 destColor = gl_LastFragData[0] * 0.5;\n"\
"    lowp vec4 srcColor = texture2D(texture, v_texCoord);\n"\
"    lowp vec4 color = vec4(0, 0, 0, 0);\n"\
"    color.r = fW3C(srcColor.r, destColor.r);\n"\
"    color.g = fW3C(srcColor.g, destColor.g);\n"\
"    color.b = fW3C(srcColor.b, destColor.b);\n"\
"    color.a = fW3C(srcColor.a, destColor.a) * u_Alpha;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define FRAGMENT_SHADER_MASK_RENDERING_SOFT_LIGHT_ILLUSIONS_HU "#extension GL_EXT_shader_framebuffer_fetch : require\n"\
"\n"\
"precision mediump float;\n"\
"\n"\
"#define kBlendModeNoBlending 0\n"\
"#define kBlendModeMultiply 1\n"\
"\n"\
"uniform sampler2D texture;\n"\
"uniform int blendMode;\n"\
"uniform float u_Alpha;\n"\
"\n"\
"varying vec2 v_texCoord;\n"\
"\n"\
"float fW3C(float a, float b) {\n"\
"   float result = 0.0;\n"\
"   result = pow(a, pow(2.0, (2.0 * (0.5 - b))));\n"\
"   return result;\n"\
"}\n"\
"\n"\
"float overlay(float a, float b) {\n"\
"   float result = 0.0;\n"\
"   if(a <= 0.5) result = 1.0 - (1.0 - a) * (1.0 - b); else result = 2.0 * a * b;\n"\
"   return result;\n"\
"}\n"\
"float multiply(float a, float b) {\n"\
"   float result = a * b;\n"\
"   return result;\n"\
"}\n"\
"\n"\
"void main () {\n"\
"    lowp vec4 destColor = gl_LastFragData[0] * 0.5;\n"\
"    lowp vec4 srcColor = texture2D(texture, v_texCoord);\n"\
"    lowp vec4 color = vec4(0, 0, 0, 0);\n"\
"    color.r = fW3C(srcColor.r, destColor.r) * 0.72;\n"\
"    color.g = fW3C(srcColor.g, destColor.g) * 0.72;\n"\
"    color.b = fW3C(srcColor.b, destColor.b) * 0.72;\n"\
"    color.a = fW3C(srcColor.a, destColor.a);\n"\
"    color.r = multiply(color.r, srcColor.r);\n"\
"    color.g = multiply(color.g, srcColor.g);\n"\
"    color.b = multiply(color.b, srcColor.b);\n"\
"    color.a = multiply(color.a, srcColor.a);\n"\
"    color.a = multiply(color.a, srcColor.a) * u_Alpha;\n"\
"    gl_FragColor = color;\n"\
"}\n"

#define VERTEX_SHADER_MASK_RENDERING "uniform mat4 uMVPMatrix;\n"\
"attribute vec3 a_position;\n"\
"attribute vec2 a_texCoord;\n"\
"varying vec2 v_texCoord;\n"\
"void main() {\n"\
"    gl_Position = uMVPMatrix * vec4(a_position, 1.0);\n"\
"    v_texCoord = a_texCoord;\n"\
"}\n"

#define VERTEX_SHADER_GIF_RENDERING "attribute vec3 a_position;\n"\
"attribute vec2 a_texCoord;\n"\
"varying vec2 v_texCoord;\n"\
"void main() {\n"\
"    gl_Position = vec4(a_position, 1.0);\n"\
"    v_texCoord = a_texCoord;\n"\
"}\n"

#endif /* Header_h */
