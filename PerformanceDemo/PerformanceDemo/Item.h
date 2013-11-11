//
//  Item.h
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemTableViewCell.h"

@interface Item : NSObject

@property (nonatomic) NSInteger index;
@property (nonatomic) CGFloat progress;

@property (nonatomic, weak) ItemTableViewCell *cell;

- (void)startReportingProgress;

@end
