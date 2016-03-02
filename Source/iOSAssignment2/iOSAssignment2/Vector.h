//
//  Vector.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Vector_h
#define Vector_h

@interface Vector2 : NSObject

-(id)initWithValue:(float)xPos yPos:(float)yPos;


@property (assign) float x;
@property (assign) float y;

@end


@interface Vector3 : NSObject

-(id)initWithValue:(float)xPos yPos:(float)yPos zPos:(float)zPos;


@property (assign) float x;
@property (assign) float y;
@property (assign) float z;

@end


#endif /* Vector_h */
