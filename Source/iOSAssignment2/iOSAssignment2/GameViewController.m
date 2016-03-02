//
//  GameViewController.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-10.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>
#import "GameScene.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))


@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong) Scene *scene;
@property (assign) float viewWidth;
@property (assign) float viewHeight;

@end


@implementation GameViewController

static GameViewController *instance;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	instance = self;
	
	// Set up the OpenGL context
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	[EAGLContext setCurrentContext:self.context];
	
	glEnable(GL_DEPTH_TEST);
	glEnable(GL_CULL_FACE);
	
	self.viewWidth = view.frame.size.width;
	self.viewHeight = view.frame.size.height;
	
	// Set up touch gestures
	UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)];
	[self.view addGestureRecognizer:panRecognizer];
	
	UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)];
	[self.view addGestureRecognizer:pinchRecognizer];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapFrom:)];
	[tapRecognizer setNumberOfTapsRequired:2];
	[tapRecognizer setNumberOfTouchesRequired:1];
	[self.view addGestureRecognizer:tapRecognizer];
	
	UITapGestureRecognizer *tap2Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapTwoFingersFrom:)];
	[tap2Recognizer setNumberOfTapsRequired:2];
	[tap2Recognizer setNumberOfTouchesRequired:2];
	[self.view addGestureRecognizer:tap2Recognizer];
	
	// Create the initial scene
	self.scene = [[GameScene alloc] init];
}


/// This function updates the game every frame.
- (void)update
{
	// Update the scene
	[self.scene update];
}

/// This function renders the game every frame.
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	// Render the scene
	[self.scene draw];
}

/// This function handles pan input from the user.
-(void)handlePanFrom:(UIPanGestureRecognizer*)recognizer
{
	[self.scene pan:recognizer];
}

-(void)handlePinchFrom:(UIPinchGestureRecognizer*)recognizer
{
	[self.scene pinch:recognizer];
}

-(void)handleDoubleTapFrom:(UITapGestureRecognizer*)recognizer
{
	[self.scene doubleTap:recognizer];
}

-(void)handleDoubleTapTwoFingersFrom:(UITapGestureRecognizer*)recognizer
{
	[self.scene doubleTapTwoFingers:recognizer];
}


- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}


- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


+(GameViewController*)getInstance
{
	return instance;
}


@end
