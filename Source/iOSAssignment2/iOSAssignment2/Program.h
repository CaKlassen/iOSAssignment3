//
//  Program.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Program_h
#define Program_h
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface Program : NSObject
{
	GLuint vertexShader;
	GLuint fragmentShader;
	GLuint program;
}

-(id)initWithShaders:(NSString*)vShader fragmentShader:(NSString*)fShader;
-(void)retrieveUniforms;
-(void)setUniform:(NSString*)key value:(void*)value size:(int)size;
-(void)useProgram:(GLuint)vertexArray;

@property (strong) NSMutableDictionary* uniforms;

@end


#endif /* Program_h */
