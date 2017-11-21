//
//  Player_Entity.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "Player_Entity.h"

//The Player Entity class was based on Micheal Leech's hero class in his tuturial series **linked here**


@implementation Player_Entity

+ (id)player_entity{
    //Player_Entity *player_entity = [Player_Entity spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50,50)];
    
    Player_Entity *player_entity = [Player_Entity spriteNodeWithImageNamed:@"jet_silhouette.png"];
    player_entity.xScale = 0.04;
    player_entity.yScale = 0.04;
    player_entity.name = @"Jet";
    player_entity.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(101,64)];
    return player_entity;
}

-(void)Boost{
    /*SKAction *MoveUp = [SKAction moveByX:0 y:30 duration:0.2];
    [self runAction:MoveUp];*/
    [self.physicsBody applyImpulse:CGVectorMake(0,100)];
}

-(void)Start_The_Move{
    SKAction *Increment = [SKAction moveByX:1 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [self runAction:Move_The_World];
}
@end
