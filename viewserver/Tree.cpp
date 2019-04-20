#include "Tree.h"
#include <math.h>



Tree::Tree(float _x, float _z)
{
	x = _x;
	z = _z;
	scale = 0.25;
	isGrowing = true;
	isDead = false;

	float x = static_cast <float> (rand()) / static_cast <float> (RAND_MAX);
	maxScale = 0.5 + x;
}

float Tree::getScale()
{
	return scale;
}

float Tree::distanceToTree(Tree t2)
{
	return sqrt((t2.x - x)*(t2.x - x) + (t2.z - z)*(t2.z - z));
}