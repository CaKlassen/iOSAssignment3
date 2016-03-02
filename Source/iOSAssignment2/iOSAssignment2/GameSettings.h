//
//  GameSettings.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-16.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef GameSettings_h
#define GameSettings_h

#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#import "BasicProgram.h"

@interface GameSettings : NSObject

-(void)setNight:(BOOL)val;
-(void)update:(Program*)program;
+(id)getInstance;

@property GLKVector3 ambientColour;
@property float ambientIntensity;
@property float fogEnabled;
@property float fogFar;

@end


#endif /* GameSettings_h */
