//
//  Enemy.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-03-06.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
#import "EnemyData.h"
#import "Vector.h"

@interface Enemy ()
{
	float rotationX;
	float rotationY;
	float translationX;
	float translationY;
	float translationZ;
	float scale;
}

@end


@implementation Enemy

static const NSString* FILE_NAME = @"EnemyUV.png";


-(id)initWithPosition:(Vector3*)pos
{
	self = [super initWithTextureFile:FILE_NAME pos:EnemyPositions posSize:sizeof(EnemyPositions) tex:EnemyTexels texSize:sizeof(EnemyTexels) norm:EnemyNormals normSize:sizeof(EnemyNormals)];
	_position = pos;
	
	rotationY = 0;
	rotationX = 0;
	translationX = 0;
	translationY = 0;
	translationZ = 0;
	scale = 0.5f;
	
	_state = NO;
	
	return self;
}

-(void)toggleState
{
	_state = !_state;
	
	if (!_state)
	{
		// Reset any user-made transformations
		translationX = 0;
		translationY = 0;
		translationZ = 0;
		scale = 0;
		rotationY = 0;
		rotationX = 0;
	}
}

-(void)rotate:(float)x y:(float)y
{
	rotationX += x;
	rotationY += y;
}

-(void)translate:(float)x y:(float)y z:(float)z
{
	translationX += x;
	translationY += y;
	translationZ += z;
}


-(void)scale:(float)val
{
	scale += val;
}

-(void)update
{
	if (_state)
	{
		// If we are moving around
	}
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	// Set up the model matrix
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Multiply([camera getLookAt], modelMatrix);
	modelMatrix = GLKMatrix4Translate(modelMatrix, translationX, translationY, translationZ);
	modelMatrix = GLKMatrix4Translate(modelMatrix, [_position x], [_position y], [_position z]);
	modelMatrix = GLKMatrix4RotateY(modelMatrix, rotationY);
	modelMatrix = GLKMatrix4RotateX(modelMatrix, rotationX);
	modelMatrix = GLKMatrix4Scale(modelMatrix, scale, scale, scale);
	
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
	glDrawArrays(GL_TRIANGLES, 0, EnemyVertices);
}

@end
