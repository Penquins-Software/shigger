extends Node

const FACTOR: int = 64
const HALF_FACTOR: int = 32
const HALF_FACTOR_VECTOR: Vector2 = Vector2(32, 32)

## Граничный уровень биомов.
const LEVEL_START: int = 31
const LEVEL_EARTH: int = 63
const LEVEL_MAGMA: int = 127
const LEVEL_CHEESE: int = 191
const LEVEL_CENTER: int = 223;
const LEVEL_BACK_CHEESE: int = 255;
const LEVEL_BACK_MAGMA: int = 287;
const LEVEL_BACK_EARTH: int = 319;
const LEVEL_SEA: int = 415;
const LEVEL_SKY: int = 511;
const LEVEL_SPACE: int = 607;

const LEFT_POINT: int = 0
const MIDDLE_POINT: int = 4
const RIGHT_POINT: int = 8

const START_POINT: Vector2 = Vector2(MIDDLE_POINT, 0)


const BASE_PATTERNS: Array = [
	{
		"base" : [
			Vector2(0, 1), Vector2(1, 1)],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), 
			Vector2(0, 2), Vector2(1, 2)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(3, 1)],
		"items" : [],
		"empty" : [],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 1), Vector2(2, 1),
			Vector2(0, 2), Vector2(2, 2)],
		"items" : [],
		"empty" : [
			Vector2(1, 0), 
			Vector2(1, 1), 
			Vector2(1, 2), 
			Vector2(1, 3),],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 3), Vector2(1, 3),
			Vector2(1, 5), Vector2(2, 5)],
		"items" : [
			Vector2(2, 3)],
		"empty" : [
			Vector2(0, 0), 
			Vector2(0, 1), 
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2),  
			Vector2(2, 3), 
			Vector2(2, 4), Vector2(1, 4),Vector2(0, 4),
			Vector2(0, 5)],
	},
	{
		"base" : [
			Vector2(1, 0),
			Vector2(1, 2)],
		"solid" : [
			Vector2(0, 0),                Vector2(2, 0),
			Vector2(0, 1),                Vector2(2, 1),
			Vector2(0, 2),                Vector2(2, 2)],
		"items" : [
			Vector2(1, 1)],
		"empty" : [],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0),
			Vector2(0, 1),
			Vector2(0, 2)],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0)],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), 
			Vector2(0, 1), Vector2(1, 1)],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
						   Vector2(1, 0),
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
						   Vector2(1, 2)],
	},
	{
		"base" : [
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1), Vector2(3, 1)],
		"solid" : [],
		"items" : [],
		"empty" : [],
	},
	{
		"base" : [
			Vector2(0, 0), 
			Vector2(0, 1), 
			Vector2(0, 2), 
			Vector2(0, 3)],
		"solid" : [],
		"items" : [],
		"empty" : [],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0),
			Vector2(0, 1), Vector2(1, 1), Vector2(2, 1),
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 0),                Vector2(2, 0),
						   Vector2(1, 1),
						   Vector2(1, 2)],
		"items" : [],
		"empty" : [
			Vector2(1, 0)],
	},
	{
		"base" : [
			Vector2(0, 0), 
			Vector2(0, 1), 
			Vector2(0, 2), 
			Vector2(0, 3)],
		"solid" : [],
		"items" : [],
		"empty" : [],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(0, 2), Vector2(1, 2), Vector2(1, 3),
			Vector2(3, 1), Vector2(3, 2), Vector2(4, 2), Vector2(3, 3)],
		"items" : [],
		"empty" : [
			Vector2(2, 0), 
			Vector2(0, 1), Vector2(2, 1), Vector2(4, 1), 
			Vector2(2, 2), 
			Vector2(0, 3), Vector2(2, 3), Vector2(4, 3)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(0, 2), Vector2(1, 2), Vector2(1, 3)],
		"items" : [],
		"empty" : [
			Vector2(0, 1), Vector2(2, 1), 
			Vector2(2, 2), 
			Vector2(0, 3), Vector2(2, 3)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(2, 2), Vector2(1, 2), Vector2(1, 3)],
		"items" : [],
		"empty" : [
			Vector2(0, 1), Vector2(2, 1), 
			Vector2(0, 2), 
			Vector2(0, 3), Vector2(2, 3)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 0), Vector2(1, 0), Vector2(1, 1)],
		"items" : [],
		"empty" : [
			Vector2(0, 0)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 0), Vector2(0, 1), Vector2(1, 1)],
		"items" : [],
		"empty" : [
			Vector2(1, 0)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(1, 1)],
		"items" : [],
		"empty" : [
			Vector2(0, 1)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(0, 1)],
		"items" : [],
		"empty" : [
			Vector2(1, 1)],
	},
	{
		"base" : [],
		"solid" : [
						   Vector2(1, 1), Vector2(2, 1), Vector2(3, 1)               ],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0), Vector2(4, 0),
			Vector2(0, 1),                                              Vector2(4, 1),
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2), Vector2(3, 2), Vector2(4, 2)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(3, 0), Vector2(4, 0)],
		"items" : [],
		"empty" : [
			Vector2(2, 0)],
	},
	{
		"base" : [],
		"solid" : [ 
			Vector2(1, 1), Vector2(2, 1),
			Vector2(1, 2), Vector2(2, 2)],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0),
			Vector2(0, 1),                               Vector2(3, 1),
			Vector2(0, 2),                               Vector2(3, 2),
			Vector2(0, 3), Vector2(1, 3), Vector2(2, 3), Vector2(3, 3)]
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(2, 1), 
			Vector2(1, 2),
			Vector2(1, 3)],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0),
			Vector2(0, 1), Vector2(3, 1),
			Vector2(0, 2), Vector2(2, 2),
			Vector2(0, 3), Vector2(2, 3),
			Vector2(0, 4), Vector2(1, 4), Vector2(2, 4)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(2, 1), 
			Vector2(2, 2),
			Vector2(2, 3)],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0),
			Vector2(0, 1), Vector2(3, 1),
			Vector2(0, 2), Vector2(2, 2),
			Vector2(0, 3), Vector2(2, 3),
			Vector2(0, 4), Vector2(1, 4), Vector2(2, 4)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1)],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0),
			Vector2(0, 1),                Vector2(2, 1),
			Vector2(0, 2), Vector2(1, 2), Vector2(2, 2)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1),
			Vector2(1, 2)],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0),
			Vector2(0, 1),                Vector2(2, 1),
			Vector2(0, 2),                Vector2(2, 2),
			Vector2(0, 3), Vector2(1, 3), Vector2(2, 3)],
	},
	{
		"base" : [],
		"solid" : [
			Vector2(1, 1), Vector2(3, 1),
			Vector2(0, 2), Vector2(4, 2),
			Vector2(0, 4), Vector2(4, 4),
			Vector2(1, 5), Vector2(3, 5),],
		"items" : [
			Vector2(2, 3)],
		"empty" : [
										  Vector2(2, 0),
			Vector2(0, 0),                Vector2(2, 1),                Vector2(4, 0),
										  Vector2(2, 2),
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 3), Vector2(3, 0), Vector2(4, 0),
										  Vector2(2, 4),
			Vector2(0, 0),                Vector2(2, 5),                Vector2(4, 0)],
		"indestructible" : [
			Vector2(1, 2), Vector2(3, 2),
			Vector2(1, 4), Vector2(3, 4)],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(2, 0)
		],
		"indestructible" : [
			Vector2(1, 1)
		],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(3, 0)
		],
		"indestructible" : [
			Vector2(1, 1), Vector2(2, 1)
		],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [],
		"empty" : [
			Vector2(0, 0), Vector2(2, 0)
		],
		"indestructible" : [
			Vector2(1, 1),
			Vector2(1, 2)
		],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [
			Vector2(2, 2)
		],
		"empty" : [
			Vector2(0, 1), Vector2(4, 1), Vector2(1, 0), Vector2(3, 0), Vector2(0, 0), Vector2(4, 0)
		],
		"indestructible" : [
			Vector2(2, 1), Vector2(2, 3), Vector2(1, 2), Vector2(3, 2), 
		],
	},
	{
		"base" : [],
		"solid" : [],
		"items" : [
			Vector2(2, 1)
		],
		"empty" : [
			Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(4, 0), Vector2(6, 0),
		],
		"indestructible" : [
			Vector2(1, 1), Vector2(2, 1), Vector2(4, 1), Vector2(5, 1), 
		],
	},
]
