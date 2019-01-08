//
//  ViewController.m
//  ZGSoundTouchPro
//
//  Created by ali on 2019/1/4.
//  Copyright © 2019 com.alibaba-inc. All rights reserved.
//

#import "ViewController.h"
#include "Wav_demo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testWav];
}


- (void)testWav
{
    Wav_demo* wav_demo = new Wav_demo();
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *outFilePath = [cachePath stringByAppendingPathComponent:@"result.wav"];
    wav_demo->demo_main((char *)[outFilePath UTF8String]);
}


@end
