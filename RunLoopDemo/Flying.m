//
//  Flying.m
//  RunLoopDemo
//
//  Created by yc-sh-vr-pc05 on 16/6/17.
//  Copyright © 2016年 GavinYu. All rights reserved.
//

#import "Flying.h"

@implementation Flying

- (void)testFly {
    NSLog(@"Test Fly Object");
    if (_delegate) {
        [_delegate FlyFinished];
    }
}

@end
