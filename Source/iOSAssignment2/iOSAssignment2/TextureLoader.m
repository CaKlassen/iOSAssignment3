//
//  TextureLoader.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-13.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TextureLoader.h"

@implementation TextureLoader

static NSMutableDictionary *dic = nil;


+(CGImageRef)loadImage:(const NSString *)textureName
{
	if (dic == nil)
	{
		dic = [[NSMutableDictionary alloc] init];
	}
	
	// Check to see if the dictionary key already exists
	if ([dic objectForKey:textureName] != nil)
	{
		NSValue *val = [dic objectForKey:textureName];
		return [val pointerValue];
	}
	
	// Otherwise, load the image
	CGImageRef TexImage = [UIImage imageNamed:textureName].CGImage;
	
	if(!TexImage)
	{
		NSLog(@"failed to load texture %@", textureName);
		exit(1);
	}
	
	// Insert the image into the dictionary
	[dic setObject:[NSValue valueWithPointer:TexImage] forKey:textureName];
	
	return TexImage;
}

@end