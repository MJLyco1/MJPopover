//
//  DemoViewController.m
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

#import "DemoViewController.h"
#import "MJPopoverController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController
{
    MJPopoverController *popover;
}

- (IBAction)testBarButtonItemTapped:(UIBarButtonItem *)sender
{
    UINavigationController *navVC = [[UIStoryboard storyboardWithName:@"DemoTable" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    if(IS_IOS_7_OR_GREATER)
    {
        navVC.preferredContentSize = CGSizeMake(200.0, 200.0);
    }
    else
    {
        navVC.contentSizeForViewInPopover = CGSizeMake(200.0, 200.0);
    }

    popover = [[MJPopoverController alloc] initWithContentViewController:navVC];
    [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];

    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"setPopoverContentSize");
        [popover setPopoverContentSize:CGSizeMake(200.0, 100.0) animated:YES];
    });
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
