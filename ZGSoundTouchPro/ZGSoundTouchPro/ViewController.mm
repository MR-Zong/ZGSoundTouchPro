//
//  ViewController.m
//  ZGSoundTouchPro
//
//  Created by ali on 2019/1/4.
//  Copyright © 2019 com.alibaba-inc. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#include "Wav_demo.h"

@interface ViewController () <AVAudioPlayerDelegate>

@property (nonatomic, strong) UIButton *changeBtn;
@property (nonatomic, strong) UILabel *pitchTipLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *ori_playBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UITextView *originaltextView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) AVAudioPlayer *musicPlayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testWav];
    
    AVAudioSession* as = [AVAudioSession sharedInstance];
    [as setCategory:AVAudioSessionCategoryPlayback error:nil];
}

- (void)didTouch
{
    [self.view endEditing:YES];
}

- (void)testWav
{
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)]];
    _originaltextView = [[UITextView alloc] init];
    _originaltextView.frame = CGRectMake(50, 50, 300, 80);
    _originaltextView.backgroundColor = [UIColor grayColor];
    _originaltextView.text = [[NSBundle mainBundle] pathForResource:@"testZong.wav" ofType:nil];
    [self.view addSubview:_originaltextView];
    
    
    _ori_playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ori_playBtn setTitle:@"播放原始音频" forState:UIControlStateNormal];
    _ori_playBtn.backgroundColor = [UIColor redColor];
    _ori_playBtn.frame = CGRectMake(50, 150, 120, 40);
    [_ori_playBtn addTarget:self action:@selector(didOriPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ori_playBtn];
    
    _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changeBtn setTitle:@"转换" forState:UIControlStateNormal];
    _changeBtn.backgroundColor = [UIColor redColor];
    _changeBtn.frame = CGRectMake(50, 200, 60, 40);
    [_changeBtn addTarget:self action:@selector(didChangeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changeBtn];
    
    _pitchTipLabel = [[UILabel alloc] init];
    _pitchTipLabel.backgroundColor = [UIColor redColor];
    _pitchTipLabel.text = @"请输入音调值：";
    _pitchTipLabel.frame = CGRectMake(130, 210, 130, 20);
    [self.view addSubview:_pitchTipLabel];
    
    _textField = [[UITextField alloc] init];
    _textField.backgroundColor = [UIColor darkGrayColor];
    _textField.text = @"6";
    _textField.frame = CGRectMake(265, 210, 30, 20);
    [self.view addSubview:_textField];
    
    _textView = [[UITextView alloc] init];
    _textView.userInteractionEnabled = NO;
    _textView.frame = CGRectMake(50, 250, 300, 200);
    _textView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_textView];
    
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.backgroundColor = [UIColor redColor];
    [_playBtn setTitle:@"播放转换后音频" forState:UIControlStateNormal];
    _playBtn.frame = CGRectMake(50, 460, 140, 40);
    [_playBtn addTarget:self action:@selector(didPlayBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playBtn];
    
}


#pragma mark - action
- (void)didOriPlayBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.backgroundColor = [UIColor greenColor];
        NSString *oriFilePath = [[NSBundle mainBundle] pathForResource:@"testZong.wav" ofType:nil];
        
        NSURL *fileUrl = [NSURL URLWithString:oriFilePath];
        self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileUrl error:nil];
        // 3.打印歌曲信息
        NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.musicPlayer.numberOfChannels,self.musicPlayer.duration];
        NSLog(@"%@",msg);
        // 4.设置循环播放
        self.musicPlayer.numberOfLoops = -1;
        self.musicPlayer.delegate = self;
        // 5.开始播放
        [self.musicPlayer play];
        
    }else {
        btn.backgroundColor = [UIColor redColor];
        [self stopPlay];
    }
    
}

- (void)didChangeBtn:(UIButton *)btn
{
   
    Wav_demo* wav_demo = new Wav_demo();
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    NSString *outFilePath = [cachePath stringByAppendingPathComponent:@"result.wav"];
    

    if ([[NSFileManager defaultManager] fileExistsAtPath:outFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outFilePath error:nil];
        sleep(1.0);
    }
    
    int pitchVauld = [self.textField.text intValue];
    if (pitchVauld > 12) {
        pitchVauld = 12;
    }
    if (pitchVauld < -12) {
        pitchVauld = -12;
    }

    self.textView.text = @"changeing...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        wav_demo->demo_main((char *)[outFilePath UTF8String],pitchVauld);
        dispatch_sync(dispatch_get_main_queue(), ^{
            if ([[NSFileManager defaultManager] fileExistsAtPath:outFilePath]) {
                self.textView.text = [NSString stringWithFormat:@"pitchVaule %d",pitchVauld];
                self.textView.text = [NSString stringWithFormat:@"pitchVaule %d \n done !",pitchVauld];
            }
        });
    });
}

- (void)didPlayBtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.backgroundColor = [UIColor greenColor];
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
        NSString *outFilePath = [cachePath stringByAppendingPathComponent:@"result.wav"];
        self.musicPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:outFilePath] error:nil];
        // 3.打印歌曲信息
        NSString *msg = [NSString stringWithFormat:@"音频文件声道数:%ld\n 音频文件持续时间:%g",self.musicPlayer.numberOfChannels,self.musicPlayer.duration];
        NSLog(@"%@",msg);
        // 4.设置循环播放
        self.musicPlayer.numberOfLoops = -1;
        self.musicPlayer.delegate = self;
        // 5.开始播放
        [self.musicPlayer play];
        
        
    }else {
        btn.backgroundColor = [UIColor redColor];
        [self stopPlay];
    }
    
}

- (void)stopPlay
{
    [self.musicPlayer stop];
    self.musicPlayer = nil;
}

#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self.musicPlayer stop];
    self.musicPlayer=nil;
    self.musicPlayer.delegate = nil;
}



@end
