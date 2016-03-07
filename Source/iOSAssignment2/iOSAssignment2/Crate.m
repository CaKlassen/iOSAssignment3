//
//  Crate.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Crate.h"
#import "CrateData.h"
#import "Vector.h"

@interface Crate ()
{
	float rotation;
}

@end


@implementation Crate

static const NSString* FILE_NAME = @"CrateUV.png";
static const float ROTATE_SPEED = 0.01;


-(id)initWithPosition:(Vector3*)pos
{
	self = [super initWithTextureFile:FILE_NAME pos:CratePositions posSize:sizeof(CratePositions) tex:CrateTexels texSize:sizeof(CrateTexels) norm:CrateNormals normSize:sizeof(CrateNormals)];
	self.position = pos;
	
	rotation = 0;
	
	return self;
}

-(void)update
{
	rotation += ROTATE_SPEED;
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	// Set up the model matrix
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Multiply([camera getLookAt], modelMatrix);
	modelMatrix = GLKMatrix4Translate(modelMatrix, [self.position x], [self.position y], [self.position z]);
	modelMatrix = GLKMatrix4RotateY(modelMatrix, rotation);
	
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
	glDrawArrays(GL_TRIANGLES, 0, CrateVertices);
}

@end
