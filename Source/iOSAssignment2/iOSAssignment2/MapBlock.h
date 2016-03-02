//
//  Map.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef MapBlock_h
#define MapBlock_h
#import "Sprite.h"

@interface MapBlock : Sprite

-(id)initWithPosition:(Vector2*)pos;

@property (strong) Vector2 *pos;

@end

#endif /* Map_h */
