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
    Generator.Current_X = -1000;
    Generator.Current_Rock_X = 100;
    Generator.World= World;
    Generator.WetWidth = 170;
    Generator.Current_Cloud_X = -200;
    Generator.Current_P_X1 = -1500;
    Generator.Current_P_X2 = -1500;
    Generator.Current_P_X3 = -1500;

    
    return Generator;
}

//removed Continious Generate as it wasn't needed in the end

- (void)Initallise_Ocean{
    for( int i =0; i < 3; i++){
        [self Generate_A_Rock];
        for (int j = 0; j < 8; j++){            
            [self Generate_A_Cloud];
            [self Generate_A_ParallaxFar];
            [self Generate_A_Ocean];
            [self Generate_A_ParallaxClose];
            [self Generate_A_ParallaxMid];
        }
    }
}

- (void)Generate_A_Ocean{
    
    int RandImg = (arc4random() % 3 )+ 1; // Used to select a random image from the selection to give variety to the background
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Ocean%i.png",RandImg]];
   // Ocean.xScale = 0.14;
   // Ocean.yScale = 0.14;
    
    Ocean.position = CGPointMake(self.Current_X, -170);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.WetWidth/2, 10)];
    Ocean.physicsBody.dynamic = NO;
    Ocean.name = @"Ocean";
    Ocean.zPosition = -2;
    Ocean.physicsBody.categoryBitMask = OceanCatagory;
    
    Ocean.xScale = 0.5;
    Ocean.yScale = 0.5;

    
    [self.World addChild:Ocean];
    
    self.Current_X += self.WetWidth/2;
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
    
    int RandImg = (arc4random() % 3 )+ 1;
    
    SKSpriteNode *Cloud = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Cloud%i.png",RandImg]];
    
    Cloud.position = CGPointMake(self.Current_Cloud_X, 200);
    Cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(Rand, Rand2)];
    Cloud.xScale = Rand / 800.0; //scales the image to the randomly generated cloud size
    //NSLog(@"Poop!$!$: %i",Rand);    For checking the maths was correct, just needed a .0 at the end to stop it counting the 800 as an int and as a float instead
    // float temp = Rand / 800.0;
    // NSLog(@"Things!$!$: %f",temp);
    Cloud.yScale = Rand2 / 400.0;
    Cloud.physicsBody.dynamic = NO;
    Cloud.name = @"Cloud";
    Cloud.zPosition = -1;
    Cloud.physicsBody.categoryBitMask = CloudCatagory;
    [self.World addChild:Cloud];
    
    self.Current_Cloud_X += 100;
}

-(void)Generate_A_ParallaxClose{

    int Rand = arc4random() % 30 + 10;
    int RandImg = (arc4random() % 3 )+ 1;
    
    SKSpriteNode *Layer1 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Ocean%i.png",RandImg]];
    Layer1.position = CGPointMake(self.Current_P_X1, -170 +Rand);
    Layer1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer1.physicsBody.dynamic = NO;
    Layer1.name = @"Close";
    Layer1.zPosition = -3;
    Layer1.physicsBody.categoryBitMask = BackgroundCatagory;
    
    Layer1.xScale = 0.5;
    Layer1.yScale = 0.5;

    
    
    [self.World addChild:Layer1];
    
    if (self.Need_Parallax){ //Checks if the generated terrain needs a parallax effect
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:5 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer1 runAction:Move_The_World withKey:@"Layer1Move"];
    }
    
    self.Current_P_X1 += 85;
}
-(void)Generate_A_ParallaxMid{
    int Rand = arc4random() % 20 + 40;
    int RandImg = (arc4random() % 3 )+ 1;
    
    
    SKSpriteNode *Layer2 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Ocean%i.png",RandImg]];
    Layer2.position = CGPointMake(self.Current_P_X2, -170 +Rand);
    Layer2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer2.physicsBody.dynamic = NO;
    Layer2.name = @"Mid";
    Layer2.zPosition = -4;
    Layer2.physicsBody.categoryBitMask = BackgroundCatagory;
    
    Layer2.xScale = 0.5;
    Layer2.yScale = 0.5;

    
    
    [self.World addChild:Layer2];
    
    
    
    
    if (self.Need_Parallax){ //Checks if the generated terrain needs a parallax effect
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:13 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer2 runAction:Move_The_World withKey:@"Layer2Move"];
    }
    
   self.Current_P_X2 += 85;
}
-(void)Generate_A_ParallaxFar{
    int Rand = arc4random() % 30 + 60;
    
    int RandImg = (arc4random() % 3 )+ 1;
    
    SKSpriteNode *Layer3 = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Mountian%i.png",RandImg]];
    
    Layer3.xScale = 0.5;
    Layer3.yScale = 0.5;
    
    Layer3.position = CGPointMake(self.Current_P_X3, -170 +Rand);
    Layer3.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Layer3.physicsBody.dynamic = NO;
    Layer3.name = @"Far";
    Layer3.zPosition = -5;
    Layer3.physicsBody.categoryBitMask = BackgroundCatagory;
    [self.World addChild:Layer3];
    
    if (self.Need_Parallax){ //Checks if the generated terrain needs a parallax effect
    //Reused the move the world to reduce the level that the background moves
    SKAction *Increment = [SKAction moveByX:19 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [Layer3 runAction:Move_The_World withKey:@"Layer3Move"];
    }
    
   self.Current_P_X3 += 110;
    
}



@end
