//
//  MazeBuilder.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef MazeBuilder_h
#define MazeBuilder_h

#import "Vector.h"

#define MAZE_SIZE 5

@interface MazeBuilder : NSObject

typedef struct MazeData
{
	BOOL maze[MAZE_SIZE + 2][MAZE_SIZE + 2];
	
} MazeData;


-(id)init;
-(void)buildMaze;
-(void)createMazeElements:(NSMutableArray*)wallList;

@property (assign) MazeData mazeData;
@property (strong) Vector2* startPos;
@property (assign) float startAngle;
@property (strong) Vector2* exitPos;

@end

#endif /* MazeBuilder_h */
