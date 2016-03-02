//
//  Camera.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Camera_h
#define Camera_h

#import <GLKit/GLKit.h>
#import "Vector.h"


@interface Camera : NSObject

-(id)initWithPerspective:(GLKMatrix4)matrix position:(Vector3*)pos;
-(void)makePosition:(Vector3*)pos;
-(void)updatePosition:(Vector3*)pos;
-(void)moveCamera:(Vector2*)move;
-(void)updateRotation:(Vector3*)rot;
-(void)reset;
-(GLKMatrix4)getLookAt;

@property (assign) GLKMatrix4 perspective;
@property (strong) Vector3 *position;
@property (strong) Vector3 *lookAt;
@property (strong) Vector3 *target;
@property (strong) Vector3 *rotation;

@end


#endif /* Camera_h */
