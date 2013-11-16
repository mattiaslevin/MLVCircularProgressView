//
//  ViewController.m
//  SimpleDemo
//
//  Created by Mattias Levin on 10/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end


@implementation ViewController


- (void)viewDidLoad {
  [super viewDidLoad];
  
//  self.progressView.animationDuration = ^ (CGFloat progress,
//                                           CGFloat increaseSinceLastProgress,
//                                           NSTimeInterval durationSinceLastProgress,
//                                           CGFloat *animatedProgress) {
//    return 0.3;
//  };
  
  [self startProgress];
  
}


- (void)startProgress {
  
  __weak typeof(self)weakSelf = self;
  
  self.progressLabel.text = @"-";
  [self.progressView startUnknownProgress];
  
  [self.progressView completionBlock:^{
    NSLog(@"Download finsihed");
    
    [self.progressView resetProgress];
    [self startProgress];
    
  } withDelay:2.0];
  
  double delayInSeconds = 1.2;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [weakSelf updateProgress:0.0];
    
  });
  
}


- (void)updateProgress:(CGFloat)progress {
  
  if (progress >= 1.0) {
    // Lets stop
    NSLog(@"Stop updating progress");
    progress = 1.0;
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f", progress];
    self.progressView.progress = progress;
    return;
  } else {
    self.progressLabel.text = [NSString stringWithFormat:@"%.2f", progress];
    self.progressView.progress = progress;
  }
  
  __weak typeof(self)weakSelf = self;
  
  double delayInSeconds = 1.0 + arc4random_uniform(100) / 100.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    CGFloat newProgress = progress + (arc4random_uniform(15) / 100.0);
    [weakSelf updateProgress:newProgress];
    
  });
  
}


@end
