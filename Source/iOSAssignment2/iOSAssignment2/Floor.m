//
//  Floor.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Floor.h"
#import "FloorData.h"
#import "Vector.h"

@interface Floor ()
{
	Vector3 *position;
}

@end


@implementation Floor

static const NSString* FILE_NAME = @"FloorUV.png";
static const int SCALE = 20;


-(id)initWithPosition:(Vector3*)pos
{
	self = [super initWithTextureFile:FILE_NAME pos:FloorPositions posSize:sizeof(FloorPositions) tex:FloorTexels texSize:sizeof(FloorTexels) norm:FloorNormals normSize:sizeof(FloorNormals)];
	position = pos;
	return self;
}

-(void)update
{
	
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	// Set up the model matrix
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Multiply([camera getLookAt], modelMatrix);
	modelMatrix = GLKMatrix4Translate(modelMatrix, [position x], [position y], [position z]);
	modelMatrix = GLKMatrix4Scale(modelMatrix, SCALE, SCALE, SCALE);
	
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
	glDrawArrays(GL_TRIANGLES, 0, FloorVertices);
}

@end
