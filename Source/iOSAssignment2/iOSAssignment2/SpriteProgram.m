//
//  SpriteProgram.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpriteProgram.h"

@interface SpriteProgram ()
{
	enum
	{
		UNIFORM_VIEWPROJECTION_MATRIX,
		UNIFORM_WORLD_MATRIX,
		UNIFORM_NORMAL_MATRIX,
		UNIFORM_EYE_DIRECTION,
		UNIFORM_FOG_ENABLED,
		UNIFORM_AMBIENT_COLOUR,
		UNIFORM_AMBIENT_INTENSITY,
		UNIFORM_FOG_FAR,
		NUM_UNIFORMS
	};
	
	GLint uniforms[NUM_UNIFORMS];
}

@end


@implementation SpriteProgram

-(id)init
{
	// Create the shaders
	self = [super initWithShaders:@"BasicShader" fragmentShader:@"SpriteShader"];
	
	// Retrieve the uniform locations
	[self retrieveUniforms];
	
	return self;
}


-(void)retrieveUniforms
{
	uniforms[UNIFORM_VIEWPROJECTION_MATRIX] = glGetUniformLocation(program, "ViewProj");
	uniforms[UNIFORM_WORLD_MATRIX] = glGetUniformLocation(program, "World");
	uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(program, "normalMatrix");
	uniforms[UNIFORM_EYE_DIRECTION] = glGetUniformLocation(program, "EyeDirection");
	uniforms[UNIFORM_FOG_ENABLED] = glGetUniformLocation(program, "fogEnabled");
	uniforms[UNIFORM_AMBIENT_COLOUR] = glGetUniformLocation(program, "ambientColour");
	uniforms[UNIFORM_AMBIENT_INTENSITY] = glGetUniformLocation(program, "ambientIntensity");
	uniforms[UNIFORM_FOG_FAR] = glGetUniformLocation(program, "fogFar");
}


-(void)useProgram:(GLuint)vertexArray
{
	glUseProgram(program);
	
	glBindVertexArrayOES(vertexArray);
	
	GLKMatrix4 viewProj;
	GLKMatrix4 world;
	GLKMatrix3 normalMatrix;
	GLKVector3 eyePos;
	float fogEnabled;
	GLKVector3 ambientColour;
	float fogFar;
	float ambientIntensity;
	
	[[[self uniforms] objectForKey:@"ViewProj"] getBytes:&viewProj length:sizeof(GLKMatrix4)];
	[[[self uniforms] objectForKey:@"World"] getBytes:&world length:sizeof(GLKMatrix4)];
	[[[self uniforms] objectForKey:@"normalMatrix"] getBytes:&normalMatrix length:sizeof(GLKMatrix3)];
	[[[self uniforms] objectForKey:@"EyeDirection"] getBytes:&eyePos length:sizeof(GLKVector3)];
	[[[self uniforms] objectForKey:@"fogEnabled"] getBytes:&fogEnabled length:sizeof(float)];
	[[[self uniforms] objectForKey:@"fogFar"] getBytes:&fogFar length:sizeof(float)];
	[[[self uniforms] objectForKey:@"ambientIntensity"] getBytes:&ambientIntensity length:sizeof(float)];
	[[[self uniforms] objectForKey:@"ambientColour"] getBytes:&ambientColour length:sizeof(GLKVector3)];
	
	glUniformMatrix4fv(uniforms[UNIFORM_VIEWPROJECTION_MATRIX], 1, 0, viewProj.m);
	glUniformMatrix4fv(uniforms[UNIFORM_WORLD_MATRIX], 1, 0, world.m);
	glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, normalMatrix.m);
	glUniform3fv(uniforms[UNIFORM_EYE_DIRECTION], 1, eyePos.v);
	glUniform1f(uniforms[UNIFORM_FOG_ENABLED], fogEnabled);
	glUniform1f(uniforms[UNIFORM_FOG_FAR], fogFar);
	glUniform1f(uniforms[UNIFORM_AMBIENT_INTENSITY], ambientIntensity);
	glUniform3fv(uniforms[UNIFORM_AMBIENT_COLOUR], 1, ambientColour.v);
}


@end