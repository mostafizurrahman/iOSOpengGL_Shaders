precision mediump float;

//first texture [BaseRGB] is camera feed
//FaceMask is for drawing any face mask image
//after successfull facedetection.


uniform sampler2D u_TextureBaseRGB;
uniform sampler2D u_TextureFaceMask;

//this two texture is used for fixed animation
uniform sampler2D u_TextureAnimBackground;
uniform sampler2D u_TextureAnimationFrame;

uniform vec4 u_faceRectangle;
uniform float u_faceAngle;

varying vec2 v_TextureCoordinate;


void main(void) {
    gl_FragColor = texture2D(u_RGBTextureBase, v_TextureCoordinate);
}

