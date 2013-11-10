//
//  MLVCircularProgressView.h
//  MLVCircularProgressView
//
//  Created by Mattias Levin on 27/10/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLVCircularProgressView : UIView

/**
 The color of the drawn shape.
 
 Use the UIView properties to set other standard view behaviour.
 */
@property (nonatomic, strong) UIColor *shapeColor;

/**
 The minimum progress change between two succesivly reported progress to trigger an animation.
 
 A lower value will improve animation smothness also increate the CPU needed.
 Value should be between 0.01 and 0.99. Default value is 0.1.
 */
@property (nonatomic) CGFloat minimumProgressChangeToTriggerAnimation;

/**
 Show an unknown progress animation until the first actual progress is reported.
 @see progress
 */
- (void)startUnknownProgress;


/**
 Show an unknown progress animation for a minimum duration or until the first actual progess is reported.
 
 Use this method to make sure the unknow progress animation is shown a minimum amount of time for the user regardless of how fast the first progress is reported.
 */
- (void)startUnknownProgressWithMinimumDuration:(NSTimeInterval)minimumDuration;

/**
 Set the progress of the progress view.
 
 The first reported progress value will not be animated. If you like the first reported progress to be animated, make sure you set the progress to 0.0 before the first actual progress value is set.
 */
@property (nonatomic) CGFloat progress;


/**
 The completion block will be called when the progress reach 1.0 and the animation finish.
 @param completionBlock The completion block to run
*/
- (void)completionBlock:(void(^)(void))completionBlock;

/**
 The completion block will be called after the provided delay when the progress reach 1.0 and the animation finish.
 
 Use this method to guarentee that the finished progress is shonw a minimum amount of time for the user after the progress compeleted.
 
 @param completionBlock The completion block to run
 @param withDelay The delay before calling the completion block
 */
- (void)completionBlock:(void(^)(void))completionBlock withDelay:(NSTimeInterval)delay;

/**
 Stop all ongoing progress animations.
 */
- (void)stopProgress;

@end
