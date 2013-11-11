//
//  ViewController.m
//  PerformanceDemo
//
//  Created by Mattias Levin on 10/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"
#import "ItemTableViewCell.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *items;

@end


static NSInteger const NumberOfItems = 100;
static NSString * const ProgressCell = @"ProgressCell";


@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  [self.tableView registerClass:[ItemTableViewCell class] forCellReuseIdentifier:ProgressCell];
  
  self.items = [NSMutableArray array];
  for (int i = 0; i < NumberOfItems; i++) {
    Item *item = [[Item alloc] init];
    item.index = i;
    item.progress = 0.0;
    [self.items addObject:item];
    
    [item startReportingProgress];
  }

  [self.tableView reloadData];
  
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return NumberOfItems;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProgressCell];
  
  Item *item = [self.items objectAtIndex:indexPath.row];
  
  cell.indexLabel.text = [NSString stringWithFormat:@"#%d", item.index];
  cell.progressLabel.text = [NSString stringWithFormat:@"Progress: %.2f", item.progress];

  [cell.progressView completionBlock:^{
    [cell.progressView resetProgress];
    [item startReportingProgress];
  } withDelay:2.0];
  
  [cell.progressView resetProgress];
  cell.progressView.progress = item.progress;
  
  item.cell = cell;
  
  return cell;
}


@end
