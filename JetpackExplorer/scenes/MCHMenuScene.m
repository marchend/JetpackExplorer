//
//  MCHMyScene.m
//  JetpackExplorer
//
//  Created by Marc Henderson on 2/10/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHMenuScene.h"
#import "MCHGameplayScene.h"
#import "MCHLeaderboardScene.h"

@implementation MCHMenuScene

- (void)addVersionLabel {
    /*
     SKLabelNode *playButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
     playButtonLabel.text = @"NEW GAME";
     playButtonLabel.fontSize = 28;
     playButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame) - 30);
     playButtonLabel.fontColor = [UIColor whiteColor];
     [self addChild:playButtonLabel];
     
     self.playButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, playButtonLabel.frame.size.height+60)];
     self.playButton.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y+playButtonLabel.frame.size.height/2);
     
     SKLabelNode *highScoreButtonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
     highScoreButtonLabel.text = @"HIGH SCORES";
     highScoreButtonLabel.fontSize = 28;
     highScoreButtonLabel.position = CGPointMake(CGRectGetMidX(self.frame),playButtonLabel.position.y - playButtonLabel.frame.size.height*4);
     highScoreButtonLabel.fontColor = [UIColor whiteColor];
     [self addChild:highScoreButtonLabel];
     
     self.leaderboardButton = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, highScoreButtonLabel.frame.size.height+60)];
     self.leaderboardButton.position = CGPointMake(CGRectGetMidX(self.frame),highScoreButtonLabel.position.y+highScoreButtonLabel.frame.size.height/2);
     */
    
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* version = [infoDict objectForKey:@"CFBundleVersion"];
    SKLabelNode *versionDisplay = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    versionDisplay.text = [NSString stringWithFormat:@"version %@",version];
    versionDisplay.fontSize = 12;
    versionDisplay.position = CGPointMake(CGRectGetMidX(self.frame),versionDisplay.frame.size.height + 5);
    versionDisplay.fontColor = [UIColor whiteColor];
    [self addChild:versionDisplay];
}

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        /* give the scene a background color
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
         */
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
        
        /* give the scene a background image
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"scene-background"];
        [background setName:@"background"];
        [background setAnchorPoint:CGPointZero];
        [self addChild:background];
         */
        
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
        title.text = @"JETPACK EXPLORER";
        title.fontSize = 28;
        title.fontColor = [UIColor whiteColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+40);
        [self addChild:title];
        
        self.playButton = [self createMenuButtonWithLabel:@"NEW GAME" atPosition:CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))];
        self.leaderboardButton = [self createMenuButtonWithLabel:@"HIGH SCORES" atPosition:CGPointMake(CGRectGetMidX(self.frame),self.playButton.position.y-50)];
        
        [self addVersionLabel];
        
        [self addChild:self.playButton];
        [self addChild:self.leaderboardButton];
        
    }
    return self;
}

-(SKSpriteNode *)createMenuButtonWithLabel:(NSString *)label atPosition:(CGPoint)position{
    SKLabelNode *buttonLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
    buttonLabel.text = label;
    buttonLabel.fontSize = 18;
    buttonLabel.position = position;
    buttonLabel.fontColor = [UIColor whiteColor];
    [self addChild:buttonLabel];
    
    SKSpriteNode *returnNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(self.frame.size.width, buttonLabel.frame.size.height+40)];
    returnNode.position = CGPointMake(CGRectGetMidX(self.frame),buttonLabel.position.y+buttonLabel.frame.size.height/2);;
    return returnNode;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    if([node isEqual:self.playButton]){
        SKScene *gameScene = [[MCHGameplayScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:gameScene transition:doors];
    }else if([node isEqual:self.leaderboardButton]){
        SKScene *leaderboardScene = [[MCHLeaderboardScene alloc] initWithSize:self.size];
        SKTransition *doors = [SKTransition doorsOpenHorizontalWithDuration:0.5];
        [self.view presentScene:leaderboardScene transition:doors];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
