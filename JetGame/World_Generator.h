//
//  World_Generator.h
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface World_Generator : SKSpriteNode
@property double Current_X;
@property double Current_Rock_X;
@property double Current_Cloud_X;
//Removed Properties that are not needed due to how the spirtenodes work
@property SKNode *World;
@property NSInteger WetWidth;
+(id)Inital_Generate_World:(SKNode *)World;
-(void)Continious_Generate;
-(void)Initallise_Ocean;
-(void)Generate_A_Ocean;
-(void)Generate_A_Rock;
-(void)Generate_A_Cloud;
@end
