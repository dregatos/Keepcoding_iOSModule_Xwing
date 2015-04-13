//
//  DRGMainVC.m
//  Xwing
//
//  Created by David Regatos on 06/04/15.
//  Copyright (c) 2015 DRG. All rights reserved.
//

#import "DRGMainVC.h"
#import "DRGXwingAnimator.h"
#import "Utils.h"

/** Contants */
CGFloat const speed = 330.;  // point/s

@implementation DRGMainVC

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupGestureRecognizers];
}

#pragma mark - Setup

- (void)setupGestureRecognizers {
    [self setupTapRecognizers];
    [self setupSwipeRecognizers];
}

- (void)setupTapRecognizers {
    // Add single tap detector
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tap];
    
    // Add double tap detector
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    // Add triple tap detector
    UITapGestureRecognizer *tripleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    tripleTap.numberOfTapsRequired = 3;
    [self.view addGestureRecognizer:tripleTap];
    
    // Multiple taps detection (detection rules).
    [tap requireGestureRecognizerToFail:doubleTap];
    [tap requireGestureRecognizerToFail:tripleTap];
    [doubleTap requireGestureRecognizerToFail:tripleTap];
}

- (void)setupSwipeRecognizers {
    // Add swipe detectors
    // NOTE: We have to define direction individually if we need to know the direction of the swipe...
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
}

#pragma  mark - Gesture recognizer methods

/** Translation&Rotation animations */
- (void)didTap:(UITapGestureRecognizer *)tap {
    switch (tap.state) {
        case UIGestureRecognizerStateRecognized: {
            
            if (tap.numberOfTapsRequired == 1) {
                [self moveXwing:tap withRotation:NO];
            } else if (tap.numberOfTapsRequired == 2) {
                [self moveXwing:tap withRotation:YES];
            } else if (tap.numberOfTapsRequired == 3) {
                [self spinXwing:tap];
            }

            break;
        }
            
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        default:
            break;
    }
}

- (void)didSwipe:(UISwipeGestureRecognizer *)swipe {
    switch (swipe.state) {
        case UIGestureRecognizerStateRecognized: {
            
            if (swipe.direction == UISwipeGestureRecognizerDirectionUp |
                swipe.direction == UISwipeGestureRecognizerDirectionDown) {
                // Hyperdrive
                [self hyperdriveXwing];

            } else if (swipe.direction == UISwipeGestureRecognizerDirectionRight |
                       swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
                //damping
                [self deccelerateXwing];
            }
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
            break;
            
        case UIGestureRecognizerStateFailed:
            break;
            
        default:
            break;
    }
}

#pragma mark - Helpers

- (void)moveXwing:(UITapGestureRecognizer *)tap withRotation:(BOOL)shouldRotate {
    
    CGPoint destination = [tap locationInView:self.spaceFieldView];
    NSLog(@"Destination point: %@", NSStringFromCGPoint(destination));
    
    // Animation ***
    [DRGXwingAnimator moveXwing:self.xwingView
                   onSpaceField:self.spaceFieldView
                             to:destination
                      withSpeed:speed
                       rotation:shouldRotate
                  andCompletion:^(BOOL finished) {
                      NSLog(@"Translation with rotation did finish");
                  }];
}

- (void)spinXwing:(UITapGestureRecognizer *)tap {
    
    NSLog(@"Xwing position: %@", NSStringFromCGPoint(self.xwingView.center));
    
    // Animation ***
    [DRGXwingAnimator rotateXwing:self.xwingView
                     onSpaceField:self.spaceFieldView
                     withDuration:2.
                    numberOfLoops:10
                    andCompletion:^(BOOL finished) {
                        NSLog(@"Spinning did finish");
                    }];
}

- (void)hyperdriveXwing {
    [DRGXwingAnimator hyperdriveXwing:self.xwingView
                         onSpaceField:self.spaceFieldView
                        andCompletion:^(BOOL finished) {
                            NSLog(@"Hyperdrive did finish");
                        }];
}

- (void)deccelerateXwing {
    [DRGXwingAnimator randomMoveXwing:self.xwingView
                         onSpaceField:self.spaceFieldView
                    withDecceleration:0.8
                        andCompletion:^(BOOL finished) {
                            NSLog(@"Decceleration did finish");
                        }];
}

#pragma mark - IBActions

- (IBAction)infoBtnPressed:(UIButton *)sender {
    
    NSString *message = @"* Single tap: translation+scale\n* Double tap: 'single tap'+rotation\nTriple tap: spinning\n* Swipe up/down: hyperdrive\n*Swipe left/right: move with damping";
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
