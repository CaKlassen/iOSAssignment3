//
//  Vector.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector.h"


@implementation Vector2

-(id)initWithValue:(float)xPos yPos:(float)yPos
{
	self = [super init];
	
	_x = xPos;
	_y = yPos;
	
	return self;
}

@end



@implementation Vector3

-(id)initWithValue:(float)xPos yPos:(float)yPos zPos:(float)zPos
{
	self = [super init];
	
	_x = xPos;
	_y = yPos;
	_z = zPos;
	
	return self;
}

@end