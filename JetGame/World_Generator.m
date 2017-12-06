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


+(id)Inital_Generate_World:(SKNode *)World{//Called at the initalisation of the class
    
    //Sets all the inital values
    World_Generator *Generator = [World_Generator node];
    Generator.Current_X = -1000;
    Generator.Current_Rock_X = 100;
    Generator.World= World;
    Generator.Current_Cloud_X = -300;
    Generator.Current_P_X1 = -500;
    Generator.Current_P_X2 = -500;
    Generator.Current_P_X3 = -500;
    
    return Generator;
}

//removed Continious Generate as it wasn't needed in the end

- (void)Initallise_Ocean{//The inital generation of the terrian
    for( int i =0; i < 3; i++){
        [self Generate_A_Rock];//Less generations of rocks are needed as they are not on screen very often
    }
    for (int j = 0; j < 18; j++){//This many generations guarantees the screen is filled by the terrian
        [self Generate_A_Cloud];
        [self Generate_A_Ocean];
        [self Generate_A_ParallaxFar:true];//The 'true' value being passed tells the function that this is an intial generation of terrian so no parallax is required
        [self Generate_A_ParallaxMid:true];
        [self Generate_A_ParallaxClose:true];
    }
}

- (void)Generate_A_Ocean{//Generates one ocean node, all terrian nodes follow the same basic generation with minor differenences
    
    int RandImg = (arc4random() % 3 )+ 1; // Used to select a random image from the selection to give variety to the background...
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Ocean%i.png",RandImg]];//Sets up the node with the selected image...
    
    Ocean.position = CGPointMake(self.Current_X, -170); //Sets up the node, basing it's location on the max X cor of it's node type...
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(170, 5)];//Sets the hit box of the node...
    Ocean.physicsBody.dynamic = NO;//Set's if the node changes it's position/movement depending on collisons with other nodes (no in this case)...
    Ocean.name = @"Ocean";//Gives the node a name...
    Ocean.zPosition = 1; //Sets the Z posistion of the node, this one will be infront of the majority of the terrain...
    Ocean.physicsBody.categoryBitMask = OceanCatagory;//Sets the collision bit mask
    
    Ocean.xScale = 0.5; //Scales the node (image, hit box and all) to suit the resolutoin better...
    Ocean.yScale = 0.5; //Same but for y axis...

    
    [self.World addChild:Ocean];//Adds the node to the world...
    
    self.Current_X += 85; //Increments the current X parallaxed nodes do this in another location. See parallax close for details
}

- (void)Generate_A_Rock{//Generates one rock node
    
    int Rand = (arc4random() % 200 ) + 200;//Random number used for the spacing between rocks
    int Rand2 = (arc4random() % 200 ) + 500;//Random number used for the height of the rocks
    
    int RandImg = (arc4random() % 3 )+ 1;
    
    SKSpriteNode *Rock = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Rock%i.png",RandImg]];
    
    Rock.position = CGPointMake(self.Current_Rock_X + Rand2, -180);
    Rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(180,790)];
    Rock.physicsBody.dynamic = NO;
    Rock.xScale = 40.0 / 200.0;
    Rock.yScale = Rand / 800.0;
    Rock.name = @"Rock";
    Rock.zPosition = -1;
    Rock.physicsBody.categoryBitMask = RockCatagory;
    [self.World addChild:Rock];

    self.Current_Rock_X += Rand2;
}

- (void)Generate_A_Cloud{//Generates one cloud node
    
    int Rand = arc4random() % 200 + 100;//Randomly generates the x size of the cloud
    int Rand2 = arc4random() % 50 + 25; //Randomly generates the y size of the cloud
    
    int RandImg = (arc4random() % 3 )+ 1;
    
    SKSpriteNode *Cloud = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"Cloud%i.png",RandImg]];
    
    Cloud.position = CGPointMake(self.Current_Cloud_X, 200);
    Cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(0, 0)];
    Cloud.xScale = Rand / 800.0; //scales the image to the randomly generated cloud size
    Cloud.yScale = Rand2 / 400.0;
    Cloud.physicsBody.dynamic = NO;
    Cloud.name = @"Cloud";
    Cloud.zPosition = 1;
    Cloud.physicsBody.categoryBitMask = CloudCatagory;
    [self.World addChild:Cloud];
    
    self.Current_Cloud_X += 100;
}

-(void)Generate_A_ParallaxClose:(Boolean)Initial_Gen{//Generates one close parallax node
    
    if (!Initial_Gen){//Checks if it's an inital world generation, if it's not...
        __block CGFloat Max_X;
        [self.World enumerateChildNodesWithName:@"Close" usingBlock:^(SKNode *Node, BOOL *stop){//Gets all nodes of the close type (differnet for other parallaxed nodes)...
            if (Node.position.x > Max_X){   //If the recived position is greater than the current max...
                Max_X = Node.position.x;    //Make the current max the recived max
            }
        }];
        self.Current_P_X1 = Max_X + 85; //Once the maximun x has been found, it is incremenented by 85. This method is to account for the movement of the terrian due to the parallax effect
    }else{//If it is an inital generation...
        self.Current_P_X1 += 85;//There is no reason to check if the max x is indeed the max x as the terrain isn't moving
    }

    int Rand = arc4random() % 20 + 10;
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
    
    if (!Initial_Gen){ //Checks if the generated terrain needs a parallax effect
        //Reused the move the world to reduce the level that the background moves
        SKAction *Increment = [SKAction moveByX:5 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Layer1 runAction:Move_The_World withKey:@"Layer1Move"];
    }

}
-(void)Generate_A_ParallaxMid:(Boolean)Initial_Gen{//Generates one mid parallax node
    
    if (!Initial_Gen){
        __block CGFloat Max_X;
        [self.World enumerateChildNodesWithName:@"Mid" usingBlock:^(SKNode *Node, BOOL *stop){
            if (Node.position.x > Max_X){
                Max_X = Node.position.x;
            }
        }];
        self.Current_P_X2 = Max_X + 85;
    }else{
        self.Current_P_X2 += 85;
    }

    
    int Rand = arc4random() % 20 + 35;
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
    
    
    if (!Initial_Gen){ //Checks if the generated terrain needs a parallax effect
        //Reused the move the world to reduce the level that the background moves
        SKAction *Increment = [SKAction moveByX:13 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Layer2 runAction:Move_The_World withKey:@"Layer2Move"];
    }

}
-(void)Generate_A_ParallaxFar:(Boolean)Initial_Gen{//Generates one far parallax node
    
    if (!Initial_Gen){
        __block CGFloat Max_X;
        [self.World enumerateChildNodesWithName:@"Far" usingBlock:^(SKNode *Node, BOOL *stop){
            if (Node.position.x > Max_X){
                Max_X = Node.position.x;
            }
        }];
        self.Current_P_X3 = Max_X + 110;
    }else{
        self.Current_P_X3 += 110;
    }
    
    int Rand = arc4random() % 20 + 70;
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
    
    if (!Initial_Gen){ //Checks if the generated terrain needs a parallax effect
        //Reused the move the world to reduce the level that the background moves
        SKAction *Increment = [SKAction moveByX:19 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Layer3 runAction:Move_The_World withKey:@"Layer3Move"];
    }

    
}



@end
