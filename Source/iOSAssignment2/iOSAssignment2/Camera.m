//
//  Camera.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Camera.h"

@interface Camera ()

@property (strong) Vector3* startPos;

@end


@implementation Camera

-(id)initWithPerspective:(GLKMatrix4)matrix position:(Vector3 *)pos
{
	self = [super init];
	
	self.perspective = matrix;
	
	// Set up eye vector and rotation
	self.rotation = [[Vector3 alloc] initWithValue:0 yPos:0 zPos:0];
	self.lookAt = [[Vector3 alloc] initWithValue:0 yPos:0 zPos:-10];
	
	// Set the position
	[self makePosition:pos];
	[self setStartPos:self.position];
	
	
	return self;
}


-(void)makePosition:(Vector3*)pos
{
	self.position = pos;
	
	[self setLookAtTarget];
}

-(void)updatePosition:(Vector3*)pos
{
	self.position.x += pos.x;
	self.position.y += pos.y;
	self.position.z += pos.z;

	[self setLookAtTarget];
}

-(void)moveCamera:(Vector2*)move
{
	GLKMatrix4 rotationMatrix = GLKMatrix4Identity;
	rotationMatrix = GLKMatrix4RotateX(rotationMatrix, self.rotation.x);
	rotationMatrix = GLKMatrix4RotateY(rotationMatrix, self.rotation.y);
	rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, self.rotation.z);
	
	GLKVector3 rotatedMovement = GLKMatrix4MultiplyVector3(rotationMatrix, GLKVector3Make(move.x, 0, move.y));
	
	self.position.x += rotatedMovement.x;
	self.position.y += rotatedMovement.y;
	self.position.z += rotatedMovement.z;
	
	[self setLookAtTarget];
}

-(void)setLookAtTarget
{
	// Rotate the lookat
	GLKMatrix4 rotationMatrix = GLKMatrix4Identity;
	rotationMatrix = GLKMatrix4RotateX(rotationMatrix, self.rotation.x);
	rotationMatrix = GLKMatrix4RotateY(rotationMatrix, self.rotation.y);
	rotationMatrix = GLKMatrix4RotateZ(rotationMatrix, self.rotation.z);
	
	GLKVector3 rotatedLookAt = GLKMatrix4MultiplyVector3(rotationMatrix, GLKVector3Make(self.lookAt.x, self.lookAt.y, self.lookAt.z));
	
	self.target = [[Vector3 alloc] initWithValue:(self.position.x + rotatedLookAt.x) yPos:(self.position.y + rotatedLookAt.y) zPos:(self.position.z + rotatedLookAt.z)];
}


-(void)updateRotation:(Vector3*)rot
{
	self.rotation.x += rot.x;
	self.rotation.y += rot.y;
	self.rotation.z += rot.z;
	
	[self setLookAtTarget];
}

-(void)reset
{
	_position = [[Vector3 alloc] initWithValue:[_startPos x] yPos:[_startPos y] zPos:[_startPos z]];
	_rotation = [[Vector3 alloc] initWithValue:0 yPos:0 zPos:0];
}


-(GLKMatrix4)getLookAt
{
	return GLKMatrix4MakeLookAt(
						 self.position.x, self.position.y, self.position.z, // Where we are
						 self.target.x, self.target.y, self.target.z,		// What we're looking at
								0, 1, 0);
}


@end