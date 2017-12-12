
precision mediump float;

varying vec2 v_TextureCoordinate;
uniform sampler2D u_RGBTextureBase;

void main(void) {
    gl_FragColor = texture2D(u_RGBTextureBase, v_TextureCoordinate);
}
