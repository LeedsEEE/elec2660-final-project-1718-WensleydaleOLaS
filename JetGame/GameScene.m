//
//  GameScene.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene


- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
   // self.anchorPoint= CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    self.backgroundColor = [SKColor colorWithRed:32 green:172 blue:219 alpha:255];
    
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 100)];
    Ocean.position = CGPointMake(0, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.frame.size.width, 100)];
    Ocean.physicsBody.dynamic = NO;
    [self addChild:Ocean];

    
    Player_Entity *Jet = [Player_Entity player_entity];
    
    
    Jet.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(101,64)];
    [self addChild:Jet];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}



-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
