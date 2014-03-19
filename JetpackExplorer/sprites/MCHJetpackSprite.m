//
//  MCHJetpackSprite.m
//  JetpackExplorer
//
//  Created by Marc Henderson on 2014-03-11.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHJetpackSprite.h"

@implementation MCHJetpackSprite

- (instancetype)initWithImageNamed:(NSString *)name
{
    if (self == [super initWithImageNamed:name]) {
        self.velocity = CGPointMake(0.0, 0.0);
    }
    return self;
}

- (void)thrustWithForce:(double)force {
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self.physicsBody applyImpulse:CGVectorMake(0, force)];
}

- (void)thrustAtVelocity:(double)velocity{
    self.physicsBody.velocity = CGVectorMake(0, velocity);
}

- (void)thrustContinousUp{
    self.physicsBody.velocity = CGVectorMake(0, 5);
}

- (void)stop{
    self.physicsBody.velocity = CGVectorMake(0, 0);
}

/**
 * Adds two CGPoint values and returns the result as a new CGPoint.
 */
CGPoint CGPointAdd(CGPoint point1, CGPoint point2) {
    return CGPointMake(point1.x + point2.x, point1.y + point2.y);
}

- (void)moveToPointX:(CGPoint)point{
    self.position = CGPointMake(point.x, self.position.y);
}

@end
