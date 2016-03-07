//
//  Model.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-12.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef Model_h
#define Model_h
#import "Entity.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES2/glext.h>

@interface Model : Entity
{
	GLuint _vertexArray;
	GLuint _vertexBuffer;
	GLuint _texelBuffer;
	GLuint _NormalBuffer;
	GLKMatrix4 _modelViewProjectionMatrix;
	GLKMatrix3 _normalMatrix;
}

-(id)initWithTextureFile:(const NSString *)fileName pos:(const float *)Positions posSize:(int)posSize tex:(const float *)Texels texSize:(int)texSize norm:(const float *)Normals normSize:(int)normSize;
- (CGRect)boundingBox;
-(void)setTexture;

@end


#endif /* Model_h */
