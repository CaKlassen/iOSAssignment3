//
//  MathUtils.m
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-03-06.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MathUtils.h"

@implementation MathUtils

+(float)distance:(Vector3*)pointA pointB:(Vector3*)pointB
{
	float dis;
	
	float disX = [pointA x] - [pointB x];
	float disY = [pointA z] - [pointB z];
	
	dis = sqrt(pow(disX, 2) + pow(disY, 2));
	
	return dis;
}


@end