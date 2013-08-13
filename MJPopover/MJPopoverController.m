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

@implementation MJPopoverController
{
    BOOL _popoverVisible;
    UIPopoverArrowDirection _popoverArrowDirection;

    __weak MJPopoverContainerViewController *_containerViewController;
}

- (id)initWithContentViewController:(UIViewController *)viewController
{
    self = [super init];
	if (self != nil)
    {
		self.contentViewController = viewController;
	}
	return self;
}

- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.contentViewController = viewController;
#warning animated...
}

- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated
{
    self.popoverContentSize = size;
#warning animated...
}

- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    [self dismissPopoverAnimated:NO];

	//First force a load view for the contentViewController so the popoverContentSize is properly initialized
	[self.contentViewController view];

	if (CGSizeEqualToSize(self.popoverContentSize, CGSizeZero))
    {
		self.popoverContentSize = self.contentViewController.preferredContentSize;
        if (CGSizeEqualToSize(self.popoverContentSize, CGSizeZero))
        {
            self.popoverContentSize = CGSizeMake(200.0, 300.0);
        }
        else if (self.popoverContentSize.width < 100)
        {
            self.popoverContentSize = CGSizeMake(100.0, self.popoverContentSize.height);
        }
        else if (self.popoverContentSize.width > 300)
        {
            self.popoverContentSize = CGSizeMake(300.0, self.popoverContentSize.height);
        }
	}

    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;

    MJPopoverContainerViewController *containerVC = [[MJPopoverContainerViewController alloc] init];
    containerVC.MJPopoverController = self;

    [rootVC addChildViewController:containerVC];
    [rootVC.view addSubview:containerVC.view];
    [containerVC didMoveToParentViewController:rootVC];

    [containerVC presentPopoverFromRect:rect inView:view permittedArrowDirections:arrowDirections animated:animated];

    _containerViewController = containerVC;
}

- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
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

- (void)dismissPopoverAnimated:(BOOL)animated
{
    [_containerViewController.view removeFromSuperview];
    [_containerViewController willMoveToParentViewController:nil];
    [_containerViewController removeFromParentViewController];
}

@end
