//
//  MCHJetpackSprite.m
//  JetpackExplorer
//
//  Created by Marc Henderson on 2014-03-11.
//  Copyright (c) 2014 Marc Henderson. All rights reserved.
//

#import "MCHJetpackSprite.h"

@implementation MCHJetpackSprite

- (void)thrustWithForce:(double)force {
    self.physicsBody.velocity = CGVectorMake(0, 0);
    [self.physicsBody applyImpulse:CGVectorMake(0, force)];
}

- (void)thrustContinousUp{
    self.physicsBody.velocity = CGVectorMake(0, 5);
}

- (void)stop{
    self.physicsBody.velocity = CGVectorMake(0, 0);
}

@end
