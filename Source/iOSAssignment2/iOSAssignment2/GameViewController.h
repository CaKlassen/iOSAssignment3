//
//  GameViewController.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-10.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GameViewController : GLKViewController

- (void)tearDownGL;

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;


+(GameViewController*)getInstance;

@end
