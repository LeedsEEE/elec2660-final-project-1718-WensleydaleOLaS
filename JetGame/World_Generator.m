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
static const __UINT32_TYPE__ BackgroundCatagory= 0x1 << 7;


+(id)Inital_Generate_World:(SKNode *)World{
    
    
    World_Generator *Generator = [World_Generator node];
    Generator.Current_X = 0;
    Generator.Current_Rock_X = 100;
    Generator.World= World;
    Generator.WetWidth = 767;
    Generator.Current_Cloud_X = -200;
    Generator.Current_P_X1 = -500;
    Generator.Current_P_X2 = -500;
    Generator.Current_P_X3 = -500;
    
    return Generator;
}

//removed Continious Generate as it wasn't needed in the end

- (void)Initallise_Ocean{
    for( int i =0; i < 3; i++){
        [self Generate_A_Ocean];
        [self Generate_A_Rock];
        for (int j = 0; j < 3; j++){
            [self Generate_A_Cloud];
            [self Generate_A_ParallaxFar];
            for (int k =0; k < 3; k++){
                [self Generate_A_ParallaxClose];
                [self Generate_A_ParallaxMid];
            }
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
    Rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(40,Rand)];//40, Rand)];
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

-(void)Generate_A_ParallaxClose{
    int Rand = arc4random() % 30 + 30;
    SKSpriteNode *Layer1 = [SKSpriteNode spriteNodeWithColor:([UIColor greenColor]) size:CGSizeMake(100, Rand)];
    Layer1.position = CGPointMake(self.Current_P_X1, -150);
    Layer1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer1.physicsBody.dynamic = NO;
    Layer1.name = @"Close";
    Layer1.zPosition = -3;
    Layer1.physicsBody.categoryBitMask = BackgroundCatagory;
    [self.World addChild:Layer1];
    
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:5 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer1 runAction:Move_The_World withKey:@"Layer1Move"];
    
    self.Current_P_X1 += 100;
}
-(void)Generate_A_ParallaxMid{
    int Rand = arc4random() % 30 + 60;
    SKSpriteNode *Layer2 = [SKSpriteNode spriteNodeWithColor:([UIColor redColor]) size:CGSizeMake(150, Rand)];
    Layer2.position = CGPointMake(self.Current_P_X2, -150);
    Layer2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer2.physicsBody.dynamic = NO;
    Layer2.name = @"Mid";
    Layer2.zPosition = -4;
    Layer2.physicsBody.categoryBitMask = BackgroundCatagory;
    [self.World addChild:Layer2];
    
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:13 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer2 runAction:Move_The_World withKey:@"Layer2Move"];
    
   self.Current_P_X2 += 150;
}
-(void)Generate_A_ParallaxFar{
    int Rand = arc4random() % 70 + 90;
    SKSpriteNode *Layer3 = [SKSpriteNode spriteNodeWithColor:([UIColor orangeColor]) size:CGSizeMake(200, Rand)];
    Layer3.position = CGPointMake(self.Current_P_X3, -150);
    Layer3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer3.physicsBody.dynamic = NO;
    Layer3.name = @"Far";
    Layer3.zPosition = -5;
    Layer3.physicsBody.categoryBitMask = BackgroundCatagory;
    [self.World addChild:Layer3];
    
    
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:19 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer3 runAction:Move_The_World withKey:@"Layer3Move"];
    
   self.Current_P_X3 += 200;
    
}



@end
