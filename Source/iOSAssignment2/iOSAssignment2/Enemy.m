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
#import "Wall.h"

@interface Enemy ()
{
	NSMutableArray *wallList;
	
	float rotationX;
	float rotationY;
	float translationX;
	float translationY;
	float translationZ;
	float scale;
	
	int moveDir;
	int waitTimer;
	int moveTimer;
	bool moving;
	Vector3 *prevPos;
}

@end


@implementation Enemy

static const NSString* FILE_NAME = @"EnemyUV.png";
static const int WAIT_TIMER = 45;
static const int MOVE_TIMER = 120;
static const float MOVE_SPEED = 0.05f;

-(id)initWithPosition:(Vector3*)pos wallList:(NSMutableArray*)walls
{
	self = [super initWithTextureFile:FILE_NAME pos:EnemyPositions posSize:sizeof(EnemyPositions) tex:EnemyTexels texSize:sizeof(EnemyTexels) norm:EnemyNormals normSize:sizeof(EnemyNormals)];
	self.position = pos;
	wallList = walls;
	
	rotationY = 0;
	rotationX = 0;
	translationX = 0;
	translationY = 0;
	translationZ = 0;
	scale = 0.5f;
	
	_state = NO;
	
	moveDir = -1;
	waitTimer = WAIT_TIMER;
	moveTimer = MOVE_TIMER;
	moving = false;
	
	prevPos = pos;
	
	return self;
}

-(void)toggleState
{
	_state = !_state;
	
	if (_state)
	{
		// Reset any user-made transformations
		translationX = 0;
		translationY = 0;
		translationZ = 0;
		scale = 0.5f;
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
		if (!moving)
		{
			if (waitTimer > 0)
			{
				waitTimer--;
			}
			else
			{
				waitTimer = WAIT_TIMER;
				moving = YES;
				moveDir = arc4random_uniform(4);
				
				
				prevPos = self.position;
			}
		}
		else
		{
			// Move
			if (moveTimer > 0)
			{
				switch(moveDir)
				{
					case 0:
					{
						[self.position setX:([self.position x] + MOVE_SPEED)];
						break;
					}
					case 1:
					{
						[self.position setX:([self.position x] - MOVE_SPEED)];
						break;
					}
					case 2:
					{
						[self.position setZ:([self.position z] + MOVE_SPEED)];
						break;
					}
					case 3:
					{
						[self.position setZ:([self.position z] - MOVE_SPEED)];
						break;
					}
				}
				
				moveTimer--;
			}
			else
			{
				moveTimer = MOVE_TIMER;
				moving = false;
			}
			
			// Check for collisions
			CGRect bbox = [self boundingBox];
			
			for (Wall *wall in wallList)
			{
				CGRect wallBox = [wall boundingBox];
				
				if (CGRectIntersectsRect(bbox, wallBox))
				{
					NSLog(@"%f, %f (%f, %f) - %f, %f (%f, %f)", bbox.origin.x, bbox.origin.y, bbox.size.width, bbox.size.height, wallBox.origin.x, wallBox.origin.y, wallBox.size.width, wallBox.size.height);
					
					self.position = prevPos;
					moving = false;
					
					NSLog(@"Collision!");
					break;
				}
			}
		}
	}
}

-(CGRect)boundingBox
{
	CGRect result = CGRectMake(self.position.x, self.position.z, self.bboxSize.x, self.bboxSize.y);
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Translate(modelMatrix, translationX, translationY, translationZ);
	modelMatrix = GLKMatrix4Translate(modelMatrix, [self.position x], [self.position y], [self.position z]);
	modelMatrix = GLKMatrix4RotateY(modelMatrix, rotationY);
	modelMatrix = GLKMatrix4RotateX(modelMatrix, rotationX);
	modelMatrix = GLKMatrix4Scale(modelMatrix, scale, scale, scale);
	
	CGAffineTransform transform = CGAffineTransformMake(modelMatrix.m00, modelMatrix.m01, modelMatrix.m10, modelMatrix.m11, modelMatrix.m30, modelMatrix.m31);
	return CGRectApplyAffineTransform(result, transform);
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	// Set up the model matrix
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Multiply([camera getLookAt], modelMatrix);
	modelMatrix = GLKMatrix4Translate(modelMatrix, translationX, translationY, translationZ);
	modelMatrix = GLKMatrix4Translate(modelMatrix, [self.position x], [self.position y], [self.position z]);
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
