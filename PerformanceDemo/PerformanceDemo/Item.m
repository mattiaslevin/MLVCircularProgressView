//
//  Item.m
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "Item.h"

@implementation Item


- (void)startReportingProgress {
  
  __weak typeof(self)weakSelf = self;
  
  [self.cell.progressView startUnknownProgress];
  
  double delayInSeconds = arc4random_uniform(30) / 10.0;
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
    self.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f", progress];
    self.cell.progressView.progress = progress;
    return;
  } else {
    self.cell.progressLabel.text = [NSString stringWithFormat:@"%.2f", progress];
    self.cell.progressView.progress = progress;
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
