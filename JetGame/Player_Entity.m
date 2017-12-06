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

//The following Catagories are used to determin what the player hit when a collision is triggered and what it can collide with
static const __UINT32_TYPE__ PlayerCatagory= 0x1 << 10;
static const __UINT32_TYPE__ RockCatagory= 0x1 << 1;
static const __UINT32_TYPE__ CloudCatagory= 0x1 << 2;
static const __UINT32_TYPE__ OceanCatagory= 0x1 << 3;
static const __UINT32_TYPE__ BoomCatagory= 0x1 << 4;
static const __UINT32_TYPE__ BackgroundCatagory= 0x1 << 7;

+ (id)player_entity{
    //Player_Entity *player_entity = [Player_Entity spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50,50)];
    
    Player_Entity *player_entity = [Player_Entity spriteNodeWithImageNamed:@"Jet.png"];
    player_entity.name = @"Jet";
    //player_entity.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(92,24)];
    
    //The following code for the hitbox of the spirte was gained from this website http://insyncapp.net/SKPhysicsBodyPathGenerator.html and adpated to fit the pre existing varible names
    CGFloat offsetX = 0; //player_entity.frame.size.width * player_entity.anchorPoint.x;
    CGFloat offsetY = 0; //player_entity.frame.size.height * player_entity.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 52 - offsetX, 81 - offsetY);
    CGPathAddLineToPoint(path, NULL, 92 - offsetX, 42 - offsetY);
    CGPathAddLineToPoint(path, NULL, 164 - offsetX, 47 - offsetY);
    CGPathAddLineToPoint(path, NULL, 218 - offsetX, 60 - offsetY);
    CGPathAddLineToPoint(path, NULL, 251 - offsetX, 53 - offsetY);
    CGPathAddLineToPoint(path, NULL, 283 - offsetX, 42 - offsetY);
    CGPathAddLineToPoint(path, NULL, 314 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 275 - offsetX, 24 - offsetY);
    CGPathAddLineToPoint(path, NULL, 231 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 191 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 152 - offsetX, 12 - offsetY);
    CGPathAddLineToPoint(path, NULL, 111 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 75 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 45 - offsetX, 25 - offsetY);
    CGPathAddLineToPoint(path, NULL, 31 - offsetX, 67 - offsetY);
    CGPathAddLineToPoint(path, NULL, 34 - offsetX, 78 - offsetY);
    
    CGPathCloseSubpath(path);
    
    player_entity.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
    
    player_entity.xScale = 0.14;
    player_entity.yScale = 0.14;
    
    //I could not get the player entity to recognise the cloud or ocean catagory corretly, it would allways collide with them
    
    player_entity.physicsBody.categoryBitMask = PlayerCatagory;
    player_entity.physicsBody.contactTestBitMask = RockCatagory | ~CloudCatagory| ~OceanCatagory | ~BackgroundCatagory | ~BoomCatagory;
    player_entity.physicsBody.collisionBitMask = ~OceanCatagory | RockCatagory | ~CloudCatagory | ~BackgroundCatagory | ~BoomCatagory;
    player_entity.physicsBody.dynamic = NO;
    player_entity.zPosition = -1;
    return player_entity;
}

-(void)Boost{//Moves the player up
    /*SKAction *MoveUp = [SKAction moveByX:0 y:30 duration:0.2];
    [self runAction:MoveUp];*/
    [self.physicsBody applyImpulse:CGVectorMake(0,10)];
}

-(void)Start_The_Move{//Starts the constant movement of the jet
    self.physicsBody.dynamic = YES;
    SKAction *Increment = [SKAction moveByX:20 y:0 duration:0.03];
    SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
    [self runAction:Move_The_World withKey:@"Mover"];
}

-(void)Stop_The_Move{//Stops moving the jet continiously and applies on last impulse
    [self removeActionForKey:@"Mover"];
    [self.physicsBody applyImpulse:CGVectorMake(10,0)];
    [self setTexture:[SKTexture textureWithImageNamed:@"Jet.png"]];
    // self.physicsBody.dynamic = NO;
}


-(void)Animate:(NSInteger)Frame{ //Frame is the frame of the animation
    [self setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"Jet%li.png",(long)Frame]]];
}

@end
