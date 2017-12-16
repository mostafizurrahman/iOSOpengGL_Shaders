
precision mediump float;

varying vec2 v_TextureCoordinate;

uniform sampler2D u_TextureBaseUV;
uniform sampler2D u_TextureBaseY;

void main(void) {
    gl_FragColor = texture2D(u_UVTextureBase, v_TextureCoordinate);
}
