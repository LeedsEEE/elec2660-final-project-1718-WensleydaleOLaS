//
//  World_Generator.h
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface World_Generator : SKSpriteNode
@property double Current_X; //The 'Current_..." Varibles store the max value of the type terrian being generated with Current_X being the ocean and the others being named depending on their purpose
@property double Current_Rock_X;
@property double Current_Cloud_X;
@property double Current_P_X1;
@property double Current_P_X2;
@property double Current_P_X3;
//Removed Properties that are not needed due to how the spirtenodes work
//Removed a boolean property as it was no longer required due to reworking of methods
@property SKNode *World; //Used to access the world in the main GameScene
+(id)Inital_Generate_World:(SKNode *)World;
-(void)Initallise_Ocean;
-(void)Generate_A_Ocean;
-(void)Generate_A_ParallaxClose:(Boolean)Initial_Gen;
-(void)Generate_A_ParallaxMid:(Boolean)Initial_Gen;
-(void)Generate_A_ParallaxFar:(Boolean)Initial_Gen;
-(void)Generate_A_Rock;
-(void)Generate_A_Cloud;
@end
