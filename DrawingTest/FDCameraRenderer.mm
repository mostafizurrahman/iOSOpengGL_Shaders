
//
//  FDCameraRenderer.m
//  IPVFaceDetectioniOS
//
//  Created by Nishu on 1/2/17.
//  Copyright © 2017 Mostafizur Rahman. All rights reserved.
//

#import "FDCameraRenderer.h"
#import "FDShaders.h"
#include <iostream>
#include <vector>
#import <CoreMedia/CoreMedia.h>
#import "TextureLoader.h"
#import <OpenGLES/ES2/glext.h>
#import <UIKit/UIKit.h>


#define DISTANCE_NORMALIZATION_FACTOR 7
#define TEXEL_OFFSET 3

using namespace std;

@interface FDCameraRenderer() {
	TextureLoader* yTextureLoader;
	TextureLoader* uvTextureLoader;
	TextureLoader* offscreenTextureLoader;
	TextureLoader* offscreenTextureLoader2;
	
	GLuint vertexBufferID;
	GLuint indexBufferID;
	
	GLuint yuvPipelineObject;
	GLuint yuvVertexShader;
	GLuint yuvFragmentShader;
	
	
	GLuint bilateralPipelineObject;
	GLuint bilateralVertexShader;
	GLuint bilateralFragmentShader;
	
	TextureLoader* blendTextureLoader;
	GLuint blendTextureLocation;
	
	GLuint resolutionLocation;
	
	GLuint yTextureLocation;
	GLuint uvTextureLocation;
	GLuint textureCoordinateLocation;
	GLuint vertexLocation;
	
	GLuint dnFactorLocation;
	GLuint inputTextureLocation;
	GLuint bilateralTextureCoordinateLocation;
	GLuint bilateralVertexLocation;
	
	GLuint texelWidthOffsetLocation;
	GLuint texelHeightOffsetLocation;
	
	GLint defaultFrameBuffer;
	GLuint frameBuffer[2];
	
	int numOfPixels;
	unsigned char* yBuffer;
	unsigned char* uvBuffer;
	BOOL drawCameraSampleBuffer;
	
	GLubyte indices[6];
	GLVertexData_t vertices[4];
	CGSize cameraResolution;
}

@end

@implementation FDCameraRenderer
- (instancetype) init{
	
	self = [super init];
	if (self) {
		yBuffer = NULL;
		uvBuffer = NULL;
		drawCameraSampleBuffer = NO;
		
		GLVertexData_t obj1, obj2, obj3, obj4;
		obj1.position[0] = -1.f;
		obj1.position[1] = 1.f;
		obj1.position[2] = 0.f;
		obj1.uv[0] = 0.f;
		obj1.uv[1] = 0.f;
		
		obj2.position[0] = -1.f;
		obj2.position[1] = -1.f;
		obj2.position[2] = 0.f;
		obj2.uv[0] = 0.f;
		obj2.uv[1] = 1.f;
		
		obj3.position[0] = 1.f;
		obj3.position[1] = -1.f;
		obj3.position[2] = 0.f;
		obj3.uv[0] = 1.f;
		obj3.uv[1] = 1.f;
		
		obj4.position[0] = 1.f;
		obj4.position[1] = 1.f;
		obj4.position[2] = 0.f;
		obj4.uv[0] = 1.f;
		obj4.uv[1] = 0.f;
		
		vertices[0] = obj1;
		vertices[1] = obj2;
		vertices[2] = obj3;
		vertices[3] = obj4;
		
		indices[0] = 0;
		indices[1] = 1;
		indices[2] = 2;
		indices[3] = 0;
		indices[4] = 2;
		indices[5] = 3;
		
		yTextureLoader = [[TextureLoader alloc] init];
		uvTextureLoader = [[TextureLoader alloc] init];
		offscreenTextureLoader = [[TextureLoader alloc] init];
		offscreenTextureLoader2 = [[TextureLoader alloc] init];
		
		blendTextureLoader = [[TextureLoader alloc] init];
		
		cameraResolution = CGSizeMake(1072, 1920);
        [self setCameraResolution:cameraResolution];
		yuvPipelineObject = 0;
		bilateralPipelineObject = 0;
		
		glGenFramebuffers(2, frameBuffer);
		glGenProgramPipelinesEXT(1, &yuvPipelineObject);
		glGenProgramPipelinesEXT(1, &bilateralPipelineObject);
		
		[self loadShaders];
		[self loadProgramPipelines];
		[self loadYuvUniformLocation];
		[self loadBilateralUniformLocation];
		[self setupBuffers];
		[self setupTextures];
	}
	return self;
}

- (void) setCameraResolution:(CGSize)resolution {
    
    
    
    
	cameraResolution = resolution;
	numOfPixels = cameraResolution.width * cameraResolution.height;
	
	if (yBuffer != NULL) {
		delete [] yBuffer;
	}
	
	if (uvBuffer != NULL) {
		delete [] uvBuffer;
	}
	
	yBuffer = new unsigned char[numOfPixels];
	uvBuffer = new unsigned char[numOfPixels / 2];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		[self setupTextures];
	});
}

- (void) updateCameraData:(const unsigned char *const)yPlaneData
				   UVData:(const unsigned char *const)uvPlaneData {
	memcpy(yBuffer, yPlaneData, numOfPixels);
	memcpy(uvBuffer, uvPlaneData, numOfPixels / 2);
	drawCameraSampleBuffer = YES;
}

- (void) updateSampleBuffer:(CMSampleBufferRef)sampleBuffer {
	CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
	// lock pixel buffer
	CVPixelBufferLockBaseAddress(imageBuffer, 0);
	const unsigned char* yBuf = (unsigned char*)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);
	memcpy(yBuffer, yBuf, numOfPixels);
	CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
	
	CVPixelBufferLockBaseAddress(imageBuffer, 1);
	const unsigned char* uvBuf = (unsigned char*)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 1);
	memcpy(uvBuffer, uvBuf, numOfPixels/2);
	CVPixelBufferUnlockBaseAddress(imageBuffer, 1);
	
	drawCameraSampleBuffer = numOfPixels != 0;
}

-(void)loadShaders {
	const GLchar* yuvVertexShaderText = [VERTEX_SHADER_CAMERA_PREVIEW UTF8String];
	const GLchar* bilateralVertexShaderText = [VERTEX_SHADER_BILATERAL UTF8String];
	const GLchar* bilateralFragmentShaderText = [FRAGMENT_SHADER_BILATERAL UTF8String];
	
	yuvVertexShader = glCreateShaderProgramvEXT(GL_VERTEX_SHADER, 1, &yuvVertexShaderText);
	
	bilateralVertexShader = glCreateShaderProgramvEXT(GL_VERTEX_SHADER, 1, &bilateralVertexShaderText);
	bilateralFragmentShader = glCreateShaderProgramvEXT(GL_FRAGMENT_SHADER, 1, &bilateralFragmentShaderText);
	
	[self loadFragmentShader:FRAGMENT_SHADER_CAMERA_PREVIEW];
	
}

-(void)loadFragmentShader:(NSString*)fragmentShaderString{

	const GLchar* yuvFragmentShaderText = [fragmentShaderString UTF8String];
	yuvFragmentShader = glCreateShaderProgramvEXT(GL_FRAGMENT_SHADER, 1, &yuvFragmentShaderText);

}

//-(void)updateFilter:(ImageFilterType)filter BlendImagePath:(NSString*)blendImagePath{
//    
//    if (blendImagePath != nil) {
//        [blendTextureLoader generateTexture:blendImagePath];
//    }
//    
//    
//    switch (filter) {
//        case NORMAL:
//            [self loadFragmentShader:FRAGMENT_SHADER_CAMERA_PREVIEW];
//            break;
//            
//        case COLOR_BURN:
//            [self loadFragmentShader:FRAGMENT_SHADER_COLOR_BURN];
//            break;
//            
//        case CROSS_PROCESS:
//            [self loadFragmentShader:FRAGMENT_SHADER_CROSS_PROCESS];
//            break;
//        case DARKEN:
//            [self loadFragmentShader:FRAGMENT_SHADER_DARKEN];
//            break;
//        case GRAYSCALE:
//            [self loadFragmentShader:FRAGMENT_SHADER_GRAYSCALE];
//            break;
//        case HUE_EFFECT:
//            [self loadFragmentShader:FRAGMENT_SHADER_HUE];
//            break;
//        case INTERPOLATIVE:
//            [self loadFragmentShader:FRAGMENT_SHADER_INTERPOLATIVE];
//            break;
//        case INVERT:
//            [self loadFragmentShader:FRAGMENT_SHADER_INVERT];
//            break;
//        case OVERLAY:
//            [self loadFragmentShader:FRAGMENT_SHADER_OVERLAY];
//            break;
//        case POSTERIZE:
//            [self loadFragmentShader:FRAGMENT_SHADER_POSTERIZE];
//            break;
//        case SEPIA:
//            [self loadFragmentShader:FRAGMENT_SHADER_SEPIA];
//            break;
//        case TEMPERATURE_EFFECT:
//            [self loadFragmentShader:FRAGMENT_SHADER_TEMP];
//            break;
//        case RETRO:
//            [self loadFragmentShader:FRAGMENT_SHADER_RETRO];
//            break;
//        case RETRO_VIGNETTE:
//            [self loadFragmentShader:FRAGMENT_SHADER_RETRO_VIGNETTE];
//            break;
//        case VIGNETTE:
//            [self loadFragmentShader:FRAGMENT_SHADER_VIGNETTE];
//            break;
//        case GRADIENT:
//            [self loadFragmentShader:FRAGMENT_SHADER_GRADIENT];
//            break;
//        case BLEACH:
//            [self loadFragmentShader:FRAGMENT_SHADER_BLEACH];
//            break;
//        default:
//            [self loadFragmentShader:FRAGMENT_SHADER_CAMERA_PREVIEW];
//            break;
//    }
//    
//    [self loadProgramPipelines];
//    [self loadYuvUniformLocation];
//    
//}

- (void) loadProgramPipelines {
	
	
	glBindProgramPipelineEXT(yuvPipelineObject);
	glUseProgramStagesEXT(yuvPipelineObject, GL_VERTEX_SHADER_BIT_EXT, yuvVertexShader);
	glUseProgramStagesEXT(yuvPipelineObject, GL_FRAGMENT_SHADER_BIT_EXT, yuvFragmentShader);
	
	
	glBindProgramPipelineEXT(bilateralPipelineObject);
	glUseProgramStagesEXT(bilateralPipelineObject, GL_VERTEX_SHADER_BIT_EXT, bilateralVertexShader);
	glUseProgramStagesEXT(bilateralPipelineObject, GL_FRAGMENT_SHADER_BIT_EXT, bilateralFragmentShader);
}

-(void)loadYuvUniformLocation{
	
	yTextureLocation = glGetUniformLocation(yuvFragmentShader, "y_texture");
	uvTextureLocation = glGetUniformLocation(yuvFragmentShader, "uv_texture");
	blendTextureLocation = glGetUniformLocation(yuvFragmentShader, "blend_texture");
	resolutionLocation = glGetUniformLocation(yuvFragmentShader, "resolution");
	
	vertexLocation = glGetAttribLocation(yuvVertexShader, "a_position");
	textureCoordinateLocation = glGetAttribLocation(yuvVertexShader, "a_texCoord");
	
}

-(void)loadBilateralUniformLocation{
	
	dnFactorLocation = glGetUniformLocation(bilateralFragmentShader, "distanceNormalizationFactor");
	inputTextureLocation = glGetUniformLocation(bilateralFragmentShader, "inputImageTexture");
	
	texelWidthOffsetLocation = glGetUniformLocation(bilateralVertexShader, "texelWidthOffset");
	texelHeightOffsetLocation = glGetUniformLocation(bilateralVertexShader, "texelHeightOffset");
	
	bilateralVertexLocation = glGetAttribLocation(bilateralVertexShader, "a_position");
	bilateralTextureCoordinateLocation = glGetAttribLocation(bilateralVertexShader, "a_texCoord");
	
}

- (void) setupBuffers {
	glGenBuffers(1, &vertexBufferID);
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
	
	glGenBuffers(1, &indexBufferID);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferID);
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
}

- (void) setupTextures {
	[yTextureLoader deleteTexture];
	[uvTextureLoader deleteTexture];
	[offscreenTextureLoader deleteTexture];
	[offscreenTextureLoader2 deleteTexture];
	
	[yTextureLoader generateTexture];
	[uvTextureLoader generateTexture];
	[offscreenTextureLoader generateTextureOfSize:cameraResolution];
	[offscreenTextureLoader2 generateTextureOfSize:cameraResolution];
}


-(void)renderYUVInTextureoffscreen:(BOOL)offscreen{
	if(offscreen){
		glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer[0]);
	}else{
		glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
	}
	if(offscreen){
		[offscreenTextureLoader renderFramebufferToTexture:frameBuffer[0]];
	}
	
	glBindProgramPipelineEXT(yuvPipelineObject);
	
	glProgramUniform2fEXT(yuvFragmentShader, resolutionLocation, cameraResolution.width, cameraResolution.height);
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
	glEnableVertexAttribArray(vertexLocation);
	glVertexAttribPointer(vertexLocation, 3, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
						  (GLvoid*) offsetof(GLVertexData_t, position));
	glEnableVertexAttribArray(textureCoordinateLocation);
	glVertexAttribPointer(textureCoordinateLocation, 2, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
						  (GLvoid*) offsetof(GLVertexData_t, uv));
	
	UploadData uploadData = {};
	
	uploadData.data = yBuffer;
	uploadData.textureSize = cameraResolution;
	uploadData.textureFormat = GL_RED_EXT;
	
	
	[yTextureLoader activeTexture:1];
	[yTextureLoader uploadData:uploadData];
	
	glProgramUniform1iEXT(yuvFragmentShader, yTextureLocation, 1);
	
	UploadData uploadData2 = {};
	
	uploadData2.data = uvBuffer;
	uploadData2.textureSize = CGSizeMake(cameraResolution.width / 2, cameraResolution.height / 2);
	uploadData2.textureFormat = GL_RG_EXT;
	
	[uvTextureLoader activeTexture:2];
	[uvTextureLoader uploadData:uploadData2];
	
	glProgramUniform1iEXT(yuvFragmentShader, uvTextureLocation, 2);
	
	[blendTextureLoader activeTexture:3];
	glProgramUniform1iEXT(yuvFragmentShader, blendTextureLocation, 3);
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferID);
	
	glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
	
	glDisableVertexAttribArray(vertexLocation);
	glDisableVertexAttribArray(textureCoordinateLocation);
	
	
}

-(void)renderBilateraloffscreen:(BOOL)offscreen{
	
	if (offscreen) {
		glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer[1]);
	}else{
		glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
		
	}
	
	if(offscreen){
		[offscreenTextureLoader2 renderFramebufferToTexture:frameBuffer[1]];
	}
	
	glBindProgramPipelineEXT(bilateralPipelineObject);
	
	glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
	glEnableVertexAttribArray(bilateralVertexLocation);
	glVertexAttribPointer(bilateralVertexLocation, 3, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
						  (GLvoid*) offsetof(GLVertexData_t, position));
	glEnableVertexAttribArray(bilateralTextureCoordinateLocation);
	glVertexAttribPointer(bilateralTextureCoordinateLocation, 2, GL_FLOAT, GL_FALSE, sizeof(GLVertexData_t),
						  (GLvoid*) offsetof(GLVertexData_t, uv));
	
	glProgramUniform1fEXT(bilateralFragmentShader, dnFactorLocation,DISTANCE_NORMALIZATION_FACTOR);
	
	float texelHeightOffset = TEXEL_OFFSET/cameraResolution.width;
	float texelWidthOffset = TEXEL_OFFSET/cameraResolution.height;
	
	if(offscreen){
		glProgramUniform1fEXT(bilateralVertexShader, texelWidthOffsetLocation,0.000000);
		glProgramUniform1fEXT(bilateralVertexShader, texelHeightOffsetLocation,texelHeightOffset);
		[offscreenTextureLoader activeTexture:3];
		glProgramUniform1iEXT(bilateralFragmentShader, inputTextureLocation, 3);
	}else{
		
		glProgramUniform1fEXT(bilateralVertexShader, texelWidthOffsetLocation,texelWidthOffset);
		glProgramUniform1fEXT(bilateralVertexShader, texelHeightOffsetLocation,0.000000);
		[offscreenTextureLoader2 activeTexture:4];
		glProgramUniform1iEXT(bilateralFragmentShader, inputTextureLocation, 4);
	}
	
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBufferID);
	
	glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, 0);
	
	glDisableVertexAttribArray(bilateralVertexLocation);
	glDisableVertexAttribArray(bilateralTextureCoordinateLocation);
	
	
}

- (void) render {
	
	if (drawCameraSampleBuffer) {
		
		glGetIntegerv(GL_FRAMEBUFFER_BINDING, &defaultFrameBuffer);
		
		[self renderYUVInTextureoffscreen:YES];
		[self renderBilateraloffscreen:YES];
		[self renderBilateraloffscreen:NO];
	}
	
}

- (void) dealloc {
	
	glDeleteBuffers(1, &indexBufferID);
	glDeleteBuffers(1, &vertexBufferID);
	glDeleteProgramPipelinesEXT(1, &yuvPipelineObject);
	glDeleteProgramPipelinesEXT(1, &bilateralPipelineObject);
	glDeleteFramebuffers(2, frameBuffer);
	[yTextureLoader deleteTexture];
	[uvTextureLoader deleteTexture];
	[offscreenTextureLoader deleteTexture];
	[offscreenTextureLoader2 deleteTexture];
	[blendTextureLoader deleteTexture];
	delete [] yBuffer;
	delete [] uvBuffer;
}

@end
