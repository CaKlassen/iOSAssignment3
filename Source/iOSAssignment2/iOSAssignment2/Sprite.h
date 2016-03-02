//
//  Sprite.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-19.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Sprite_h
#define Sprite_h
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>
#import "Entity.h"

@interface Sprite : Entity
{
	GLuint _vertexArray;
	GLuint _vertexBuffer;
	GLuint _texelBuffer;
	GLuint _NormalBuffer;
	GLKMatrix4 _modelViewProjectionMatrix;
	GLKMatrix3 _normalMatrix;
	float NumVertices;
}

-(id)initWithTextureFile:(const NSString *)fileName;

-(void)setTexture;

@end

#endif /* Sprite_h */
