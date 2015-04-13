//
//  DRGXwingAnimator.m
//  Xwing
//
//  Created by David Regatos on 11/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGXwingAnimator.h"
#import "Utils.h"

int const borderOffset = 30;

@implementation DRGXwingAnimator

#pragma mark - Animations

+ (void)moveXwing:(UIImageView *)xwingView
     onSpaceField:(UIImageView *)spaceFieldView
               to:(CGPoint)destination
        withSpeed:(CGFloat)speed
         rotation:(BOOL)shouldRotate
    andCompletion:(void (^)(BOOL finished))completion {
    
    // Determine animation duration
    CGFloat duration = [self distanceBetweenPointA:xwingView.center andB:destination]/speed;
    
    // Determine animation transformation
    CGFloat scaleFactor = 1+(destination.y/spaceFieldView.bounds.size.height);
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    CGAffineTransform transformation;
    if (shouldRotate) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation(degreesToRadians(arc4random()%360));
        transformation = CGAffineTransformConcat(scale, rotation);
    } else {
        transformation = scale;
    }
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:duration
                          delay:0
                        options:options
                     animations:^{
                         
                         // Final state
                         xwingView.center = destination;
                         xwingView.transform = transformation;
                         
                     } completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

+ (void)rotateXwing:(UIImageView *)xwingView
       onSpaceField:(UIImageView *)spaceFieldView
       withDuration:(CGFloat)duration
      numberOfLoops:(NSUInteger)loops
      andCompletion:(void (^)(BOOL finished))completion {
    
    CGFloat loopDuration = duration/loops;
    
    CGFloat scaleFactor = 1+(xwingView.center.y/spaceFieldView.bounds.size.height);
    CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
    
    CGFloat radians = atan2f(xwingView.transform.b, xwingView.transform.a);
    CGFloat degrees = radians * (180 / M_PI);
    CGFloat currentAngle = degrees;
    
    // Loop
    CGAffineTransform rotation = CGAffineTransformMakeRotation(degreesToRadians(currentAngle+180));
    [UIView animateWithDuration:loopDuration/2
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         
                         [UIView setAnimationRepeatCount:loops];
                         
                         xwingView.transform = CGAffineTransformConcat(scale, rotation);
                         
                     } completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

+ (void)hyperdriveXwing:(UIImageView *)xwingView
           onSpaceField:(UIImageView *)spaceFieldView
          andCompletion:(void (^)(BOOL finished))completion {
    
    // Jumping from top to bottom (and viceversa)
    CGFloat duration = 0.4;
    CGPoint destination = [DRGXwingAnimator destinationPointForXwingView:xwingView onSpaceField:spaceFieldView];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         xwingView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         xwingView.center = destination;
                     }];
    
    [UIView animateWithDuration:duration/2
                          delay:1.+duration
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [UIView setAnimationRepeatCount:5];
                         xwingView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

+ (void)randomMoveXwing:(UIImageView *)xwingView
           onSpaceField:(UIImageView *)spaceFieldView
      withDecceleration:(CGFloat)damping
          andCompletion:(void (^)(BOOL finished))completion {
    
    // Jumping from top to bottom (and viceversa)
    CGFloat speed = 200.; //point/s
    CGPoint destination = [DRGXwingAnimator destinationPointForXwingView:xwingView onSpaceField:spaceFieldView];
    CGFloat duration = [self distanceBetweenPointA:xwingView.center andB:destination]/speed;

    [UIView animateWithDuration:duration
                          delay:0
         usingSpringWithDamping:damping
          initialSpringVelocity:0.8
                        options:0
                     animations:^{
                         xwingView.center = destination;
                     } completion:^(BOOL finished) {
                         completion(finished);
                     }];
}

#pragma mark - Helpers

+ (CGFloat)distanceBetweenPointA:(CGPoint)pointA andB:(CGPoint)pointB {
    
    CGPoint translation = CGPointMake(pointB.x - pointA.x, pointB.y - pointA.y);
    CGFloat distance = hypotf(translation.x, translation.y);
    
    return distance;
}

/** Returns a point belongs to the top region ((0+borderOffset)-30%) OR to the bottom region (70-(100-offsetBorder)%) */
+ (CGPoint)destinationPointForXwingView:(UIImageView *)xwingView
                           onSpaceField:(UIImageView *)spaceFieldView {
    
    NSLog(@"Xwing position: %@", NSStringFromCGPoint(xwingView.center));
    
    int spaceWidth = (int)spaceFieldView.bounds.size.width;
    int spaceHeight = (int)spaceFieldView.bounds.size.height;
    
    int xmin = borderOffset;
    int xmax = spaceWidth-borderOffset;
    
    int ymin = (xwingView.frame.origin.y <= spaceHeight/2) ? 0.7*spaceHeight : borderOffset;
    int ymax = (ymin == borderOffset) ? 0.3*spaceHeight : spaceHeight-borderOffset;
    
    CGPoint destination = CGPointMake((arc4random() % (xmax-xmin)) + xmin,
                                      (arc4random() % (ymax-ymin)) + ymin);
    NSLog(@"Xwing destination: %@", NSStringFromCGPoint(destination));
    
    return destination;
}


@end
