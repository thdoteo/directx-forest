//--------------------------------------------------------------------------------------
// File: Tutorial022.fx
//
// Copyright (c) Microsoft Corporation. All rights reserved.
//--------------------------------------------------------------------------------------
Texture2D tex : register(t0);
Texture2D tex2 : register(t1);
SamplerState samLinear : register(s0);

cbuffer VS_CONSTANT_BUFFER : register(b0)
	{
	float mx;
	float my;
	float scale;
	float trans;
	float div_tex_x;	//dividing of the texture coordinates in x
	float div_tex_y;	//dividing of the texture coordinates in x
	float slice_x;		//which if the 4x4 images
	float slice_y;		//which if the 4x4 images
	matrix world;
	matrix view;
	matrix projection;
	};

//struct float4
//	{
//	float r, g, b, a;//same
//	float x, y, z, w;
//	}
struct SimpleVertex
	{
	float4 Pos : POSITION;
	float2 Tex : TEXCOORD0;
	float3 Norm : NORMAL;
	};

struct PS_INPUT
	{
	float4 Pos : SV_POSITION;
	float3 WorldPos : POSITION1;
	float2 Tex : TEXCOORD0;
	float3 Norm : NORMAL;
	};
//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VShader(SimpleVertex input)
	{
	PS_INPUT output;
	float4 pos = input.Pos;

	pos = mul(world, pos);	
	output.WorldPos = pos.xyz;
	pos = mul(view, pos);
	pos = mul(projection, pos);	
	
	matrix w = world;
	w._14 = 0;
	w._24 = 0;
	w._34 = 0;

	float4 norm;
	norm.xyz = input.Norm;
	norm.w = 1;
	norm = mul(w, norm);
	norm.x *= -1;
	output.Norm = normalize(norm.xyz);

	output.Pos = pos;
	output.Tex = input.Tex;
	return output;
	}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
//normal pixel shader
float4 PS(PS_INPUT input) : SV_Target
	{
	//return float4(normalize(input.Norm),1);
	float4 color = tex.Sample(samLinear, input.Tex);
	float4 night = tex2.Sample(samLinear, input.Tex);
	
	float3 lightposition = float3(-1000, -1000, -1000);


	//see light video
	float3 ld = lightposition - input.WorldPos;
	float3 ldn = normalize(ld);
	float light=dot(input.Norm,ldn);
	light = saturate(light);//saturate(x) ... if(x<0)x=0;else if(x>1) x=1;

	color.rgb = color.rgb*light + night.rgb*(1.0 - light);
	

	color.a = 1;
	return color;
	}

	float4 PSsky(PS_INPUT input) : SV_Target
		{
		//return float4(input.Tex.y,input.Tex.y,0,1);
		float4 color = tex.Sample(samLinear, input.Tex);
		color.a = 1;
		return color;
		}
