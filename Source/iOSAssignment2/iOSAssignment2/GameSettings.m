//
//  GameSettings.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-16.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameSettings.h"

@interface GameSettings ()

@property (assign) BOOL night;

@end


@implementation GameSettings



-(id)init
{
	self = [super init];
	
	_night = false;
	
	// Initialize to default values
	_fogEnabled = 1;
	_ambientColour = GLKVector3Make(1.0, 1.0, 0.8);
	_ambientIntensity = 0.7;
	_fogFar = 6.0;
	
	//_ambientColour = GLKVector3Make(0.3, 0, 1.0);
	//_ambientIntensity = 1;
	
	return self;
}

-(void)setNight:(BOOL)val
{
	_night = val;
	
	if (_night)
	{
		_ambientColour = GLKVector3Make(0.1, 0, 0.1);
		_ambientIntensity = 1;
	}
	else
	{
		_ambientColour = GLKVector3Make(1.0, 1.0, 0.8);
		_ambientIntensity = 0.7;
	}
}

-(void)update:(Program*)program
{
	[program setUniform:@"ambientColour" value:&_ambientColour size:sizeof(_ambientColour)];
	[program setUniform:@"fogEnabled" value:&_fogEnabled size:sizeof(float)];
	[program setUniform:@"fogFar" value:&_fogFar size:sizeof(float)];
	[program setUniform:@"ambientIntensity" value:&_ambientIntensity size:sizeof(float)];
}

+(id)getInstance
{
	static GameSettings *gameSettings = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^
	{
		gameSettings = [[self alloc] init];
	});
	
	return gameSettings;
}


@end