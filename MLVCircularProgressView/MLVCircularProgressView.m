//
//  MLVCircularProgressView.m
//  MLVCircularProgressView
//
//  Created by Mattias Levin on 27/10/13.
//  Copyright (c) 2013 Mattias Levin. All rights reserved.
//

#import "MLVCircularProgressView.h"


@interface MLVCircularProgressView ()

@property (nonatomic, strong) CAShapeLayer *progressUnknownLayer;
@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic) NSDate *minimumUnknownProgress;

@property (nonatomic) NSDate *previousReportedProgressTime;
@property (nonatomic) BOOL isFirstProgess;

@property (nonatomic, copy) void (^completionBlock)(void);
@property (nonatomic) NSTimeInterval delay;

@property (nonatomic) NSUInteger numberOfUsedAnimations; // Debug purpose

@end


static  NSString * const ProgressUnknownAnimationKey = @"ProgressUnkownAnimationKey";
static  NSString * const ProgressAnimationKey = @"ProgressAnimationKey";


@implementation MLVCircularProgressView


- (id)initWithCoder:(NSCoder *)aDecoder {
  
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonInit];
  }
  return self;
  
}


- (id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
  
}


- (void)commonInit {
  _minimumProgressChangeToTriggerAnimation = 0.1;
  _shapeColor = [UIColor blueColor];
  
  __weak typeof(self)weakSelf = self;
  
  _animationDuration = ^ (float progress, float increaseSinceLastProgress, NSTimeInterval durationSinceLastProgress, float *animatedProgress) {
    
    float bestGuessNextProgress;
    CFTimeInterval animationDuration;
    if (weakSelf.isFirstProgess) {
      bestGuessNextProgress = progress + weakSelf.minimumProgressChangeToTriggerAnimation;
      animationDuration = weakSelf.minimumProgressChangeToTriggerAnimation / (increaseSinceLastProgress / durationSinceLastProgress);
    } else {
      bestGuessNextProgress = progress + increaseSinceLastProgress;
      animationDuration = durationSinceLastProgress;
    }
    
    if (bestGuessNextProgress > 1.0) {
      bestGuessNextProgress = 1.0;
    }
    
    *animatedProgress = bestGuessNextProgress;
    return animationDuration;
    
  };
  
  [self.layer addSublayer:self.progressBackgroundLayer];
  
}


- (void)startUnknownProgress {
  [self startUnknownProgressWithMinimumDuration:0.0];
}


- (void)startUnknownProgressWithMinimumDuration:(NSTimeInterval)minimumDuration {
  
  if (minimumDuration > 0.0) {
    self.minimumUnknownProgress = [NSDate dateWithTimeIntervalSinceNow:minimumDuration];
  }

  [self.progressBackgroundLayer removeFromSuperlayer];
  [self.layer addSublayer:self.progressUnknownLayer];
  [self startUnknownProgessAnimation];
}


- (void)setProgress:(float)progress {
  NSLog(@"Set progress %f", progress);
  
  if ([self.minimumUnknownProgress compare:[NSDate date]] == NSOrderedDescending) {
    // Keep showing the unknown progress animation
    
    _progress = progress;
    self.isFirstProgess = YES;
    self.previousReportedProgressTime = [NSDate date];
  
  } else if (progress == _progress) {
    
    [self progress:_progress withAnimationDuration:-1.0];
    
  } else if (!self.previousReportedProgressTime) {
    // First reported progress
    // Set reported values without any animation
    
    _progress = progress;
    self.isFirstProgess = YES;
    self.previousReportedProgressTime = [NSDate date];
    
    [self progress:_progress withAnimationDuration:-1.0];
    
  } else if (progress >= 1.0) {
    // Progress finished
    
    _progress = 1.0;
    [self progress:_progress withAnimationDuration:0.2];
    
  } else if ((progress - _progress >= self.minimumProgressChangeToTriggerAnimation) || self.isFirstProgess) {
    // Show progress with animation
    
    float increaseSinceLastProgress = progress - _progress;
    _progress = progress;
    
    NSTimeInterval durationSinceLastProgress = fabs([self.previousReportedProgressTime timeIntervalSinceNow]);
    self.previousReportedProgressTime = [NSDate date];
    
    float animatedProgress = progress;
    NSTimeInterval animationDuration = self.animationDuration(progress, increaseSinceLastProgress, durationSinceLastProgress, &animatedProgress);
    NSLog(@"Animated progress %f, duration %f", animatedProgress, animationDuration);
    
    self.isFirstProgess = NO;
    
    [self progress:animatedProgress withAnimationDuration:animationDuration];
    
  }
  
}


- (void)completionBlock:(void(^)(void))completionBlock {
  [self completionBlock:completionBlock withDelay:0.0];
}


- (void)completionBlock:(void(^)(void))completionBlock withDelay:(NSTimeInterval)delay {
  self.completionBlock = completionBlock;
  self.delay = delay;
}


- (void)stopProgress {
  [self.layer removeAllAnimations];
}


- (void)resetProgress {
  
  [self stopProgress];
  
  self.progress = 0.0;
  self.previousReportedProgressTime = nil;
  self.numberOfUsedAnimations = 0.0;
  
  [self.progressUnknownLayer removeFromSuperlayer];
  [self.progressLayer removeFromSuperlayer];
  self.progressLayer = nil;
  
}


#pragma mark - Unknown progress layer animation

- (void)startUnknownProgessAnimation {
  
  CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  rotationAnimation.fromValue = @(0.0);
  rotationAnimation.toValue = @(M_PI * 2.0);
  rotationAnimation.duration = 1.0;
  rotationAnimation.repeatCount = INFINITY;
  rotationAnimation.cumulative = YES;
  
  [self.progressUnknownLayer addAnimation:rotationAnimation forKey:ProgressUnknownAnimationKey];
  
}


- (void)stopUnknownProgressAnimation {
  [self.progressUnknownLayer removeAnimationForKey:ProgressUnknownAnimationKey];
}


#pragma mark - Progress layer animation

- (void)progress:(float)progress withAnimationDuration:(CFTimeInterval)animationDuration {
  //  NSLog(@"Progress: %f, duration %f", progress, animationDuration);
  
  CAShapeLayer *presentationLayer = (CAShapeLayer*)self.progressLayer.presentationLayer;
  float animatedProgress = presentationLayer.strokeEnd;
  if (animatedProgress > progress) {
    // Do nothing
    return;
  }
  
  if (!self.progressLayer.superlayer) {
    [self.progressUnknownLayer removeFromSuperlayer];
    [self.layer addSublayer:self.progressBackgroundLayer];
    [self.layer addSublayer:self.progressLayer];
  }
  
  if (animationDuration > 0.0) {
    
    [CATransaction begin];
    
    if (self.progress == 1.0) {
      [CATransaction setCompletionBlock:^{
        if (self.progress == 1.0) {
          [self runCompletionBlockWithDelay];
        }
      }];
      
      NSLog(@"Used %lu animations in total", (unsigned long)self.numberOfUsedAnimations);

    }
    
    [CATransaction setAnimationDuration:animationDuration];
    
    CABasicAnimation *progressAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    progressAnimation.fromValue = @(animatedProgress);
    progressAnimation.toValue = @(progress);
    progressAnimation.fillMode = kCAFillModeForwards;
    progressAnimation.removedOnCompletion = NO;
    [self.progressLayer addAnimation:progressAnimation forKey:ProgressAnimationKey];
    
    [CATransaction commit];
    
    self.numberOfUsedAnimations += 1;
    
  } else {
    
    self.progressLayer.strokeEnd = progress;
    
    if (self.progress == 1.0) {
      [self runCompletionBlockWithDelay];
    }
    
  }
  
}


- (void)runCompletionBlockWithDelay {
  
  if (self.completionBlock && self.delay > 0.0) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      self.completionBlock();
    });
  } else if (self.completionBlock){
    self.completionBlock();
  }
  
}


#pragma mark - Properties

- (void)setShapeColor:(UIColor *)color {
  _shapeColor = color;
  
  self.progressUnknownLayer.strokeColor = _shapeColor.CGColor;
  self.progressBackgroundLayer.strokeColor = _shapeColor.CGColor;
  self.progressLayer.strokeColor = _shapeColor.CGColor;
  
}


- (CAShapeLayer*)progressUnknownLayer {
  if (!_progressUnknownLayer) {
    _progressUnknownLayer = [CAShapeLayer layer];
    _progressUnknownLayer.frame = self.bounds;
    _progressUnknownLayer.backgroundColor = nil;
    _progressUnknownLayer.fillColor = nil;
    _progressUnknownLayer.strokeColor = _shapeColor.CGColor;
    _progressUnknownLayer.lineWidth = 1.0;
    CGRect bounds = CGRectInset(self.bounds, 1.0, 1.0);
    CGFloat radius = floorf((MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds))) / 2.0);
    CGPoint center = CGPointMake(floorf(CGRectGetMidX(bounds)), floorf(CGRectGetMidY(bounds)));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:(2.0 * M_PI - M_PI_2 - 0.5)
                                                     clockwise:YES];
    _progressUnknownLayer.path = path.CGPath;
  }

  return _progressUnknownLayer;
}


- (CAShapeLayer*)progressBackgroundLayer {
  if (!_progressBackgroundLayer) {
    _progressBackgroundLayer = [CAShapeLayer layer];
    _progressBackgroundLayer.frame = self.bounds;
    _progressBackgroundLayer.backgroundColor = nil;
    _progressBackgroundLayer.fillColor = nil;
    _progressBackgroundLayer.strokeColor = _shapeColor.CGColor;
    _progressBackgroundLayer.lineWidth = 1.0;
    CGRect bounds = CGRectInset(self.bounds, 1.0, 1.0);
    CGFloat radius = floorf((MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds))) / 2.0);
    CGPoint center = CGPointMake(floorf(CGRectGetMidX(bounds)), floorf(CGRectGetMidY(bounds)));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:(2.0 * M_PI - M_PI_2)
                                                     clockwise:YES];
    _progressBackgroundLayer.path = path.CGPath;
    CAShapeLayer *squareBackgrounfLayer = [CAShapeLayer layer];
    squareBackgrounfLayer.frame = self.bounds;
    squareBackgrounfLayer.backgroundColor = nil;
    squareBackgrounfLayer.fillColor = _shapeColor.CGColor;
    CGFloat squareSize = floorf(MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) * 0.2);
    path = [UIBezierPath bezierPathWithRect:CGRectInset(bounds, CGRectGetMidX(bounds) - squareSize, CGRectGetMidY(bounds) - squareSize)];
    squareBackgrounfLayer.path = path.CGPath;
    [_progressBackgroundLayer addSublayer:squareBackgrounfLayer];

  }
  
  return _progressBackgroundLayer;
}


- (CAShapeLayer*)progressLayer {
  if (!_progressLayer) {
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.backgroundColor = nil;
    _progressLayer.fillColor = nil;
    _progressLayer.strokeColor = _shapeColor.CGColor;
    CGRect bounds = CGRectInset(self.bounds, 1.0, 1.0);
    _progressLayer.lineWidth = floorf(MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 10.0) + 0.5;
    CGFloat radius = floorf((MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds))) / 2.0) - _progressLayer.lineWidth / 2.0;
    CGPoint center = CGPointMake(floorf(CGRectGetMidX(bounds)), floorf(CGRectGetMidY(bounds)));
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:-M_PI_2
                                                      endAngle:(2.0 * M_PI - M_PI_2)
                                                     clockwise:YES];
    _progressLayer.path = path.CGPath;
  }
  
  return _progressLayer;
}


@end
