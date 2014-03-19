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
        
        [self addPhysicsBodiesToTilesInLayer:self.walls];
        
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
    UIPanGestureRecognizer *playerControlGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragPlayer:)];
    playerControlGesture.minimumNumberOfTouches = 1;
    playerControlGesture.delegate = self;
    [[self view] addGestureRecognizer:playerControlGesture];
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
    //[self checkForAndResolveCollisionsForPlayer:self.player forLayer:self.walls];

    
    [_parallaxNodeBackgrounds update:currentTime];    //other additional game background
    [_parallaxSpaceDust update:currentTime];
    if (self.thrustOn) {
        [self.player thrustWithForce:self.thrustForce];
        self.thrustForce = (self.thrustForce < MAXTHRUST) ? self.thrustForce + THRUSTACCELERATION : MAXTHRUST;
    }
    [self setViewpointCenter:self.player.position];
}

- (void)addPhysicsBodiesToTilesInLayer:(TMXLayer *)layer{
    int gridWidth = 212;
    int gridHeight = 20;
    //TODO: update the gridWidth and gridHeight to come from the tilemap itself - I can always add it as a property.
    
    for (int w = 0 ; w < gridWidth; ++w) {
        for(int h = 0; h < gridHeight; ++h) {
            CGPoint coord = CGPointMake(w, h);
            NSInteger tileGid = [layer.layerInfo tileGidAtCoord:coord];
            if(tileGid){
                NSLog(@"found a gid with a tile at coord:x:%f:y:%f",coord.x,coord.y);
                SKSpriteNode *tileNode = [layer tileAtCoord:coord];
                tileNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:tileNode.size];
                tileNode.physicsBody.affectedByGravity = NO;
                tileNode.physicsBody.dynamic = NO;
            }
        }
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

-(void)dragPlayer:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"detecting pan");
        CGPoint touchLocation = [gesture locationInView:gesture.view];
        touchLocation = [self convertPointFromView:touchLocation];
        if (touchLocation.y < self.player.position.y + 40) {
            self.movePlayer = YES;
        }
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        NSLog(@"in pan");
        if(self.movePlayer){
            NSLog(@"and moving player");
            CGPoint trans = [gesture translationInView:self.view];
            BOOL applyMove = YES;
            if (trans.x < 0) {
                if(((self.player.position.x - self.player.size.width/2) + trans.x) < 0){
                    applyMove = NO;
                }
            }else{
                if(((self.player.position.x + self.player.size.width/2) + trans.x) > self.size.width){
                    applyMove = NO;
                }
            }
            if (applyMove) {
                SKAction *movePlayer =  [SKAction moveByX:trans.x y:0  duration:0];
                [self.player runAction:movePlayer];
//                [self.playerControl runAction:movePlayer];
            }
        }
        [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"ending pan");
        self.movePlayer = NO;
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began...");
//    self.thrustOn = YES;
//    [self.player thrustContinousUp];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches ended...");
    self.thrustOn = NO;
    self.thrustForce = INITIALTHRUST;
//    [self.player stop];
}
/**
 * Subtracts point2 from point1 and returns the result as a new CGPoint.
 */
CGPoint CGPointSubtract(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x - point2.x, point1.y - point2.y);
}

- (void)setViewpointCenter:(CGPoint)position {
    NSInteger x = MAX(position.x, self.size.width / 2);
    NSInteger y = MAX(position.y, self.size.height / 2);
    x = MIN(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2);
    y = MIN(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2);
    CGPoint actualPosition = CGPointMake(x, y);
    CGPoint centerOfView = CGPointMake(self.size.width/2, self.size.height/2);
    CGPoint viewPoint = CGPointSubtract(centerOfView, actualPosition);
    self.map.position = viewPoint;
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
