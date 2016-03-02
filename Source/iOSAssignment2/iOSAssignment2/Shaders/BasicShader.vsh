//
//  Shader.vsh
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-10.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec2 TexCoordOut;
varying vec4 EyeDirOut;
varying vec4 PosOut;
varying vec3 NormalOut;

uniform mat4 World;
uniform mat4 ViewProj;
uniform vec3 EyeDirection;
uniform mat3 normalMatrix;

void main()
{
	vec4 worldPosition = World * position;
	mat4 modelViewProjectionMatrix = ViewProj * World;
	
	PosOut = worldPosition;
	gl_Position = modelViewProjectionMatrix * position;
	TexCoordOut = texCoord;
	EyeDirOut = vec4(EyeDirection.xyz, 1);
	NormalOut = normalMatrix * normal;
}
