
precision mediump float;
uniform sampler2D u_imageTexture;
varying vec2 v_texCoord;

void main() {
    gl_FragColor = texture2D(u_imageTexture, v_texCoord);
}
