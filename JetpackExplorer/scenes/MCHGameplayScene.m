//
//  MCHGameplayScene.m
//  JetpackExplorer
//
//  Created by Marc Henderson on 2/10/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"
#import "MCHjetpackSprite.h"
#import "FMMParallaxNode.h"
#import "JSTileMap.h"

@implementation MCHGameplayScene
{
    FMMParallaxNode *_parallaxNodeBackgrounds;
    FMMParallaxNode *_parallaxSpaceDust;
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.thrustForce = INITIALTHRUST;
        /* Setup your scene here */
        
        /* give the scene a background color
         self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];
         */
        self.backgroundColor = [SKColor colorWithRed:83.0/255 green:135.0/255 blue:170.0/255 alpha:1.0];

        self.map = [JSTileMap mapNamed:@"level1.tmx"];
        [self addChild:self.map];
        self.walls = [self.map layerNamed:@"walls"];
        self.hazards = [self.map layerNamed:@"hazards"];
        
        /* give the scene a background image
         SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"scene-background"];
         [background setName:@"background"];
         [background setAnchorPoint:CGPointZero];
         [self addChild:background];
         */
        
//        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue UltraLight"];
//        title.text = @"gameplay scene - make it happen here!";
//        title.fontSize = 38;
//        title.fontColor = [UIColor whiteColor];
//        title.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - title.frame.size.height * 2);
//        [self addChild:title];
        
        
        NSArray *parallaxBackgroundNames = @[@"clouds1-sized.png"];
        CGSize planetSizes = CGSizeMake(257.0, 100.0);
        _parallaxNodeBackgrounds = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackgroundNames
                                                                           size:planetSizes
                                                           pointsPerSecondSpeed:10.0];
        _parallaxNodeBackgrounds.position = CGPointMake(size.width/2.0, size.height/2.0);
        [_parallaxNodeBackgrounds randomizeNodesPositions];
        [self addChild:_parallaxNodeBackgrounds];

        NSArray *parallaxBackground2Names = @[@"bg_front_spacedust.png",@"bg_front_spacedust.png"];
        _parallaxSpaceDust = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackground2Names
                                                                     size:size
                                                     pointsPerSecondSpeed:25.0];
        _parallaxSpaceDust.position = CGPointMake(0, 0);
        [self addChild:_parallaxSpaceDust];
        
        
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sprites"];
        SKTexture *playerSprite = [atlas textureNamed:@"player.png"];
        NSArray *spriteTextureArray = @[playerSprite];
        
        self.physicsWorld.gravity = CGVectorMake(0, GRAVITY);

        self.player = [[MCHJetpackSprite alloc] initWithTexture:playerSprite color:[UIColor whiteColor] size:CGSizeMake(21, 40)];
//        jetpackToFall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.player.position = CGPointMake(CGRectGetMidX(self.frame)-75, self.frame.size.height-60);
        self.player.textureArray = spriteTextureArray;
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        [self.map addChild:self.player];

        
    }
    return self;
}

- (void)didMoveToView:(SKView *)view{
    /*
    UITapGestureRecognizer *shortThrust = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(applyShortThrust:)];
    shortThrust.delegate = self;
    [[self view] addGestureRecognizer:shortThrust];
    
    UILongPressGestureRecognizer *longThrust = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(applyLongThrust:)];
    longThrust.delegate = self;
    [[self view] addGestureRecognizer:longThrust];
     */
}

-(void)update:(CFTimeInterval)currentTime {
    [self checkForAndResolveCollisionsForPlayer:self.player forLayer:self.walls];

    
    [_parallaxNodeBackgrounds update:currentTime];    //other additional game background
    [_parallaxSpaceDust update:currentTime];
    if (self.thrustOn) {
        [self.player thrustWithForce:self.thrustForce];
        self.thrustForce = (self.thrustForce < MAXTHRUST) ? self.thrustForce + THRUSTACCELERATION : MAXTHRUST;
    }
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer
{
    TMXLayerInfo *layerInfo = layer.layerInfo;
    return [layerInfo tileGidAtCoord:coord];
}

- (void)checkForAndResolveCollisionsForPlayer:(MCHJetpackSprite *)player forLayer:(TMXLayer *)layer
{
    NSInteger indices[8] = {7, 1, 3, 5, 0, 2, 6, 8};
//    player.onGround = NO;  ////Here
    for (NSUInteger i = 0; i < 8; i++) {
        NSInteger tileIndex = indices[i];
        
//        CGRect playerRect = [player collisionBoundingBox];
        CGPoint playerCoord = [layer coordForPoint:player.position];
        
        if (playerCoord.y >= self.map.mapSize.height - 1) {
//            [self gameOver:0];
            return;
        }
        
        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));
        
        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
        if (gid != 0) {
            NSLog(@"player hit a wall");
//            [self.player thrustWithForce:-(GRAVITY)];
            [self.player thrustAtVelocity:-(GRAVITY)*3];
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began...");
    self.thrustOn = YES;
//    [self.player thrustContinousUp];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches ended...");
    self.thrustOn = NO;
    self.thrustForce = INITIALTHRUST;
//    [self.player stop];
}


-(void)applyShortThrust:(UITapGestureRecognizer *)gesture{
    CGPoint location = [gesture locationInView:gesture.view];
    location = [self convertPointFromView:location];
    [self.player thrustWithForce:3];
}


-(void)applyLongThrust:(UITapGestureRecognizer *)gesture{
    NSLog(@"long thrust");
    CGPoint location = [gesture locationInView:gesture.view];
    location = [self convertPointFromView:location];
    [self.player thrustWithForce:6];
}


@end
