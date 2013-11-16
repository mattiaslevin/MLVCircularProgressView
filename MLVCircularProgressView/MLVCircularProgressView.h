//
//  MLVCircularProgressView.h
//  MLVCircularProgressView
//
//  Created by Mattias Levin on 27/10/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import <UIKit/UIKit.h>


//typedef NS_ENUM(NSInteger, ProgressState) {
//  ProgressBefore,
//  ProgressAfter,
//  ProgressFailed
//};


/**
 A progress view that mimics the behaviour of the download progress indicator in the iOS7 Apps Store app.
 */
@interface MLVCircularProgressView : UIView

/**
 @name Configuration
 */

/**
 The colour of the drawn shape.
 
 Use the UIView properties to set other standard view behaviour.
 */
@property (nonatomic, strong) UIColor *shapeColor;

/**
 The minimum progress change between two successively reported progress to trigger an animation.
 
 A lower value will allow the animation to follow the actual process closer but will also increase the CPU needed.
 Value should be between 0.01 and 0.99. Default value is 0.1 and should be sufficient in most cases. A developer could consider increasing the value to 0.2 if many progress animations are shown at the same time.
 */
@property (nonatomic) CGFloat minimumProgressChangeToTriggerAnimation;

/**
 Set a custom block that implements your own algorithm for calculating the animation duration and optionally adjusting the target progress between two reported progress values. This block will only be called when a progress change becomes bigger then the minimumProgressChangeToTriggerAnimation value.
 
 The default implementation will naively assume that the next reported progress will have the same increase and velocity as between the current and previous progress. The algorithm will calculate the animation duration based on the velocity between the the current and previous progresses and adjust the animated progress to a future  bigger value based on the calculated velocity. The animate progress can thus be bigger or smaller when the next progress is fired depending on if the velocity decreased or increased.
 
 A custom algorithm could for instance provide a constant animation duration and never let the animated progress grow bigger then the last reported progress. Or an algorithm could calculate the duration based an an average velocity since the start of the animation.
 
 */
@property (nonatomic, copy) NSTimeInterval (^animationDuration)(float progress, float increaseSinceLastProgress, NSTimeInterval durationSinceLastProgress, float *animatedProgress);


/**
 Register and image to shown before the progress animation starts or after the animation finish.
 
 Use this method to provider a default look before the actual download starts or after it finished.
 @param image The image to use
 @param state The progress state when the image should be used - before or after the animation or during faliure
 */
//- (void)setImage:(UIImage*)image forProgressState:(ProgressState)state;


/**
 @name Manage progress
 */

/**
 Show an unknown progress animation until the first actual progress is reported.
 @see progress
 */
- (void)startUnknownProgress;


/**
 Show an unknown progress animation for a minimum duration or until the first actual progress is reported.
 
 Use this method to make sure the unknown progress animation is shown a minimum amount of time for the user regardless of how fast the first progress is reported.
 
 @param minimumDuration The minimum duration the unknown progress animation should be shown regadless of how fast the first progress is reported
 */
- (void)startUnknownProgressWithMinimumDuration:(NSTimeInterval)minimumDuration;

/**
 Set the progress of the progress view.
 
 The first reported progress value will not be animated. If you like the first reported progress to be animated, make sure you set the progress to 0.0 before the first actual progress value is set.
 */
@property (nonatomic) float progress;


/**
 The completion block will be called when the progress reach 1.0 and the animation finish.
 @param completionBlock The completion block to run
*/
- (void)completionBlock:(void(^)(void))completionBlock;


/**
 The completion block will be called after the provided delay when the progress reach 1.0 and the animation finish.
 
 Use this method to guarantee that the finished progress is shown a minimum amount of time for the user after the progress completed.
 
 @param completionBlock The completion block to run
 @param delay The delay before calling the completion block
 */
- (void)completionBlock:(void(^)(void))completionBlock withDelay:(NSTimeInterval)delay;


/**
 Stop an ongoing progress.
 The next reported progress will restart the progress animation from the paused progress.
 */
- (void)stopProgress;


/**
 Reset all ongoing progress.
 The next reported animation will restart the progress animation from zero progress.
 */
- (void)resetProgress;


@end
