//
//  Flying.h
//  RunLoopDemo
//
//  Created by yc-sh-vr-pc05 on 16/6/17.
//  Copyright © 2016年 GavinYu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlyDelegate <NSObject>

- (void)FlyFinished;

@end

@interface Flying : NSObject

@property (nonatomic, assign) id <FlyDelegate> delegate;

- (void)testFly;

@end
