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

static const __UINT32_TYPE__ PlayerCatagory= 0x1 << 10;
static const __UINT32_TYPE__ RockCatagory= 0x1 << 1;
static const __UINT32_TYPE__ CloudCatagory= 0x1 << 2;
static const __UINT32_TYPE__ OceanCatagory= 0x1 << 3;
static const __UINT32_TYPE__ BoomCatagory= 0x1 << 4;
static const __UINT32_TYPE__ BackgroundCatagory= 0x1 << 7;

+ (id)player_entity{
    //Player_Entity *player_entity = [Player_Entity spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50,50)];
    
    Player_Entity *player_entity = [Player_Entity spriteNodeWithImageNamed:@"Jet.png"];
    player_entity.xScale = 0.14;
    player_entity.yScale = 0.14;
    player_entity.name = @"Jet";
    player_entity.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(92,24)];
    player_entity.physicsBody.categoryBitMask = PlayerCatagory;
    player_entity.physicsBody.contactTestBitMask = RockCatagory | CloudCatagory| ~OceanCatagory | ~BackgroundCatagory | ~BoomCatagory;
    player_entity.physicsBody.collisionBitMask = ~OceanCatagory | RockCatagory | ~CloudCatagory | ~BackgroundCatagory | ~BoomCatagory;
    player_entity.physicsBody.dynamic = NO;
    return player_entity;
}

-(void)Boost{
    /*SKAction *MoveUp = [SKAction moveByX:0 y:30 duration:0.2];
    [self runAction:MoveUp];*/
    [self.physicsBody applyImpulse:CGVectorMake(0,70)];
}

-(void)Start_The_Move{
    self.physicsBody.dynamic = YES;
    SKAction *Increment = [SKAction moveByX:20 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [self runAction:Move_The_World withKey:@"Mover"];
}

-(void)Stop_The_Move{
    [self removeActionForKey:@"Mover"];
    [self.physicsBody applyImpulse:CGVectorMake(100,0)];
    // self.physicsBody.dynamic = NO;
}
//
@end
