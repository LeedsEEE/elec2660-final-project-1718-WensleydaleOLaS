//
//  GameScene.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "GameScene.h"

//The overall structure, basic functions and game logic of the program are based on Micheal Leech's how to make a 2d game series on Youtube **linked here**
static const __UINT32_TYPE__ BoomCatagory= 0x1 << 4;

@implementation GameScene
{
    Player_Entity *Jet;
    SKNode *World;
    World_Generator *Generator;
    Boolean Dead;
    int Points;
}


- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    self.physicsWorld.contactDelegate = self;
    
    
    self.backgroundColor = [SKColor colorWithRed:32 green:172 blue:219 alpha:255];
    
    
    World = [SKNode node];
    [self addChild:World];
    
    
    /* Removed as no longer needed, world generator has taken over rendering the ocean
     SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 100)];
    Ocean.position = CGPointMake(0, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 100)];
    Ocean.physicsBody.dynamic = NO;
    [World addChild:Ocean];*/

    Generator = [World_Generator Inital_Generate_World:World];
    [Generator Initallise_Ocean];
    
    Jet = [Player_Entity player_entity];
    [World addChild:Jet];
    
    SKLabelNode *Score = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score.position = CGPointMake(-50, 180);
    Score.text = @"Many, many points";
    Score.zPosition=10;
    Score.name = @"Point_Label";
    [World addChild:Score];
    
}

-(void)Start_The_Game_Already{
    self.Started = YES;
    [Jet Start_The_Move];
    Points = 0;
}

-(void)Game_Over{
    
}

-(void)Clear_Screen{
    
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact)
    [World enumerateChildNodesWithName:@"Rock" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x - 500) < Jet.position.x ){
            [Node removeFromParent];
            // Generator.Current_Rock_X = Jet.position.x;
            [Generator Generate_A_Rock];
            
        }
    }];
    if (!Dead){
        /*for (int i = 0; i < 50; i++){
            int RandX = (arc4random() % 1) * (5 * (i -0.5));
            int RandY = (arc4random() % 1) * (5 * (i -0.5));
            SKSpriteNode *Boom = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(5, 5)];
            Boom.position = CGPointMake(Jet.position.x + RandX, Jet.position.y + RandY);
            Boom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(5, 5)];
            Boom.physicsBody.collisionBitMask = BoomCatagory;
            [Boom.physicsBody applyImpulse:CGVectorMake(100*RandX, 100*RandY)];
            Boom.zPosition = 5;
            [World addChild:Boom];
            Dead = true;
        }*/
        [Jet Stop_The_Move];
    }

}

-(void)Generate{
    [World enumerateChildNodesWithName:@"Ocean" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + Generator.WetWidth) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Ocean];
            Points += 100;
        }
    }];
    [World enumerateChildNodesWithName:@"Rock" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Rock];
        }
    }];
    [World enumerateChildNodesWithName:@"Cloud" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Cloud];
        }
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.Started){  // Used to start the game with a touch
        [self Start_The_Game_Already];
    }else if (self.Game_over){ // Used to clear the screen once a fail state has been reached
        [self Clear_Screen];
    }else{ // Used to move the player when the game is still running
        [Jet Boost];
    };
    
}


-(void)didSimulatePhysics{
    [self Center_Camera:Jet];
    [self Generate];
    [World enumerateChildNodesWithName:@"Point_Label" usingBlock:^(SKNode *Node, BOOL *stop){
        Node.position =CGPointMake(Jet.position.x-50, 180);
    }];
 
    
}

-(void)Center_Camera:(SKNode *)node //The center camera method was sourced from Micheal Leech https://www.youtube.com/watch?v=7OzspEaNrmY
{
    CGPoint PositionInScene = [self convertPoint:node.position fromNode:node.parent];
    World.position = CGPointMake(World.position.x - PositionInScene.x, World.position.y );
                        
}
                               
-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
