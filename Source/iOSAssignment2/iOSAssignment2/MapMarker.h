//
//  Map.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef MapMarker_h
#define MapMarker_h
#import "Sprite.h"

@interface MapMarker : Sprite

-(id)init;

@property (strong) Vector2 *pos;

@end

#endif /* Map_h */
