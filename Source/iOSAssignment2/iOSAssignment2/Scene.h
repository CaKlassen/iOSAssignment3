//
//  Scene.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Scene_h
#define Scene_h

#import <UIKit/UIKit.h>

@interface Scene : NSObject

-(void)update;
-(void)draw;

-(void)pan:(UIPanGestureRecognizer*)recognizer;
-(void)doubleTap:(UITapGestureRecognizer*)recognizer;
-(void)doubleTapTwoFingers:(UITapGestureRecognizer*)recognizer;
-(void)pinch:(UIPinchGestureRecognizer*)recognizer;

@end

#endif /* Scene_h */
