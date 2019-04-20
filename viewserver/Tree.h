#pragma once
#include <d3dx11.h>
#include <xnamath.h>

class Tree
{
public:
	float x, z;
	float scale;
	float maxScale;
	bool isGrowing;
	bool isDead;
	XMMATRIX world;

	Tree(float x, float z);
	float getScale();
	float distanceToTree(Tree);
};

