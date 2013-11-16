//
//  ItemTableViewCell.h
//  PerformanceDemo
//
//  Created by Mattias Levin on 11/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVCircularProgressView.h"
#import "Item.h"


@interface ItemTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet MLVCircularProgressView *progressView;

- (void)updateWithItem:(Item*)item;

@end
