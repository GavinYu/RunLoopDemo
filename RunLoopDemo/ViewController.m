//
//  ViewController.m
//  RunLoopDemo
//
//  Created by yc-sh-vr-pc05 on 16/5/30.
//  Copyright © 2016年 GavinYu. All rights reserved.
//

#import "ViewController.h"

#import "Flying.h"

@interface ViewController () <FlyDelegate>
{
    CFRunLoopObserverCallBack myRunLoopObserver;
    Flying *_fly;
    NSTimer *_runLoopTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _fly = [[Flying alloc] init];
    _fly.delegate = self;
    
    [self testFly];
    
//    _runLoopTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runLoopTest) userInfo:nil repeats:YES];
}


#pragma mark 给当前线程Run Loop 添加观察者
- (void)runLoopTest {
    //获取当前线程的RunLoop
    CFRunLoopRef myRunLoop = CFRunLoopGetCurrent();
    
    //创建一个RunLoop的观察者，并将之添加到该RunLoop中
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopExit:
                NSLog(@"即将退出RunLoop");
                break;
                
            case kCFRunLoopAfterWaiting:
                NSLog(@"刚从休眠中唤醒");
                break;
                
            case kCFRunLoopEntry:
                NSLog(@"即将进入RunLoop");
                break;
                
            case kCFRunLoopBeforeTimers:
                NSLog(@"即将处理 Timer");
                break;
                
            case kCFRunLoopAllActivities:
                NSLog(@"即将进入活跃");
                break;
                
            case kCFRunLoopBeforeSources:
                NSLog(@"即将处理 Source");
                break;
                
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入休眠");
                break;
                
            default:
                break;
        }
    });
    CFRunLoopAddObserver(myRunLoop, observer, kCFRunLoopDefaultMode);
    
}

- (void)testFly {
    NSLog(@"Start Fly");
}

- (void)FlyFinished {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)clickAddObserverButton:(UIButton *)sender {
    [self performSelector:@selector(runLoopTest) withObject:nil afterDelay:2.0];
}
@end
