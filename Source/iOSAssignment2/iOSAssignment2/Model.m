//
//  Model.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"
#import "TextureLoader.h"

@interface Model()

@property (strong) GLKTextureInfo *texture;
@property (assign) GLuint texName;

@end


@implementation Model

-(id)initWithTextureFile:(const NSString *)fileName pos:(const float *)Positions posSize:(int)posSize tex:(const float *)Texels texSize:(int)texSize norm:(const float *)Normals normSize:(int)normSize
{
	if(self = [super init])
	{
		//load texture for GLSL
		CGImageRef TexImage = [TextureLoader loadImage:fileName];
		
		size_t width = CGImageGetWidth(TexImage);
		size_t height = CGImageGetHeight(TexImage);
		
		GLubyte* texData = (GLubyte *) calloc(width*height*4, sizeof(GLubyte));
		
		CGContextRef texContext = CGBitmapContextCreate(texData, width, height, 8, width*4, CGImageGetColorSpace(TexImage), kCGImageAlphaPremultipliedLast);
		
		// Flip the image because OpenGL has a reversed V axis
		CGContextTranslateCTM(texContext, 0.0, height);
		CGContextScaleCTM(texContext, 1.0, -1.0);
		
		CGContextDrawImage(texContext, CGRectMake(0, 0, width, height), TexImage);
		CGContextRelease(texContext);
		
		glGenTextures(1, &_texName);
		glBindTexture(GL_TEXTURE_2D, _texName);
		
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, texData);
		
		free(texData);//free it, it's on the GPU now
		//return the texture name
		
		//bind the vertex buffer (send model vertex data to GPU)
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, posSize, Positions, GL_STATIC_DRAW);
		
		//positions
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(0);
		
		
		glGenBuffers(1, &_texelBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _texelBuffer);
		glBufferData(GL_ARRAY_BUFFER, texSize, Texels, GL_STATIC_DRAW);
		
		//Texels
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(1);
		
		glGenBuffers(1, &_NormalBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _NormalBuffer);
		glBufferData(GL_ARRAY_BUFFER, normSize, Normals, GL_STATIC_DRAW);
		
		//normals
		glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(2);
		
		
	}
	
	return self;
}

-(void)setTexture
{
	glBindTexture(GL_TEXTURE_2D, _texName);
}


-(void)update
{
	
}

-(void)draw:(Program*)program camera:(Camera*)camera
{
	
}

@end