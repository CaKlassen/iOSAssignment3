//
//  Shader.fsh
//  iOSAssignment2
//
//  Created by ChristoferKlassen on 2016-02-10.
//  Copyright © 2016 Chris Klassen. All rights reserved.
//

varying lowp vec2 TexCoordOut;
varying lowp vec4 EyeDirOut;
varying lowp vec4 PosOut;
varying lowp vec3 NormalOut;

uniform sampler2D Texture;

uniform highp float fogEnabled;
uniform highp float fogFar;

uniform highp float ambientIntensity;
uniform highp vec3 ambientColour;

void main()
{
	// Final colouration
	highp vec4 color = texture2D(Texture, TexCoordOut);

	gl_FragColor = color;
}
