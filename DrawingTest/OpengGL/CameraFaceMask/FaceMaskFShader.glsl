precision mediump float;

//first texture [BaseRGB] is camera feed
//FaceMask is for drawing any face mask image
//after successfull facedetection.


uniform sampler2D u_TextureBaseRGB;
uniform sampler2D u_TextureFaceMask;

//this two texture is used for fixed animation
uniform sampler2D u_TextureAnimBackground;
uniform sampler2D u_TextureAnimationFrame;

//this texture is for mask sticker image
uniform sampler2D u_TextureStickerTexture;


uniform vec4 u_faceRectangle;
uniform float u_faceAngle;

varying vec2 v_TextureCoordinate;


void main(void) {
    
    vec4 cameraPixel =  texture2D(u_RGBTextureBase, v_TextureCoordinate);
    vec4 backgroundPixel =  texture2D(u_TextureAnimBackground, v_TextureCoordinate);
    vec4 framePixel =  texture2D(u_TextureAnimationFrame, v_TextureCoordinate);
    vec4 stickerPixel =  texture2D(u_TextureStickerTexture, v_TextureCoordinate);
    float alpha = backgroundPixel.a;
    vec4 pixel = cameraPixel * (1.0 - alpha) + vec4(backgroundPixel.rgb * alpha, alpha);
    alpha = framePixel.a;
    pixel = pixel * (1.0 - alpha) + vec4(framePixel.rgb * alpha, alpha);
    alpha = stickerPixel.a;
    pixel = pixel * (1.0 - alpha) + vec4(stickerPixel.rgb * alpha, alpha);
    gl_FragColor = pixel;
}

