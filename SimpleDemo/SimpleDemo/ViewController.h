//
//  ViewController.h
//  SimpleDemo
//
//  Created by Mattias Levin on 10/11/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLVCircularProgressView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet MLVCircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end
