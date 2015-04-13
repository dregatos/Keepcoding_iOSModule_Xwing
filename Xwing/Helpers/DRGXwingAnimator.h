//
//  DRGXwingAnimator.h
//  Xwing
//
//  Created by David Regatos on 11/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface DRGXwingAnimator : NSObject

+ (void)moveXwing:(UIImageView *)xwingView
     onSpaceField:(UIImageView *)spaceFieldView
               to:(CGPoint)destination
        withSpeed:(CGFloat)speed
         rotation:(BOOL)shouldRotate
    andCompletion:(void (^)(BOOL finished))completion;

+ (void)rotateXwing:(UIImageView *)xwingView
       onSpaceField:(UIImageView *)spaceFieldView
       withDuration:(CGFloat)duration
      numberOfLoops:(NSUInteger)loops
      andCompletion:(void (^)(BOOL finished))completion;

+ (void)hyperdriveXwing:(UIImageView *)xwingView
           onSpaceField:(UIImageView *)spaceFieldView
          andCompletion:(void (^)(BOOL finished))completion;

+ (void)randomMoveXwing:(UIImageView *)xwingView
           onSpaceField:(UIImageView *)spaceFieldView
      withDecceleration:(CGFloat)damping
          andCompletion:(void (^)(BOOL finished))completion;

@end
