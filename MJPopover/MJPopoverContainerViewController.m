//
//  MJPopoverContainerViewController.m
//  Popover
//
//  Created by Michael Lyons on 8/12/13.
//  Copyright (c) 2013 MJ Lyco LLC (http://mjlyco.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MJPopoverContainerViewController.h"
#import "MJPopoverView.h"

@interface MJPopoverContainerViewController ()

@end

@implementation MJPopoverContainerViewController
{
    CGRect _fromRect;
    __weak UIView *_popoverRectView;
    __weak UIButton *_dimmingButton;
    __weak MJPopoverView *_popoverView;
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    CGRect frame = self.view.bounds;
    UIButton *dimmingButton = [[UIButton alloc] initWithFrame:frame];
    [dimmingButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    dimmingButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    dimmingButton.alpha = (animated) ? 0.0 : 1.0;
    [dimmingButton addTarget:self action:@selector(dimmingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dimmingButton];
    _dimmingButton = dimmingButton;

    _popoverRectView = view;
    _fromRect = rect;

    MJPopoverView *popoverView = [[MJPopoverView alloc] initFromRect:rect inView:view permittedArrowDirections:arrowDirections withPopoverContainerViewController:self];
    popoverView.alpha = (animated) ? 0.0 : 1.0;
    [self.view addSubview:popoverView];
    _popoverView = popoverView;

    if (animated)
    {
        [UIView animateWithDuration:0.08 animations:^{
            popoverView.alpha = 1.0;
            dimmingButton.alpha = 1.0;
        }];
        
        [popoverView animatePopover];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];

    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
        [rootVC addChildViewController:self];
        [self didMoveToParentViewController:rootVC];

        [UIView animateWithDuration:0.3 animations:^{
            [_popoverView calculateGeometryFromRect:_fromRect inView:_popoverRectView];
        }];
    });
}

- (void)dimmingButtonTapped:(UIButton*)dimmingButton
{
    [self.MJPopoverController dismissPopoverAnimated:YES];
}

@end
