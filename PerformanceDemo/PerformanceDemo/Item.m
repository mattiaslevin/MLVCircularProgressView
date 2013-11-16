//
//  Item.m
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "Item.h"


NSString * const ProgressNotification = @"ProgressNotification";


@implementation Item


- (void)startReportingProgress {
  
  self.progress = 0.0;
  
  double delayInSeconds = arc4random_uniform(30) / 10.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [self updateProgress];
    
  });
  
}


- (void)updateProgress {
  
  if (self.progress >= 1.0) {
    // Lets stop
    NSLog(@"Stop updating progress");
    self.progress = 1.0;
    [[NSNotificationCenter defaultCenter] postNotificationName:ProgressNotification object:self];
    return;
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:ProgressNotification object:self];
  }
  
  __weak typeof(self)weakSelf = self;
  
  double delayInSeconds = 1.0 + arc4random_uniform(100) / 100.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    self.progress += (arc4random_uniform(15) / 100.0);
    [weakSelf updateProgress];
    
  });
  
}


@end
