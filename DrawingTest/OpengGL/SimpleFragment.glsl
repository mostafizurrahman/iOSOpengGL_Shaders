
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

varying lowp vec4 DestinationColor; // 1


varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New
uniform sampler2D TextureFloor;
uniform sampler2D TextureTop;


#define SIGMA 5.0
#define BSIGMA 0.1
#define MSIZE 10






// viewport resolution (in pixels)
//uniform sampler2D texture;          // input channel. XX = 2D/Cube

//uniform float sigma;


float normpdf(in float x, in float sigma)
{
    return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

float normpdf3(in vec3 v, in float sigma)
{
    return 0.39894*exp(-0.5*dot(v,v)/(sigma*sigma))/sigma;
}


void main(void)
{
    float sigma = SIGMA;
    vec2 resolution = vec2(400, 400);
    //vec3 c = texture2D(texture, vec2(0.0, 1.0)-(gl_FragCoord.xy / resolution.xy)).rgb;
    vec2 t = gl_FragCoord.xy / resolution.xy;
    t.y = 1.0-t.y;
    
    vec3 c = texture2D(Texture, t).rgb;
    
    //declare stuff
    const int kSize = (MSIZE-1)/2;
    float kernel[MSIZE];
    vec3 final_colour = vec3(0.0);
    
    //create the 1-D kernel
    float Z = 0.0;
    for (int j = 0; j <= kSize; ++j)
    {
        kernel[kSize+j] = kernel[kSize-j] = normpdf(float(j), sigma);
    }
    
    
    vec3 cc;
    float factor;
    float bZ = 1.0/normpdf(0.0, BSIGMA);
    //read out the texels
    for (int i=-kSize; i <= kSize; ++i)
    {
        for (int j=-kSize; j <= kSize; ++j)
        {
            vec2 tt = (gl_FragCoord.xy+vec2(float(i),float(j))) / resolution.xy;
            tt.y = 1.0-tt.y;
            cc = texture2D(Texture, tt).rgb;
            factor = normpdf3(cc-c, BSIGMA)*bZ*kernel[kSize+j]*kernel[kSize+i];
            Z += factor;
            final_colour += factor*cc;
            
        }
    }		
    
    gl_FragColor = vec4(final_colour/Z, 1.0);
    
}


/*
 
 
 */
