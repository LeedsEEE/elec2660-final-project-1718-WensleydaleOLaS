//
//  GameScene.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "GameScene.h"

//The overall structure, basic functions and game logic of the program are based on Micheal Leech's how to make a 2d game series on Youtube **linked here**


@implementation GameScene
{
    Player_Entity *Jet;
    SKNode *World;

}


- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    

    
    
    self.backgroundColor = [SKColor colorWithRed:32 green:172 blue:219 alpha:255];
    
    
    World = [SKNode node];
    [self addChild:World];
    
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 100)];
    Ocean.position = CGPointMake(0, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 100)];
    Ocean.physicsBody.dynamic = NO;
    [World addChild:Ocean];

    
    Jet = [Player_Entity player_entity];
    [World addChild:Jet];
    
}

-(void)Start_The_Game_Already{
    self.Started = YES;
    [Jet Start_The_Move];
}

-(void)Game_Over{
    
}

-(void)Clear_Screen{
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.Started){  // Used to start the game with a touch
        [self Start_The_Game_Already];
    }else if (self.Started){ // Used to clear the screen once a fail state has been reached
        [self Clear_Screen];
    }else{ // Used to move the player when the game is still running
        [Jet Boost];
    };
    
}


-(void)didSimulatePhysics{
    [self Center_Camera:Jet];
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
