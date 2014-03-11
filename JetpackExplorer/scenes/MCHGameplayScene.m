//
//  MCHGameplayScene.m
//  JetpackExplorer
//
//  Created by Marc Henderson on 2/10/2014.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHGameplayScene.h"
#import "MCHjetpackSprite.h"

@implementation MCHGameplayScene

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
        title.text = @"gameplay scene - make it happen here!";
        title.fontSize = 38;
        title.fontColor = [UIColor whiteColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame),self.frame.size.height - title.frame.size.height * 2);
        [self addChild:title];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"sprites"];
        SKTexture *spriteTextureA = [atlas textureNamed:@"sprite-01-a.png"];
        SKTexture *spriteTextureB = [atlas textureNamed:@"aprite-01-b.png"];
        NSArray *spriteTextureArray = @[spriteTextureA,spriteTextureB];

        MCHJetpackSprite *jetpackToFall = [[MCHJetpackSprite alloc] initWithTexture:spriteTextureA color:[UIColor whiteColor] size:CGSizeMake(50, 33)];
//        jetpackToFall.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        jetpackToFall.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
        jetpackToFall.textureArray = spriteTextureArray;
        jetpackToFall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:jetpackToFall.size];
        [self addChild:jetpackToFall];

        
    }
    return self;
}

@end
