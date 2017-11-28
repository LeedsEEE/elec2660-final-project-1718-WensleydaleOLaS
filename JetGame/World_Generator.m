//
//  World_Generator.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "World_Generator.h"


@implementation World_Generator


static const __UINT32_TYPE__ RockCatagory= 0x1 << 1;
static const __UINT32_TYPE__ CloudCatagory= 0x1 << 2;
static const __UINT32_TYPE__ OceanCatagory= 0x1 << 3;


+(id)Inital_Generate_World:(SKNode *)World{
    
    
    World_Generator *Generator = [World_Generator node];
    Generator.Current_X = 0;
    Generator.Current_Rock_X = 100;
    Generator.World= World;
    Generator.WetWidth = 767;
    Generator.Current_Cloud_X = -200;
    
    return Generator;
}

- (void)Continious_Generate{
    /*SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 100)];
    Ocean.position = CGPointMake(0, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.scene.frame.size.width, 100)];
    Ocean.physicsBody.dynamic = NO;
    [self.World addChild:Ocean];*/

}

- (void)Initallise_Ocean{
    for( int i =0; i < 3; i++){
        [self Generate_A_Ocean];
        [self Generate_A_Rock];
        for (int j = 0; j < 3; j++){
            [self Generate_A_Cloud];
        }
    }
}

- (void)Generate_A_Ocean{
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithImageNamed:@"Water.png"];
    Ocean.position = CGPointMake(self.Current_X, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.WetWidth, 20)];
    Ocean.physicsBody.dynamic = NO;
    Ocean.name = @"Ocean";
    Ocean.zPosition = -2;
    Ocean.physicsBody.categoryBitMask = OceanCatagory;
    [self.World addChild:Ocean];
    
    self.Current_X += self.WetWidth;
}

- (void)Generate_A_Rock{
    
    int Rand = (arc4random() % 200 ) + 150;
    int Rand2 = (arc4random() % 200 ) + 400;
    SKSpriteNode *Rock = [SKSpriteNode spriteNodeWithColor:([UIColor blackColor]) size:CGSizeMake(40, Rand)];
    Rock.position = CGPointMake(self.Current_Rock_X + Rand2, -180);
    Rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0,0)];//40, Rand)];
    Rock.physicsBody.dynamic = NO;
    Rock.name = @"Rock";
    Rock.zPosition = -1;
    Rock.physicsBody.categoryBitMask = RockCatagory;
    [self.World addChild:Rock];

    self.Current_Rock_X += Rand2;
}

- (void)Generate_A_Cloud{
    
    int Rand = arc4random() % 200 + 100;
    int Rand2 = arc4random() % 50 + 25;
    SKSpriteNode *Cloud = [SKSpriteNode spriteNodeWithColor:([UIColor grayColor]) size:CGSizeMake(Rand, Rand2)];
    Cloud.position = CGPointMake(self.Current_Cloud_X, +220);
    Cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(Rand, Rand2)];
    Cloud.physicsBody.dynamic = NO;
    Cloud.name = @"Cloud";
    Cloud.zPosition = -1;
    Cloud.physicsBody.categoryBitMask = CloudCatagory;
    [self.World addChild:Cloud];
    
    self.Current_Cloud_X += Rand;
}


@end
