//
//  Sprite.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

float QuadVertices[18];

const float QuadNormals[] =
{
	0, -0, 1,
	0, -0, 1,
	0, -0, 1,
	0, -0, 1,
	0, -0, 1,
	0, -0, 1,
};

const float QuadTexels [] =
{
	0, 1,
	0, 0,
	1, 0,
	1, 1,
	0, 1,
	1, 0,
};

@interface Sprite()

@property (strong) GLKTextureInfo *textureInfo;
@property (assign) GLuint texName;

@end

@implementation Sprite

- (id)initWithTextureFile:(const NSString *)fileName
{
	if (self = [super init])
	{
		NumVertices = 6;
		
		CGImageRef TexImage = [UIImage imageNamed:fileName].CGImage;
		if(!TexImage){
			NSLog(@"failed to load image %@", fileName);
			exit(1);
		}
		
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
		
		float Hwidth = width/2.0f;
		float Hheight = height/2.0f;
		
		QuadVertices[0] = -Hwidth;
		QuadVertices[1] = Hheight;
		QuadVertices[2] = 0;
		QuadVertices[3] = -Hwidth;
		QuadVertices[4] = -Hheight;
		QuadVertices[5] = 0;
		QuadVertices[6] = Hwidth;
		QuadVertices[7] = -Hheight;
		QuadVertices[8] = 0;
		QuadVertices[9] = Hwidth;
		QuadVertices[10] = Hheight;
		QuadVertices[11] = 0;
		QuadVertices[12] = -Hwidth;
		QuadVertices[13] = Hheight;
		QuadVertices[14] = 0;
		QuadVertices[15] = Hwidth;
		QuadVertices[16] = -Hheight;
		QuadVertices[17] = 0;
		
		glGenVertexArraysOES(1, &_vertexArray);
		glBindVertexArrayOES(_vertexArray);
		
		glGenBuffers(1, &_vertexBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(QuadVertices), QuadVertices, GL_STATIC_DRAW);
		
		
		glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(0);
		
		glGenBuffers(1, &_NormalBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _NormalBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(QuadNormals), QuadNormals, GL_STATIC_DRAW);
		
		
		glVertexAttribPointer(2, 3, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(2);
		
		glGenBuffers(1, &_texelBuffer);
		glBindBuffer(GL_ARRAY_BUFFER, _texelBuffer);
		glBufferData(GL_ARRAY_BUFFER, sizeof(QuadTexels), QuadTexels, GL_STATIC_DRAW);
		
		glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, NULL);
		glEnableVertexAttribArray(1);
	}
	
	return self;
}


-(void)update
{
	
}

-(void)draw:(Program*)program camera:(Camera*)camera
{
	
}

-(void)setTexture
{
	glBindTexture(GL_TEXTURE_2D, _texName);
}

@end