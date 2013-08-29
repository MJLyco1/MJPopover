//
//  MJPopoverController.h
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

#import <UIKit/UIKit.h>

@class MJPopoverController;

@protocol MJPopoverControllerDelegate <NSObject>
@optional

/* Called on the delegate when the popover controller will dismiss the popover. Return NO to prevent the dismissal of the view.
 */
- (BOOL)popoverControllerShouldDismissPopover:(MJPopoverController *)popoverController;

/* Called on the delegate when the user has taken action to dismiss the popover. This is not called when -dismissPopoverAnimated: is called directly.
 */
- (void)popoverControllerDidDismissPopover:(MJPopoverController *)popoverController;

/* -popoverController:willRepositionPopoverToRect:inView: is called on your delegate when the popover may require a different view or rectangle
 */
- (void)popoverController:(MJPopoverController *)popoverController willRepositionPopoverToRect:(inout CGRect *)rect inView:(inout UIView **)view NS_AVAILABLE_IOS(7_0);

@end

@interface MJPopoverController :  NSObject <UIAppearanceContainer>

/* The view controller provided becomes the content view controller for the UIPopoverController. This is the designated initializer for UIPopoverController.
 */
- (id)initWithContentViewController:(UIViewController *)viewController;

@property (nonatomic, assign) id <MJPopoverControllerDelegate> delegate;

/* The content view controller is the `UIViewController` instance in charge of the content view of the displayed popover. This property can be changed while the popover is displayed to allow different view controllers in the same popover session.
 */
@property (nonatomic, retain) UIViewController *contentViewController;
- (void)setContentViewController:(UIViewController *)viewController animated:(BOOL)animated;

/* This property allows direction manipulation of the content size of the popover. Changing the property directly is equivalent to animated=YES. The content size is limited to a minimum width of 100 and a maximum width of 300.
 */
@property (nonatomic) CGSize popoverContentSize;
- (void)setPopoverContentSize:(CGSize)size animated:(BOOL)animated;

/* Returns whether the popover is visible (presented) or not.
 */
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;

/* Returns the direction the arrow is pointing on a presented popover. Before presentation, this returns UIPopoverArrowDirectionUnknown.
 */
@property (nonatomic, readonly) UIPopoverArrowDirection popoverArrowDirection;

/* By default, a popover disallows interaction with any view outside of the popover while the popover is presented. This property allows the specification of an array of UIView instances which the user is allowed to interact with while the popover is up.
 */
@property (nonatomic, copy) NSArray *passthroughViews;

/* -presentPopoverFromRect:inView:permittedArrowDirections:animated: allows you to present a popover from a rect in a particular view. `arrowDirections` is a bitfield which specifies what arrow directions are allowed when laying out the popover; for most uses, `UIPopoverArrowDirectionAny` is sufficient.
 */
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/* Like the above, but is a convenience for presentation from a `UIBarButtonItem` instance. arrowDirection limited to UIPopoverArrowDirectionUp/Down
 */
- (void)presentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;

/* Called to dismiss the popover programmatically. The delegate methods for "should" and "did" dismiss are not called when the popover is dismissed in this way.
 */
- (void)dismissPopoverAnimated:(BOOL)animated;

/* Set popover background color. Set to nil to use default background color. Default is nil. Color change animated if popover visible.
 */
@property (nonatomic, copy) UIColor *backgroundColor NS_AVAILABLE_IOS(7_0);

/* Clients may wish to change the available area for popover display. The default implementation of this method always returns insets which define 10 points from the edges of the display, and presentation of popovers always accounts for the status bar. The rectangle being inset is always expressed in terms of the current device orientation; (0, 0) is always in the upper-left of the device. This may require insets to change on device rotation.
 */
@property (nonatomic, readwrite) UIEdgeInsets popoverLayoutMargins NS_AVAILABLE_IOS(5_0);

/* Clients may customize the popover background chrome by providing a class which subclasses `UIPopoverBackgroundView` and which implements the required instance and class methods on that class.
 */
@property (nonatomic, readwrite, retain) Class popoverBackgroundViewClass NS_AVAILABLE_IOS(5_0);

@end
