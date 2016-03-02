//
//  Program.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Program.h"

@interface Program ()

@end

@implementation Program

-(id)initWithShaders:(NSString*)vShader fragmentShader:(NSString*)fShader
{
	self = [super init];
	
	// Load the shaders and create the program
	[self loadShaders:vShader fragmentShader:fShader];
	
	_uniforms = [[NSMutableDictionary alloc] init];
	
	return self;
}


-(BOOL)loadShaders:(NSString*)vShader fragmentShader:(NSString*)fShader
{
	NSString *vertexShaderFilePath;
	NSString *fragmentShaderFilePath;
	
	//create the program for the shaders
	program = glCreateProgram();
	
	//get the file path names
	vertexShaderFilePath = [[NSBundle mainBundle] pathForResource:vShader ofType:@"vsh"];
	fragmentShaderFilePath = [[NSBundle mainBundle] pathForResource:fShader ofType:@"fsh"];
	
	//compile vertex shader; return error if it fails
	if(![self CompileShader:&vertexShader type:GL_VERTEX_SHADER filePath:vertexShaderFilePath]){
		NSLog(@"Failed to compile the vertex shader");
		return NO;
	}
	
	//compile fragment shader; return error if it fails
	if(![self CompileShader:&fragmentShader type:GL_FRAGMENT_SHADER filePath:fragmentShaderFilePath]){
		NSLog(@"Failed to compile the fragment shader");
		return NO;
	}
	
	//attach the shaders to the program
	glAttachShader(program, vertexShader);
	glAttachShader(program, fragmentShader);
	
	//bind attribute locations
	//bind GLKVertexAttribPosition to position attribute in shader
	glBindAttribLocation(program, 0, "position");
	//bind GLKVertexAttribNormal to normal attribute in shader
	glBindAttribLocation(program, 2, "normal");
	//bind GLKVertexAttribTexCoord0 to texCoord attribute in shader
	glBindAttribLocation(program, 1, "texCoord");
	
	//link the program!
	GLuint status;
	glLinkProgram(program);
	
	glGetProgramiv(program, GL_LINK_STATUS, &status);
	if(status == 0){
		
		NSLog(@"Failed to link the program %d", program);
		
		if(vertexShader){
			glDeleteShader(vertexShader);
			vertexShader = 0;
		}
		
		if(fragmentShader){
			glDeleteShader(fragmentShader);
			fragmentShader = 0;
		}
		
		if(program)
		{
			glDeleteProgram(program);
			program = 0;
		}
		
		return NO;
	}
	
	return YES;
}

-(void)releaseShaders
{
	//release the vertex shader
	if(vertexShader){
		glDetachShader(program, vertexShader);
		glDeleteShader(vertexShader);
	}
	
	//release the fragment shader
	if(fragmentShader){
		glDetachShader(program, fragmentShader);
		glDeleteShader(fragmentShader);
	}
}

-(BOOL)CompileShader:(GLuint*)shader type:(GLenum)typeOfShader filePath:(NSString*)path
{
	GLint status;
	const GLchar *source;
	
	source =  (GLchar *)[[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil] UTF8String];
	if(!source){
		NSLog(@"Failed to load vertex shader");
		return NO;
	}
	
	//create and compile the shader here
	*shader = glCreateShader(typeOfShader);
	glShaderSource(*shader, 1, &source, NULL);
	glCompileShader(*shader);
	
	glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
	if(status == 0)
	{
		GLint length;
		glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &length);
		if (length > 0)
		{
			GLint infoLength;
			char* infoBuf = (char*) malloc(sizeof(char) * length);
			glGetShaderInfoLog(*shader, length, &infoLength, infoBuf);
			
			printf("%s", infoBuf);
			free(infoBuf);
		}
		
		glDeleteShader(*shader);
		return NO;
	}
	
	return YES;
}

-(void)retrieveUniforms
{
	
}

-(void)setUniform:(NSString*)key value:(void*)value size:(int)size
{
	
	NSData *data = [NSData dataWithBytes:value length:size];
	[_uniforms setObject:data forKey:key];
}

-(void)useProgram:(GLuint)vertexArray
{
	
}

@end