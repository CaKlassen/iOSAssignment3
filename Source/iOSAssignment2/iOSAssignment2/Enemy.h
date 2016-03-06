//
//  Enemy.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-03-06.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Enemy_h
#define Enemy_h

#import "Model.h"
#import "Vector.h"


@interface Enemy : Model

-(id)initWithPosition:(Vector3*)pos;
-(void)toggleState;
-(void)rotate:(float)x y:(float)y;
-(void)translate:(float)x y:(float)y z:(float)z;
-(void)scale:(float)val;

@property (assign) bool state;
@property (strong) Vector3* position;

@end

#endif /* Enemy_h */
