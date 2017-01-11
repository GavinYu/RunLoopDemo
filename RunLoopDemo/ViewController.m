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
    BOOL pageStillLoading;
}
@property (weak, nonatomic) IBOutlet UITextView *testTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageStillLoading = YES;
    // Do any additional setup after loading the view, typically from a nib.
    _fly = [[Flying alloc] init];
    _fly.delegate = self;

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


#pragma mark 给当前线程Run Loop 添加观察者
- (IBAction)clickAddObserverButton:(UIButton *)sender {
    [self performSelector:@selector(runLoopTest) withObject:nil afterDelay:5.0];
}

#pragma mark 给当前线程Run Loop 添加Timer
- (IBAction)clickAddTimerButton:(UIButton *)sender {
    __weak __typeof(self) weakSelf = self;
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
    
    CFAbsoluteTime fireDate = CFAbsoluteTimeGetCurrent();
    CFRunLoopTimerRef runLoopTimer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 2.0f, 0, 0, ^(CFRunLoopTimerRef timer) {
        [weakSelf testFly];
    });
    
    // 1、但是这种模式下如果拖拽界面，runloop会自动进入UITrackingMode,优先于定时器追踪模式
//    CFRunLoopAddTimer(currentRunLoop, runLoopTimer, kCFRunLoopDefaultMode);
    
    // 2、还有一种runloop的mode，占位运行模式
    // 就可以无论是界面追踪还是普通模式都可以运行
    /**
     NSTimer的问题，NSTimer是runloop的一个触发源，由于NSTimer是添加到runloop中使用的，所以如果只添加到default模式，会导致拖拽界面的时候runloop进入界面跟踪模式而定时器暂停运行，不拖拽又恢复的问题，这时候就应该使用runloop的NSRunLoopCommonModes模式，能够让定时器在runloop两种模式切换时也不受影响。
     */
    CFRunLoopAddTimer(currentRunLoop, runLoopTimer, kCFRunLoopCommonModes);
}

- (IBAction)clickAddSource:(id)sender {
    //1、基于端口的输入源
    
}


//MARK:基于端口的输入源
- (void)createPortSource {
    CFMessagePortCallBack myCallbackFunc;
    CFMessagePortRef port = CFMessagePortCreateLocal(kCFAllocatorDefault, CFSTR("com.someport"), myCallbackFunc, NULL, NULL);
    CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, port, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopCommonModes);
    
    while (pageStillLoading) {
        CFRunLoopRun();
    }
    
    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    CFRelease(source);
}
@end
