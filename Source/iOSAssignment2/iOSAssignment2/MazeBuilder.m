//
//  MazeBuilder.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MazeBuilder.h"
#import "Wall.h"
#include <stdlib.h>
#include <math.h>

@implementation MazeBuilder

-(id)init
{
	self = [super init];

	// Set up the initial maze state
	for (int i = 0; i < MAZE_SIZE + 2; i++)
	{
		for (int j = 0; j < MAZE_SIZE + 2; j++)
		{
			_mazeData.maze[i][j] = NO;
		}
	}
	
	[self generateMazeWalls];
	
	return self;
}


-(void)generateMazeWalls
{
	for (int i = 0; i < MAZE_SIZE + 2; i++)
	{
		_mazeData.maze[0][i] = YES;
		_mazeData.maze[MAZE_SIZE + 1][i] = YES;
		_mazeData.maze[i][0] = YES;
		_mazeData.maze[i][MAZE_SIZE + 1] = YES;
	}
}


-(void)createMazeElements:(NSMutableArray*)wallList
{
	for (int i = 0; i < MAZE_SIZE + 2; i++)
	{
		for (int j = 0; j < MAZE_SIZE + 2; j++)
		{
			if (_mazeData.maze[i][j] == YES)
			{
				// Create a wall object
				int type = [self getWallType:j y:i];
				
				[wallList addObject:[[Wall alloc] initWithPosition:[[Vector3 alloc] initWithValue:j yPos:0 zPos:i] type:type]];
			}
		}
	}
}

-(int)getWallType:(int)x y:(int)y
{
	int type = 0;
	
	if (x > 0 && x < MAZE_SIZE + 1)
	{
		// Normal x
		if (_mazeData.maze[y][x - 1] == YES)
		{
			if (_mazeData.maze[y][x + 1] == YES)
			{
				// Both sides
				return 4;
			}
			else
			{
				// Left only
				return 2;
			}
		}
		else
		{
			if (_mazeData.maze[y][x + 1] == YES)
			{
				// Right only
				return 3;
			}
			else
			{
				// Nothing
				return 1;
			}
		}
	}
	else if (x == 0)
	{
		if (_mazeData.maze[y][x + 1] == YES)
		{
			// Right only
			return 3;
		}
		else
		{
			// Nothing
			return 1;
		}
	}
	else
	{
		if (_mazeData.maze[y][x - 1] == YES)
		{
			// Left only
			return 2;
		}
		else
		{
			// Nothing
			return 1;
		}
	}
	
	return type;
}


// MAZE GENERATION //

-(void)buildMaze
{
	[self divide:1 y:1 width:MAZE_SIZE height:MAZE_SIZE horizontal:[self chooseOrientation:MAZE_SIZE height:MAZE_SIZE]];
	
	[self generateStartAndExit];
	
	// Find a place for the enemy
	int x, y;
	do
	{
		x = arc4random_uniform(MAZE_SIZE);
		y = arc4random_uniform(MAZE_SIZE);
	}
	while (_mazeData.maze[y][x] == YES);
	
	_enemyPos = [[Vector2 alloc] initWithValue:(x * 2) yPos:(y * 2)];
	
	
	[self printDebugMaze];
}

-(void)generateStartAndExit
{
	int startWall = arc4random_uniform(4);
	int endWall;
	bool horizontal;
	
	if (startWall == 0)
	{
		startWall = 1;
		endWall = MAZE_SIZE;
		horizontal = NO;
	}
	else if (startWall == 1)
	{
		startWall = 1;
		endWall = MAZE_SIZE;
		horizontal = YES;
	}
	else if (startWall == 2)
	{
		startWall = 1;
		endWall = MAZE_SIZE;
		horizontal = NO;
	}
	else
	{
		startWall = 1;
		endWall = MAZE_SIZE;
		horizontal = YES;
	}
	
	
	// Place the start and end
	int randStartPos, randEndPos;
	
	if (horizontal)
	{
		do
		{
			randStartPos = arc4random_uniform(MAZE_SIZE);
		}
		while (_mazeData.maze[startWall][randStartPos] == YES);
		
		do
		{
			randEndPos = arc4random_uniform(MAZE_SIZE);
		}
		while (_mazeData.maze[endWall][randEndPos] == YES);
		
		// Remove the edge walls
		if (randStartPos < (MAZE_SIZE + 1) / 2)
		{
			_mazeData.maze[startWall][0] = NO;
			_startPos = [[Vector2 alloc] initWithValue:(-3 * 2) yPos:(startWall * 2)];
			_startAngle = (3.0f / 2.0f) * M_PI;
		}
		else
		{
			_mazeData.maze[startWall][MAZE_SIZE + 1] = NO;
			_startPos = [[Vector2 alloc] initWithValue:((MAZE_SIZE + 4) * 2) yPos:(startWall * 2)];
			_startAngle = (1.0f / 2.0f) * M_PI;
		}
		
		if (randEndPos < (MAZE_SIZE + 1) / 2)
		{
			_mazeData.maze[endWall][0] = NO;
			_exitPos = [[Vector2 alloc] initWithValue:(-3 * 2) yPos:(endWall * 2)];
		}
		else
		{
			_mazeData.maze[endWall][MAZE_SIZE + 1] = NO;
			_exitPos = [[Vector2 alloc] initWithValue:((MAZE_SIZE + 4) * 2) yPos:(endWall * 2)];
		}
	}
	else
	{
		do
		{
			randStartPos = arc4random_uniform(MAZE_SIZE);
		}
		while (_mazeData.maze[randStartPos][startWall] == YES);
		
		do
		{
			randEndPos = arc4random_uniform(MAZE_SIZE);
		}
		while (_mazeData.maze[randEndPos][endWall] == YES);

		// Remove the edge walls
		if (randStartPos < (MAZE_SIZE + 1) / 2)
		{
			_mazeData.maze[0][startWall] = NO;
			_startPos = [[Vector2 alloc] initWithValue:(startWall * 2) yPos:(-3 * 2)];
			_startAngle = M_PI;
		}
		else
		{
			_mazeData.maze[MAZE_SIZE + 1][startWall] = NO;
			_startPos = [[Vector2 alloc] initWithValue:(startWall * 2) yPos:((MAZE_SIZE + 4) * 2)];
		}
		
		if (randEndPos < (MAZE_SIZE + 1) / 2)
		{
			_mazeData.maze[0][endWall] = NO;
			_exitPos = [[Vector2 alloc] initWithValue:(endWall * 2) yPos:(-3 * 2)];
		}
		else
		{
			_mazeData.maze[MAZE_SIZE + 1][endWall] = NO;
			_exitPos = [[Vector2 alloc] initWithValue:(endWall * 2) yPos:((MAZE_SIZE + 4) * 2)];
		}
	}
}



-(void)divide:(int)x y:(int)y width:(int)width height:(int)height horizontal:(int)horizontal
{
	// Check if this is the target size
	if (width < 2 || height < 2)
	{
		return;
	}
	
	int wallX, wallY, pathX, pathY, directionX, directionY, length;
	
	// Determine the start point of the wall
	wallX = x + (horizontal ? 0 : arc4random_uniform(width - 2));
	if (!horizontal && wallX % 2 != 0)
	{
		wallX++;
	}
	
	wallY = y + (horizontal ? arc4random_uniform(height - 2) : 0);
	if (horizontal && wallY % 2 != 0)
	{
		wallY++;
	}
	
	// Determine the position of the path through the wall
	pathX = wallX + (horizontal ? arc4random_uniform(width) : 0);
	if (horizontal && pathX % 2 == 0)
	{
		pathX++;
	}
	
	pathY = wallY + (horizontal ? 0 : arc4random_uniform(height));
	if (!horizontal && pathY % 2 == 0)
	{
		pathY++;
	}
	
	// Determine the direction of the wall
	directionX = horizontal ? 1 : 0;
	directionY = horizontal ? 0 : 1;
	
	length = horizontal ? width : height;
	
	for (int i = 0; i < length; i++)
	{
		if (horizontal)
		{
			if (wallX != pathX)
			{
				_mazeData.maze[wallY][wallX] = YES;
			}
		}
		else
		{
			if (wallY != pathY)
			{
				_mazeData.maze[wallY][wallX] = YES;
			}
		}
		
		wallX += directionX;
		wallY += directionY;
	}
	
	int newX, newY, newWidth, newHeight;
	
	// Recurse on one side of the wall
	newX = x;
	newY = y;
	newWidth = horizontal ? width : wallX - x;
	newHeight = horizontal ? wallY - y : height;
	
	[self divide:newX y:newY width:newWidth height:newHeight horizontal:[self chooseOrientation:newWidth height:newHeight]];
	
	// Recurse on the other side of the wall
	newX = horizontal ? x : wallX + 1;
	newY = horizontal ? wallY + 1 : y;
	newWidth = horizontal ? width : x + width - wallX - 1;
	newHeight = horizontal ? y + height - wallY - 1 : height;
	
	[self divide:newX y:newY width:newWidth height:newHeight horizontal:[self chooseOrientation:newWidth height:newHeight]];
	
}


-(BOOL)chooseOrientation:(int)width height:(int)height
{
	if (width < height)
	{
		return YES;
	}
	else if (height < width)
	{
		return NO;
	}
	else
	{
		return (arc4random_uniform(2) == 0);
	}
}

-(void)printDebugMaze
{
	for (int i = 0; i < MAZE_SIZE + 2; i++)
	{
		for (int j = 0; j < MAZE_SIZE + 2; j++)
		{
			printf("%c ", _mazeData.maze[i][j] ? 'X' : '.');
		}
		
		printf("\n");
	}
}


@end