//
//  MCHJetpackSprite.h
//  JetpackExplorer
//
//  Created by Marc Henderson on 2014-03-11.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MCHJetpackSprite : SKSpriteNode

@property (strong,atomic) NSArray *textureArray;
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) CGPoint velocity;

- (void)thrustYWithForce:(double)force;
- (void)thrustXWithForce:(double)force;

- (void)thrustAtVelocity:(double)velocity;
- (void)thrustContinousUp;
- (void)stop;
- (void)moveToPointX:(CGPoint)point;

-(void)update:(CFTimeInterval)currentTime;

@end
