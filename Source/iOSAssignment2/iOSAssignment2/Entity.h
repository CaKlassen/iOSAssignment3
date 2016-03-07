//
//  Entity.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Entity_h
#define Entity_h

#import "Program.h"
#import "Camera.h"

@interface Entity : NSObject

-(void)update;
-(void)draw:(Program*)program camera:(Camera*)camera;

@property (assign) GLKVector2 bboxSize;
@property (strong) Vector3* position;

@end

#endif /* Entity_h */
