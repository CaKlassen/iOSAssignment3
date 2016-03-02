//
//  GameScene.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"
#import "GameViewController.h"
#import "Wall.h"
#import "Floor.h"
#import "BasicProgram.h"
#import "SpriteProgram.h"
#import "Vector.h"
#import "Camera.h"
#import "Crate.h"
#import "MazeBuilder.h"
#import "GameSettings.h"
#import "Map.h"


@interface GameScene ()
{
	Camera *camera;
	
	NSMutableArray *wallList;
	Floor *floor;
	Crate *crate;
	
	GameSettings *gameSettings;
	BasicProgram *basicProgram;
	SpriteProgram *spriteProgram;
	MazeBuilder *builder;
	
	Map *map;
	
	CGPoint touchStart;
}

@end


@implementation GameScene

-(id)init
{
	self = [super init];
	
	gameSettings = [GameSettings getInstance];
	
	wallList = [[NSMutableArray alloc] init];
	floor = [[Floor alloc] initWithPosition:[[Vector3 alloc] initWithValue:0 yPos:0 zPos:0]];
	
	basicProgram = [[BasicProgram alloc] init];
	spriteProgram = [[SpriteProgram alloc] init];
	
	builder = [[MazeBuilder alloc] init];
	[builder buildMaze];
	[builder createMazeElements:wallList];
	
	[self initCamera];
	
	// Create the crate
	crate = [[Crate alloc] initWithPosition:[[Vector3 alloc] initWithValue:MAX(0, [[builder startPos] x]) yPos:2 zPos:MAX([[builder startPos] y], 0)]];
	
	map = [[Map alloc] initWithBlocks:wallList];
	
	return self;
}

-(void)update
{
	[gameSettings update:basicProgram];
	
	[crate update];
}

-(void)draw
{
	glClearColor(0.5f, 0.5f, 0.5f, 1.0);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	
	for (Wall *wall in wallList)
	{
		[wall draw:basicProgram camera:camera];
	}
	
	[floor draw:basicProgram camera:camera];
	[crate draw:basicProgram camera:camera];
	
	[map draw:spriteProgram camera:camera];
}


-(void)pan:(UIPanGestureRecognizer*)recognizer
{
	if (recognizer.numberOfTouches == 1)
	{
		// Movement and turning
		
		CGPoint touchLocation = [recognizer locationInView:recognizer.view];
		
		if ([recognizer state] == UIGestureRecognizerStateBegan)
		{
			touchStart = touchLocation;
		}
		else
		{
			// Determine the distance travelled
			CGPoint dis;
			dis.x = (touchLocation.x - touchStart.x) / 130; // Turning
			dis.y = (touchLocation.y - touchStart.y) / 30; // Walking
			
			touchStart = touchLocation;
			
			[camera moveCamera:[[Vector2 alloc] initWithValue:dis.x yPos:dis.y]];
			[camera updateRotation:[[Vector3 alloc] initWithValue:0 yPos:-dis.x zPos:0]];
		}
	}
	else
	{
		// Changing fog parameters
		CGPoint touchLocation = [recognizer locationInView:recognizer.view];
		
		if ([recognizer state] == UIGestureRecognizerStateBegan)
		{
			touchStart = touchLocation;
		}
		else
		{
			// Determine the distance moved
			CGPoint dis;
			dis.x = (touchLocation.x - touchStart.x) / 30; // Fog far
			dis.y = (touchLocation.y - touchStart.y);
			
			touchStart = touchLocation;
			
			[gameSettings setFogFar:([gameSettings fogFar] + dis.x)];
			
			if (dis.y < -20)
			{
				// Toggle fog on
				[gameSettings setFogEnabled:YES];
			}
			else if (dis.y > 20)
			{
				// Toggle fog off
				[gameSettings setFogEnabled:NO];
			}
			
		}

	}
}


-(void)doubleTap:(UITapGestureRecognizer*)recognizer
{
	// Return to the start
	[camera reset];
	[camera makePosition:[[Vector3 alloc] initWithValue:[[builder startPos] x] yPos:2 zPos:[[builder startPos] y]]];
	[camera updateRotation:[[Vector3 alloc] initWithValue:0 yPos:[builder startAngle] zPos:0]];
}

-(void)doubleTapTwoFingers:(UITapGestureRecognizer*)recognizer
{
	[map toggleVisible];
}

-(void)pinch:(UIPinchGestureRecognizer*)recognizer
{
	float scale = [recognizer scale];

	if (scale > 1.0)
	{
		[gameSettings setNight:YES];
	}
	else
	{
		[gameSettings setNight:NO];
	}
}


-(void)initCamera
{
	GameViewController *controller = [GameViewController getInstance];
	
	const GLfloat aspectRatio = (GLfloat)(controller.view.bounds.size.width)/(GLfloat)(controller.view.bounds.size.height);
	const GLfloat fov = GLKMathDegreesToRadians(90.0f);
	
	GLKMatrix4 cameraMatrix = GLKMatrix4MakePerspective(fov, aspectRatio, 0.1f, 100.0f);
	
	camera = [[Camera alloc] initWithPerspective:cameraMatrix position:[[Vector3 alloc] initWithValue:[[builder startPos] x] yPos:2 zPos:[[builder startPos] y]]];
	[camera updateRotation:[[Vector3 alloc] initWithValue:0 yPos:[builder startAngle] zPos:0]];
}

@end