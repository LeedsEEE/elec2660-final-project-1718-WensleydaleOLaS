//
//  GameScene.h
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player_Entity.h"
#import "World_Generator.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property Boolean Started;
@property Boolean Game_over;
@end
