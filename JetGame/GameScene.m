//
//  GameScene.m
//  JetGame
//
//  Created by Andrew Moore [el16ajm] on 21/11/2017.
//  Copyright © 2017 University of Leeds. All rights reserved.
//

#import "GameScene.h"

//The overall structure, basic functions and game logic of the program are based on Micheal Leech's how to make a 2d game series on Youtube https://youtu.be/CWZgt8a7a-k then adapted and manipluated to suit my needs
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
    
    //To get the high scores, it fetches from NSUserDefualts. The code for accessing and storing was scoured here http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults synchronize];
    
    NSInteger High1 = [defaults integerForKey:@"HighScore1"];
    NSInteger High2 = [defaults integerForKey:@"HighScore2"];
    NSInteger High3 = [defaults integerForKey:@"HighScore3"];

    
    
    Generator = [World_Generator Inital_Generate_World:World];
   // Generator.Need_Parallax = false;
    [Generator Initallise_Ocean];

    
    Jet = [Player_Entity player_entity];
    [World addChild:Jet];

    SKLabelNode *TouchToStart = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    TouchToStart.position = CGPointMake(0, 0);
    TouchToStart.zPosition=3;
    TouchToStart.text= @"Touch to start";
    TouchToStart.name= @"Touch_To_Start";
    [World addChild:TouchToStart];
    
    SKLabelNode *Cloud_Help = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Cloud_Help.position = CGPointMake(-220, 150);
    Cloud_Help.zPosition=3;
    Cloud_Help.text= @"Hit clouds, lose points!";
    Cloud_Help.fontSize = 20;
    Cloud_Help.name= @"Cloud_Help";
    [World addChild:Cloud_Help];
    
    SKLabelNode *Ocean_Help = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Ocean_Help.position = CGPointMake(-220, -170);
    Ocean_Help.zPosition=3;
    Ocean_Help.text= @"Don't hit the water!";
    Ocean_Help.fontSize = 20;
    Ocean_Help.name= @"Ocean_Help";
    [World addChild:Ocean_Help];
    
    SKLabelNode *Rock_Help = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Rock_Help.position = CGPointMake(220, -100);
    Rock_Help.zPosition=3;
    Rock_Help.text= @"Watch out for rocks!";
    Rock_Help.fontSize = 20;
    Rock_Help.name= @"Rock_Help";
    [World addChild:Rock_Help];


    
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
    
    
    //All label nodes are set up in the same way
    SKLabelNode *Score1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];//Generates a node and sets a font...
    Score1.position = CGPointMake(220, 130);//Then sets a position...
    Score1.zPosition=3;//Sets a high Z posistion so it is above all the game layers...
    Score1.text= [NSString stringWithFormat:@"1st: %li", (long)High1];//Sets the text in the label node...
    Score1.name= @"Score1";//Gives it a name so it can be edited later if needed...
    [World addChild:Score1];//Adds it to the world so that it is generated
    
    SKLabelNode *Score2 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score2.position = CGPointMake(220, 100);
    Score2.zPosition=3;
    Score2.text= [NSString stringWithFormat:@"2nd: %li", (long)High2];
    Score2.name= @"Score2";
    [World addChild:Score2];
    
    SKLabelNode *Score3 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    Score3.position = CGPointMake(220, 70);
    Score3.zPosition=3;
    Score3.text= [NSString stringWithFormat:@"3rd: %li", (long)High3];
    Score3.name= @"Score3";
    [World addChild:Score3];
    
    
    //The following is setting up a 'pulse' animation for the 'Touch to start' label
    SKAction *PulseOut = [SKAction scaleBy:1.1 duration:0.7];//Scales the label by 110%
    SKAction *PulseIn = [SKAction scaleBy:0.909090909090909 duration:0.7];//Scales the label by 90.9% to reset it to the origional size
    SKAction *Pulse = [SKAction sequence:(@[PulseOut,PulseIn])];//Sets up a new action by combining the previous two actions
    SKAction *PermaPulse= [SKAction repeatActionForever:Pulse];//Sers up another action by looping the previous combination of actions
    [TouchToStart runAction:PermaPulse];//Runs the looping pulse animation on the 'touch to start' label
    
}

-(void)Start_The_Game_Already{//Used to start the game
    Score = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];//Generates the current points label
    Score.position = CGPointMake(-50, 180);
    Score.text = @"Score: 0";
    Score.zPosition=4;
    Score.name = @"Point_Label";
    [World addChild:Score];
    
    self.Started = YES;//Tells the game that it has started so new features in the program, such as allowing the player to boost upwards, activate
    
    [Jet Start_The_Move];//Starts the movement of the player and terrian in the process
    
    ThePoints = 0;//Resets the current score from any pervious runs
    
    [self Start_The_Parallax];//Starts the parallax on the existing, stationary terrian
    [self Remove_Start_Screen];//Removes the start screen
}

-(void)Game_Over{//Is called when a fail state is reached
    self.Game_over = true;//Sets the game to be over so certain features, parallax for example, are no longer being run
    
    [self Stop_The_Parallax];//Stops the parallax effect
    
    SKLabelNode *GameOver = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    GameOver.position = CGPointMake(Jet.position.x, 100);;
    GameOver.text = @"GAME OVER";
    GameOver.zPosition=3;
    GameOver.name = @"Game_Over_Label";
    [World addChild:GameOver];
    
    SKLabelNode *TouchToResume = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    TouchToResume.position = CGPointMake(Jet.position.x, -50);;
    TouchToResume.text = @"Touch to return to menu";
    TouchToResume.zPosition=3;
    TouchToResume.name = @"Game_Over_Label";
    [World addChild:TouchToResume];

    
    Score.position = CGPointMake(Jet.position.x, 20);
    
    [self Center_Camera:GameOver];//Stops the camera being centred on the player so that the fail state menu is static

    
    NSLog(@"Game over man, game over");//Log for debugging, not used any more but useful to have
}

-(void)Stop_The_Parallax{//Stops the parallax effect by canceling the action of movement for each layer
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
-(void)Start_The_Parallax{//starts the parallax effect by animating each layer indivulally (only used in the inital set up of the game, all later generations of terrian will animate by themselves. It's so that the terrian isn't moving before the player starts playing
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


-(void)Clear_Screen{//Clears the screen
    [World removeAllChildren]; //Clears all entities
}

-(void)didBeginContact:(SKPhysicsContact *)contact{//Any time there is a contact this is called
    //A tool for debugging has been removed from this location
    if (!self.Game_over){
        [self MakeTheBoom];
        [Jet Stop_The_Move];
        [self Game_Over];
    }
}

-(void)MakeTheBoom{//Creates an explosion effect arround the player to signify that they have crashed
    float X;//X position
    float Y;//Y position
    float VX; //X Velocity
    float VY; //Y Velocity
    float Rads; //Angle in RADs between the explosion node and the player, used to calculate x and y velocity
    
    //All the explosion effects are generated in the following manner
    for (float i = 0.0; i < 10; i++){//For loop to generate a set amount of particles for a crash
        //Added trig functions to make the explosion move away from the jet's position
        float Rand = arc4random() % 5;
        
        SKSpriteNode *Boom = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(5, 5)];//Initalises the node and sets its colour
        
        [World addChild:Boom];//Adds it to the world
        
        Rads = M_PI * 2 * (i/9); //Sets the angle in radians between the new node and the player's jet. I vary the division of i to give the explosion effect some variety
        
        X = cos(Rads) * 2 + Rand; //Calculates the x position from the angle and adds some randomness for variety in the effect
        Y = sin(Rads) * 2 + Rand; //Calculates the y position from the angle and adds some randomness for variety in the effect
        
        Boom.position = CGPointMake(Jet.position.x + X, Jet.position.y + Y);//Sets the node's postion from the previous varibles and uses the Jet's postion as a base
        Boom.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(1,1)];//Small hit box as it's nice to have particles collide but not too often, hence why it is smaller than the displayed size
        Boom.physicsBody.collisionBitMask = BoomCatagory;//Gives it a collison bit so that other entities don't collide with it
        
        VX = X * 0.001;//Sets the velocity based on the x and y position so the distance from the player is proportional to the speed of the explosion
        VY = Y * 0.001;
        
        [Boom.physicsBody applyImpulse:CGVectorMake(VX, VY)];//Apply the impluse to the particle so that it moves with the previous velocities
        Boom.zPosition = 5; // A Z position of 5 means that it will above all the game layers, just bellow the UI layers
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
}

-(void)Generate{//Called to check if the game needs to remove old and generate new nodes
    if (!self.Game_over){//If the game is running and a fail state has not been reached
    [World enumerateChildNodesWithName:@"Ocean" usingBlock:^(SKNode *Node, BOOL *stop){//Gets all nodes with the tag 'Ocean'
        if ((Node.position.x + 500) < Jet.position.x ){ //If the node is off screen...
            [Node removeFromParent]; //It gets removed...
            [Generator Generate_A_Ocean]; //Then a new one is generated...
            ThePoints += 1;//And in the specific case of ocean, points are added for proggressing across the terrian
            //This is the way that all the terrian generation methods are called, with exception of adding points as this is unique to the Ocean
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
            [Generator Generate_A_ParallaxClose:false];//The 'false' value being passed tells the function that this is not an intial generation of terrian so parallax is required
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{//Called any time the screen is touched
    if (!self.Started){  // Used to start the game with a touch
        [self Start_The_Game_Already]; //Starts the game
    }else if (self.Game_over){ // Used to clear the screen once a fail state has been reached
        [self Clear_Screen];
        [self Start_Screen];
        self.Started=false;
    }else{ // Used to move the player when the game is still running
        [Jet Boost];
    };
    
}

-(void)Remove_Start_Screen{//Removes the start screen so the game is visible
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
        if (Jet.position.y > 180){
            [self LowerThePoints];
        }
    }
    NSString *Temp = [NSString stringWithFormat:@"Score: %1ld", (long)ThePoints];
    Score.text = Temp;
    
}

-(void)LowerThePoints{
    ThePoints += -10;
    [Jet.physicsBody applyImpulse:CGVectorMake(0,-1)];
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
