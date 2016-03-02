//
//  Map.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Map_h
#define Map_h
#import "Sprite.h"
#import <Foundation/Foundation.h>

@interface Map : Sprite

-(id)initWithBlocks:(NSMutableArray*) wallList;

-(void)toggleVisible;

@end

#endif /* Map_h */
