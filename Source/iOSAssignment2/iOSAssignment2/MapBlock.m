//
//  Map.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapBlock.h"


@implementation MapBlock


static const NSString* FILE_NAME = @"Block.png";

-(id)initWithPosition:(Vector2*)pos
{
	self = [super initWithTextureFile:FILE_NAME];
	
	_pos = pos;
	
	return self;
}

-(void)update
{
	
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	// Set up the model matrix
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Translate(modelMatrix, [_pos x] / 200, [_pos y] / 200, 0);
	modelMatrix = GLKMatrix4Translate(modelMatrix, -0.03, -0.03, -0.1);
	modelMatrix = GLKMatrix4Scale(modelMatrix, 0.0003, 0.0003, 0.0003);
	
	_normalMatrix = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(modelMatrix), NULL);
	
	[self setTexture];
	
	GLKVector3 eyeDir = GLKVector3Make([[camera lookAt] x], [[camera lookAt] y], [[camera lookAt] z]);
	
	GLKMatrix4 viewProj = [camera perspective];
	
	[program setUniform:@"ViewProj" value:&viewProj size:sizeof(viewProj)];
	[program setUniform:@"World" value:&modelMatrix size:sizeof(modelMatrix)];
	[program setUniform:@"normalMatrix" value:&_normalMatrix size:sizeof(_normalMatrix)];
	[program setUniform:@"EyeDirection" value:&eyeDir size:sizeof(eyeDir)];
	
	[program useProgram:_vertexArray];
	
	//draw the model
	glDrawArrays(GL_TRIANGLES, 0, NumVertices);
}


@end