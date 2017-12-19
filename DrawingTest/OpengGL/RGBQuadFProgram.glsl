
precision mediump float;

varying vec2 v_TextureCoordinate;
uniform sampler2D u_TextureBaseRGB;

void main(void) {
    gl_FragColor = texture2D(u_TextureBaseRGB, v_TextureCoordinate);
}
