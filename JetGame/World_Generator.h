//
//  World_Generator.h
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface World_Generator : SKSpriteNode
@property Boolean Need_Parallax;
@property double Current_X;
@property double Current_Rock_X;
@property double Current_Cloud_X;
@property double Current_P_X1;
@property double Current_P_X2;
@property double Current_P_X3;
//Removed Properties that are not needed due to how the spirtenodes work
@property SKNode *World;
@property NSInteger WetWidth;
+(id)Inital_Generate_World:(SKNode *)World;
//removed Continious Generate as it wasn't needed in the end
-(void)Initallise_Ocean;
-(void)Generate_A_Ocean;
-(void)Generate_A_ParallaxClose:(Boolean)Initial_Gen;
-(void)Generate_A_ParallaxMid:(Boolean)Initial_Gen;
-(void)Generate_A_ParallaxFar:(Boolean)Initial_Gen;
-(void)Generate_A_Rock;
-(void)Generate_A_Cloud;
@end
