//
//  ItemTableViewCell.m
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "ItemTableViewCell.h"

@implementation ItemTableViewCell


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)updateWithItem:(Item *)item {
  // Remove old
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  // Set up new item
  
  self.indexLabel.text = [NSString stringWithFormat:@"#%d", item.index];
  self.progressLabel.text = [NSString stringWithFormat:@"Progress: %.2f", item.progress];
  
  [self.progressView resetProgress];
  [self.progressView setProgress:item.progress];
  
  __weak typeof(Item)*weakItem = item;
  
  [self.progressView completionBlock:^{
    
    [weakItem startReportingProgress];
    [self.progressView resetProgress];
    
  } withDelay:2.0];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(progress:) name:ProgressNotification object:item];
  
}


- (void)progress:(NSNotification*)notification {
  
  Item *item = notification.object;
  self.progressLabel.text = [NSString stringWithFormat:@"Progress: %.2f", item.progress];
  [self.progressView setProgress:item.progress];
  
}


@end
