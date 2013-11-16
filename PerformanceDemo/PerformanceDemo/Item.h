//
//  Item.h
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const ProgressNotification;


@interface Item : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CGFloat progress;

- (void)startReportingProgress;

@end
