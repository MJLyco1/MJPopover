//
//  MJPopoverController.m
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

#import "MJPopoverController.h"
#import "MJPopoverContainerViewController.h"

@interface NSObject (UIPopoverController)

- (id)initWithContentViewController:(UIViewController *)viewController;
- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

@end

#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)

@implementation MJPopoverController
{
    BOOL _popoverVisible;
    UIPopoverArrowDirection _popoverArrowDirection;
    __weak MJPopoverContainerViewController *_containerViewController;
}

+ (id)alloc
{
    if (IS_IPAD)
    {
        id memory = [UIPopoverController alloc];
        return memory;
    }

    return [super alloc];
}

- (id)initWithContentViewController:(UIViewController *)viewController
{
    if (IS_IPAD)
    {
        self = [super initWithContentViewController:viewController];
        if (self != nil)
        {
        }
        return self;
    }

    self = [super init];
	if (self != nil)
    {
		self.contentViewController = viewController;
	}
	return self;
}

- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (IS_IPAD)
    {
        [super setContentViewController:viewController animated:animated];
    }
    else
    {
        if (self.contentViewController != viewController)
        {
            self.contentViewController = viewController;

            if (_containerViewController != nil)
            {
#warning TODO : This might need to change to actually change the viewController dynamically
                if (animated)
                {
                    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        [_containerViewController contentDidChange];
                    } completion:nil];
                }
                else
                {
                    [_containerViewController contentDidChange];
                }
            }
        }
    }
}

- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated
{
    if (IS_IPAD)
    {
        [super setPopoverContentSize:size animated:animated];
    }
    else
    {
        self.popoverContentSize = size;
        if (_containerViewController)
        {
            if (animated)
            {
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    [_containerViewController contentDidChange];
                } completion:nil];
            }
            else
            {
                [_containerViewController contentDidChange];
            }
        }
    }
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if (IS_IPAD)
    {
        [super presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
    }
    else
    {
        [self dismissPopoverAnimated:NO];

        //First force a load view for the contentViewController so the popoverContentSize is properly initialized
        [self.contentViewController view];
        UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;

        if (CGSizeEqualToSize(self.popoverContentSize, CGSizeZero))
        {
            self.popoverContentSize = (IS_IOS_7_OR_GREATER) ? self.contentViewController.preferredContentSize : self.contentViewController.contentSizeForViewInPopover;
            if (CGSizeEqualToSize(self.popoverContentSize, CGSizeZero))
            {
                self.popoverContentSize = CGSizeMake(200.0, 300.0);
            }

            if (self.popoverContentSize.width < 100)
            {
                self.popoverContentSize = CGSizeMake(100.0, self.popoverContentSize.height);
            }
            else if (self.popoverContentSize.width > 300)
            {
                self.popoverContentSize = CGSizeMake(300.0, self.popoverContentSize.height);
            }
        }


        MJPopoverContainerViewController *containerVC = [[MJPopoverContainerViewController alloc] init];
        containerVC.MJPopoverController = self;

        [rootVC addChildViewController:containerVC];
        [rootVC.view addSubview:containerVC.view];
        [containerVC didMoveToParentViewController:rootVC];
        
        [containerVC presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];
        
        _containerViewController = containerVC;
    }
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    if (IS_IPAD)
    {
        [super presentPopoverFromBarButtonItem:item permittedArrowDirections:arrowDirections animated:animated];
    }
    else
    {
        CGRect rect = CGRectZero;

        UIView *barButtonView = item.customView;
        if (!barButtonView && [item respondsToSelector:@selector(view)])
        {
            barButtonView = [item performSelector:@selector(view)];
        }

        UIView *parentView = barButtonView.superview;
        NSArray *subviews = parentView.subviews;

        NSUInteger indexOfView = [subviews indexOfObject:barButtonView];
        NSUInteger subviewCount = subviews.count;

        if (subviewCount > 0 && indexOfView != NSNotFound)
        {
            UIView *button = [parentView.subviews objectAtIndex:indexOfView];
            rect = button.frame;
        }
        
        [self presentPopoverFromRect:rect inView:parentView permittedArrowDirections:arrowDirections animated:animated];
    }
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    if (IS_IPAD)
    {
        [super dismissPopoverAnimated:animated];
    }
    else
    {
        [_containerViewController.view removeFromSuperview];
        [_containerViewController willMoveToParentViewController:nil];
        [_containerViewController removeFromParentViewController];
    }
}

@end
