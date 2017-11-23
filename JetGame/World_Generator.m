//
//  World_Generator.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "World_Generator.h"


@implementation World_Generator


+(id)Inital_Generate_World:(SKNode *)World{
    
    
    World_Generator *Generator = [World_Generator node];
    Generator.Current_X = 0;
    Generator.World= World;
    
    return Generator;
}

- (void)Continious_Generate{
    /*SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(self.frame.size.width, 100)];
    Ocean.position = CGPointMake(0, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(self.scene.frame.size.width, 100)];
    Ocean.physicsBody.dynamic = NO;
    [self.World addChild:Ocean];*/

}

- (void)Initallise_Ground{
    for( int i =0; i < 3; i++){
        [self Generate_A_Ground];
    }
}

- (void)Generate_A_Ground{
    
    int WetWidth = 100; //Width of each ocean 'block'
    
    SKSpriteNode *Ocean = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(WetWidth, 100)];
    Ocean.position = CGPointMake(self.Current_X, -200);
    Ocean.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(WetWidth, 100)];
    Ocean.physicsBody.dynamic = NO;
    [self.World addChild:Ocean];
    
    self.Current_X += WetWidth;
}

@end
