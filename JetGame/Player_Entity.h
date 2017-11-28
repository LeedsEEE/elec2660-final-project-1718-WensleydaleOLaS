//
//  Player_Entity.h
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player_Entity : SKSpriteNode

+(id)player_entity;
-(void)Boost;
-(void)Start_The_Move;
-(void)Stop_The_Move;

@end
