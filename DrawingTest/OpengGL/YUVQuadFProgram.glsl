
precision mediump float;

varying vec2 v_TextureCoordinate;

uniform sampler2D u_UVTextureBase;
uniform sampler2D u_YTextureBase;

void main(void) {
    gl_FragColor = texture2D(u_UVTextureBase, v_TextureCoordinate);
}
