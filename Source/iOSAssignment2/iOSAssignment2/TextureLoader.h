//
//  TextureLoader.h
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#ifndef TextureLoader_h
#define TextureLoader_h

#import <Foundation/Foundation.h>

@interface TextureLoader : NSObject

+(CGImageRef)loadImage:(const NSString*)textureName;

@end


#endif /* TextureLoader_h */
