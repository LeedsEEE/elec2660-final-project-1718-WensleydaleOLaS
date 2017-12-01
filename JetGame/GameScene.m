//
//  GameScene.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "GameScene.h"

//The overall structure, basic functions and game logic of the program are based on Micheal Leech's how to make a 2d game series on Youtube **linked here**
static const __UINT32_TYPE__ BoomCatagory= 0x1 << 4;

@implementation GameScene
{
    Player_Entity *Jet;
    SKNode *World;
    SKLabelNode *Score;
    World_Generator *Generator;
    float ThePoints;
}


- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    self.physicsWorld.contactDelegate = self;
    
    World = [SKNode node];
    
    [self addChild:World];
    
    [self Start_Screen];

}

-(void)Start_Screen{
    self.Game_over = false;
    
    //To get the high scores, it fetches from NSUserDefualts. The code for which was scoured here http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults synchronize];
    
    NSInteger High1 = [defaults integerForKey:@"HighScore1"];
    NSInteger High2 = [defaults integerForKey:@"HighScore2"];
    NSInteger High3 = [defaults integerForKey:@"HighScore3"];

    
    
    Generator = [World_Generator Inital_Generate_World:World];
    Generator.Need_Parallax = false;
    [Generator Initallise_Ocean];

    
    Jet = [Player_Entity player_entity];
    [World addChild:Jet];

    SKLabelNode *TouchToStart = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    TouchToStart.position = CGPointMake(0, 0);
    TouchToStart.zPosition=8;
    TouchToStart.text= @"Touch to start";
    TouchToStart.name= @"Touch_To_Start";
    [World addChild:TouchToStart];
    
    bool UpdatePoints = false;
    
    if (ThePoints != 0){
        if (ThePoints >= High1){
            High3 = High2;
            High2 = High1;
            High1 = ThePoints;
            UpdatePoints = true;
        } else if (ThePoints >= High2){
            High3 = High2;
            High2 = ThePoints;
            UpdatePoints = true;

        } else if (ThePoints >= High3){
            High3 = ThePoints;
            UpdatePoints = true;

        }
        if (UpdatePoints){
            [defaults setInteger:High1 forKey:@"HighScore1"];
            [defaults setInteger:High2 forKey:@"HighScore2"];
            [defaults setInteger:High3 forKey:@"HighScore3"];
            [defaults synchronize];
        }
    }
    
    SKLabelNode *Score1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score1.position = CGPointMake(220, 130);
    Score1.zPosition=8;
    Score1.text= [NSString stringWithFormat:@"1st: %li", (long)High1];
    Score1.name= @"Score1";
    [World addChild:Score1];
    
    SKLabelNode *Score2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score2.position = CGPointMake(220, 100);
    Score2.zPosition=8;
    Score2.text= [NSString stringWithFormat:@"2nd: %li", (long)High2];
    Score2.name= @"Score2";
    [World addChild:Score2];
    
    SKLabelNode *Score3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score3.position = CGPointMake(220, 70);
    Score3.zPosition=8;
    Score3.text= [NSString stringWithFormat:@"3rd: %li", (long)High3];
    Score3.name= @"Score3";
    [World addChild:Score3];
    
    SKAction *PulseOut = [SKAction scaleBy:1.1 duration:0.7];
    SKAction *PulseIn = [SKAction scaleBy:0.9 duration:0.7];
    SKAction *Pulse = [SKAction sequence:(@[PulseOut,PulseIn])];
    SKAction *PermaPulse= [SKAction repeatActionForever:Pulse];
    
    [TouchToStart runAction:PermaPulse];
    
}

-(void)Start_The_Game_Already{
    Score = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score.position = CGPointMake(-50, 180);
    Score.text = @"Score: 0";
    Score.zPosition=6;
    Score.name = @"Point_Label";
    [World addChild:Score];
    
    self.Started = YES;
    
    [Jet Start_The_Move];
    
    ThePoints = 0;
    
    [self Start_The_Parallax];
}

-(void)Game_Over{
    self.Game_over = true;
    
    [self Stop_The_Parallax];
    
    SKLabelNode *GameOver = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    GameOver.position = CGPointMake(Jet.position.x, 100);;
    GameOver.text = @"GAME OVER";
    GameOver.zPosition=7;
    GameOver.name = @"Game_Over_Label";
    [World addChild:GameOver];
    
    SKLabelNode *TouchToResume = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    TouchToResume.position = CGPointMake(Jet.position.x, -50);;
    TouchToResume.text = @"Touch to return to menu";
    TouchToResume.zPosition=7;
    TouchToResume.name = @"Game_Over_Label";
    [World addChild:TouchToResume];

    
    Score.position = CGPointMake(Jet.position.x, 20);
    
    [self Center_Camera:GameOver];

    
    NSLog(@"Game over man, game over");
}

-(void)Stop_The_Parallax{
    [World enumerateChildNodesWithName:@"Close" usingBlock:^(SKNode *Node, BOOL *stop){
          [Node removeActionForKey:@"Layer1Move"];
    }];
    [World enumerateChildNodesWithName:@"Mid" usingBlock:^(SKNode *Node, BOOL *stop){
        [Node removeActionForKey:@"Layer2Move"];
    }];
    [World enumerateChildNodesWithName:@"Far" usingBlock:^(SKNode *Node, BOOL *stop){
        [Node removeActionForKey:@"Layer3Move"];
    }];
}
-(void)Start_The_Parallax{
    [World enumerateChildNodesWithName:@"Close" usingBlock:^(SKNode *Node, BOOL *stop){
        SKAction *Increment = [SKAction moveByX:5 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Node runAction:Move_The_World withKey:@"Layer1Move"];

    }];
    [World enumerateChildNodesWithName:@"Mid" usingBlock:^(SKNode *Node, BOOL *stop){
        SKAction *Increment = [SKAction moveByX:13 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Node runAction:Move_The_World withKey:@"Layer2Move"];
    }];
    [World enumerateChildNodesWithName:@"Far" usingBlock:^(SKNode *Node, BOOL *stop){
        SKAction *Increment = [SKAction moveByX:19 y:0 duration:0.03];
        SKAction *Move_The_World = [SKAction repeatActionForever:Increment];
        [Node runAction:Move_The_World withKey:@"Layer3Move"];
    }];
}


-(void)Clear_Screen{
    [World removeAllChildren]; //Clears all entities
}

-(void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact)
    [World enumerateChildNodesWithName:@"Rock" usingBlock:^(SKNode *Node, BOOL *stop){
        //if ((Node.position.x - 500) < Jet.position.x ){
            //[Node removeFromParent];
            // Generator.Current_Rock_X = Jet.position.x;
         //   [Generator Generate_A_Rock];
            
        //}
    }];
    if (!self.Game_over){
        float X;
        float Y;
        float VX;
        float VY;
        float Rads;

        for (float i = 0.0; i < 10; i++){
            //Added trig functions to make the explosion move away from the jet's position
            float Rand = arc4random() % 5;
            
            SKSpriteNode *Boom = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(5, 5)];
            
            [World addChild:Boom];
            
            Rads = M_PI * 2 * (i/9); // I vary the division of i to give the explosion effect some variety
            
            X = cos(Rads) * 2 + Rand;
            Y = sin(Rads) * 2 + Rand;
            
            Boom.position = CGPointMake(Jet.position.x + X, Jet.position.y + Y);
            Boom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1,1)];
            Boom.physicsBody.collisionBitMask = BoomCatagory;

            VX = X * 0.001;
            VY = Y * 0.001;
            
            [Boom.physicsBody applyImpulse:CGVectorMake(VX, VY)];
            Boom.zPosition = 5;
        }
        for (float i = 0.0; i < 10; i++){
            //Added trig functions to make the explosion move away from the jet's position
            float Rand = arc4random() % 5;
            
            SKSpriteNode *Boom = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(5, 5)];
            
            [World addChild:Boom];
            
            Rads = M_PI * 2 * (i/11);
            
            X = cos(Rads) * 2 + Rand;
            Y = sin(Rads) * 2 + Rand;
            
            Boom.position = CGPointMake(Jet.position.x + X, Jet.position.y + Y);
            Boom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1,1)];
            Boom.physicsBody.collisionBitMask = BoomCatagory;
            
            VX = X * 0.001;
            VY = Y * 0.001;
            
            [Boom.physicsBody applyImpulse:CGVectorMake(VX, VY)];
            Boom.zPosition = 5;
        }
        for (float i = 0.0; i < 10; i++){
            //Added trig functions to make the explosion move away from the jet's position
            float Rand = arc4random() % 5;
            
            SKSpriteNode *Boom = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(5, 5)];
            
            [World addChild:Boom];
            
            Rads = M_PI * 2 * (i/10);
            
            X = cos(Rads) * 2 + Rand;
            Y = sin(Rads) * 2 + Rand;
            
            Boom.position = CGPointMake(Jet.position.x + X, Jet.position.y + Y);
            Boom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1,1)];
            Boom.physicsBody.collisionBitMask = BoomCatagory;
            
            VX = X * 0.001;
            VY = Y * 0.001;
            
            [Boom.physicsBody applyImpulse:CGVectorMake(VX, VY)];
            Boom.zPosition = 5;
        }
        [Jet Stop_The_Move];
        [self Game_Over];
    }

}

-(void)Generate{
    if (!self.Game_over){
        Generator.Need_Parallax = true;
    [World enumerateChildNodesWithName:@"Ocean" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Ocean];
            ThePoints += 1;
        }
    }];
    [World enumerateChildNodesWithName:@"Rock" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Rock];
        }
        
    }];
    [World enumerateChildNodesWithName:@"Cloud" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_Cloud];
        }
       
  
    }];
    [World enumerateChildNodesWithName:@"Close" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_ParallaxClose:false];
        }
 
    }];
    [World enumerateChildNodesWithName:@"Mid" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_ParallaxMid:false];
        }
  
    }];
    [World enumerateChildNodesWithName:@"Far" usingBlock:^(SKNode *Node, BOOL *stop){
        if ((Node.position.x + 500) < Jet.position.x ){
            [Node removeFromParent];
            [Generator Generate_A_ParallaxFar:false];
        }
     
    }];
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (!self.Started){  // Used to start the game with a touch
        [self Start_The_Game_Already];
        [self Remove_Start_Screen];
    }else if (self.Game_over){ // Used to clear the screen once a fail state has been reached
        [self Clear_Screen];
        [self Start_Screen];
        self.Started=false;
    }else{ // Used to move the player when the game is still running
        [Jet Boost];
    };
    
}

-(void)Remove_Start_Screen{
    [World enumerateChildNodesWithName:@"Touch_To_Start" usingBlock:^(SKNode *Node, BOOL *stop){
        [Node removeFromParent];
    }];
}

-(void)didSimulatePhysics{
    if (!self.Game_over){
        [self Center_Camera:Jet];
        Score.position = CGPointMake(Jet.position.x-50, 180);
        [self Generate];
         NSInteger RandImg = (arc4random() % 3 )+ 1;
        [Jet Animate: RandImg];
    }
    NSString *Temp = [NSString stringWithFormat:@"Score: %1ld", (long)ThePoints];
    Score.text = Temp;
    
}

-(void)Center_Camera:(SKNode *)node //The center camera method was sourced from Micheal Leech https://www.youtube.com/watch?v=7OzspEaNrmY
{
    CGPoint PositionInScene = [self convertPoint:node.position fromNode:node.parent];
    World.position = CGPointMake(World.position.x - PositionInScene.x, World.position.y );
                        
}
                               
-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
