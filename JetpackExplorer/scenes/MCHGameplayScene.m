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
        
        
        NSArray *parallaxBackgroundNames = @[@"bg_galaxy.png", @"bg_planetsunrise.png",
                                             @"bg_spacialanomaly.png", @"bg_spacialanomaly2.png"];
        CGSize planetSizes = CGSizeMake(200.0, 200.0);
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
        
        self.physicsWorld.gravity = CGVectorMake(0, -1);

        self.player = [[MCHJetpackSprite alloc] initWithTexture:playerSprite color:[UIColor whiteColor] size:CGSizeMake(31, 60)];
//        jetpackToFall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.player.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
        self.player.textureArray = spriteTextureArray;
        self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.player.size];
        [self addChild:self.player];

        
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
    [_parallaxNodeBackgrounds update:currentTime];    //other additional game background
    [_parallaxSpaceDust update:currentTime];
    if (self.thrustOn) {
        [self.player thrustWithForce:self.thrustForce];
        self.thrustForce = (self.thrustForce < MAXTHRUST) ? self.thrustForce + THRUSTACCELERATION : MAXTHRUST;
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
