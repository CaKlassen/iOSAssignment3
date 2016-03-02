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
	// Light direction
	highp vec4 lightDir = normalize(EyeDirOut);
	highp vec4 view = normalize(-PosOut);
	
	// Distance from player
	highp vec4 L = -PosOut;
	highp float dis = length(PosOut);

	// Spot cone
	highp float minCos = cos(0.785398);
	highp float maxCos = (minCos + 1.0) / 2.0;
	highp float cosAngle = dot(lightDir, -(L / dis));
	highp float spotIntensity = smoothstep(minCos, maxCos, cosAngle);
	
	// Attenuation
	highp float attenuation = 1.0 / (1.0 + 0.2 * dis + 0.1 * dis * dis);
	
	highp vec4 normal = vec4(NormalOut, 1.0);
	highp float diffuse = clamp(dot(-lightDir, normal), 0.0, 1.0) * attenuation * spotIntensity;
	highp vec4 reflection = normalize(2.0 * diffuse * normal - PosOut);
	highp float specular = pow(clamp(dot(reflection, view), 0.0, 1.0), 2.0) * attenuation * spotIntensity;

	// Fog
	highp float fog = clamp((dis - 2.0) / (fogFar), 0.0, 1.0) * fogEnabled;
	
	// Final colouration
    highp vec4 color = texture2D(Texture, TexCoordOut);
	color.rgb *= (ambientIntensity * ambientColour) + (vec3(1.0, 1.0, 1.0) * diffuse) + (vec3(1, 1, 1) * specular);
	color.rgba = mix(color.rgba, vec4(0.2, 0.2, 0.2, 1), fog);
	
	gl_FragColor = color;
}
