//
//  MCHGameplayScene.h
//  JetpackExplorer
//
//  Created by Marc Henderson on 2/10/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class MCHJetpackSprite,JSTileMap,TMXLayer;

@interface MCHGameplayScene : SKScene <UIGestureRecognizerDelegate>

@property (strong,atomic) MCHJetpackSprite *player;
@property BOOL upOn;
@property BOOL forwardOn;
@property BOOL backwardOn;
@property BOOL movePlayer;
@property double upForce;
@property double forwardForce;
@property double backwardForce;
@property (nonatomic, strong) JSTileMap *map;
@property (nonatomic, strong) TMXLayer *walls;
@property (nonatomic, strong) TMXLayer *hazards;
@property (strong,atomic)SKSpriteNode *forwardButton;
@property (strong,atomic)SKSpriteNode *backButton;
@property (strong,atomic)SKSpriteNode *upButton;

@end
