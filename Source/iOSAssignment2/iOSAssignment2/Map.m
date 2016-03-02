//
//  Map.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Map.h"
#import "MapMarker.h"
#import "MapBlock.h"
#import "Wall.h"


@interface Map ()
{
	MapMarker *marker;
	NSMutableArray *blockList;
	BOOL visible;
}

@end

@implementation Map


static const NSString* FILE_NAME = @"Map.png";

-(id)initWithBlocks:(NSMutableArray*)wallList
{
	self = [super initWithTextureFile:FILE_NAME];
	
	marker = [[MapMarker alloc] init];
	blockList = [[NSMutableArray alloc] init];
	
	// Create all blocks
	for (Wall *wall in wallList)
	{
		Vector2 *pos = [[Vector2 alloc] initWithValue:[[wall position] x] yPos:[[wall position] z]];
		
		[blockList addObject:[[MapBlock alloc] initWithPosition:pos]];
	}
	
	visible = NO;
	
	return self;
}

-(void)update
{
	
}

-(void)toggleVisible
{
	visible = !visible;
}


-(void)draw:(Program*)program camera:(Camera*)camera
{
	if (visible)
	{
		// Set up the model matrix
		GLKMatrix4 modelMatrix = GLKMatrix4Identity;
		modelMatrix = GLKMatrix4Translate(modelMatrix, 0, 0, -0.12);
		modelMatrix = GLKMatrix4Scale(modelMatrix, 0.0005, 0.0005, 0.0005);
		
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
		glDrawArrays(GL_TRIANGLES, 0, NumVertices);
		
		[marker draw:program camera:camera];
		
		for (MapBlock *block in blockList)
		{
			[block draw:program camera:camera];
		}
	}
}


@end