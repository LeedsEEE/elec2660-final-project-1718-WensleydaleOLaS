//
//  Player_Entity.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "Player_Entity.h"

@implementation Player_Entity

+ (id)player_entity{
    //Player_Entity *player_entity = [Player_Entity spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(50,50)];
    
    Player_Entity *player_entity = [Player_Entity spriteNodeWithImageNamed:@"jet_silhouette.png"];
    player_entity.xScale = 0.04;
    player_entity.yScale = 0.04;
    return player_entity;
}



@end
