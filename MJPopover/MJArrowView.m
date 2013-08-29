//
//  MJArrowView.m
//  Popover
//
//  Created by Michael Lyons on 8/13/13.
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

#import "MJArrowView.h"

#define kMJPopoverControlPointSizeBottom 4.0
#define kMJPopoverControlPointSizeTop 3.0

@implementation MJArrowView
{
    UIPopoverArrowDirection _arrowDirection;
}

- (id)initWithFrame:(CGRect)frame andArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    self = [super initWithFrame:frame];
    if (self != nil)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setArrowDirection:arrowDirection];
    }
    return self;
}

- (void)setFrame:(CGRect)frame andArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    [super setFrame:frame];
    [self setArrowDirection:arrowDirection];
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;

    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat midX = CGRectGetMidX(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);

    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat midY = CGRectGetMidY(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);

    UIBezierPath *path = [UIBezierPath bezierPath];

    switch (_arrowDirection)
    {
        case UIPopoverArrowDirectionUp:
        {
            [path moveToPoint:CGPointMake(minX, maxY)];
            [path addLineToPoint:CGPointMake(minX, maxY-kMJPopoverArrowHeightBleedExtra)];
            [path addCurveToPoint:CGPointMake(midX, minY) controlPoint1:CGPointMake(minX, maxY-kMJPopoverArrowHeightBleedExtra-kMJPopoverControlPointSizeBottom) controlPoint2:CGPointMake(midX-kMJPopoverControlPointSizeTop, minY)];
            [path addCurveToPoint:CGPointMake(maxX, maxY-kMJPopoverArrowHeightBleedExtra) controlPoint1:CGPointMake(midX+kMJPopoverControlPointSizeTop, minY) controlPoint2:CGPointMake(maxX, maxY-kMJPopoverArrowHeightBleedExtra-kMJPopoverControlPointSizeBottom)];
            [path addLineToPoint:CGPointMake(maxX, maxY)];
        }
            break;

        case UIPopoverArrowDirectionDown:
        {
            [path moveToPoint:CGPointMake(minX, minY)];
            [path addLineToPoint:CGPointMake(minX, minY+kMJPopoverArrowHeightBleedExtra)];
            [path addCurveToPoint:CGPointMake(midX, maxY) controlPoint1:CGPointMake(minX, minY+kMJPopoverArrowHeightBleedExtra+kMJPopoverControlPointSizeBottom) controlPoint2:CGPointMake(midX-kMJPopoverControlPointSizeTop, maxY)];
            [path addCurveToPoint:CGPointMake(maxX, minY+kMJPopoverArrowHeightBleedExtra) controlPoint1:CGPointMake(midX+kMJPopoverControlPointSizeTop, maxY) controlPoint2:CGPointMake(maxX, minY+kMJPopoverArrowHeightBleedExtra+kMJPopoverControlPointSizeBottom)];
            [path addLineToPoint:CGPointMake(maxX, minY)];
        }
            break;

        case UIPopoverArrowDirectionLeft:
        {
            [path moveToPoint:CGPointMake(maxX, minY)];
            [path addLineToPoint:CGPointMake(maxX-kMJPopoverArrowHeightBleedExtra, minY)];
            [path addCurveToPoint:CGPointMake(minX, midY) controlPoint1:CGPointMake(maxX-kMJPopoverArrowHeightBleedExtra-kMJPopoverControlPointSizeBottom, minY) controlPoint2:CGPointMake(minX, midY-kMJPopoverControlPointSizeTop)];
            [path addCurveToPoint:CGPointMake(maxX-kMJPopoverArrowHeightBleedExtra, maxY) controlPoint1:CGPointMake(minX, midY+kMJPopoverControlPointSizeTop) controlPoint2:CGPointMake(maxX-kMJPopoverArrowHeightBleedExtra-kMJPopoverControlPointSizeBottom, maxY)];
            [path addLineToPoint:CGPointMake(maxX, maxY)];
        }
            break;

        case UIPopoverArrowDirectionRight:
        {
            [path moveToPoint:CGPointMake(minX, minY)];
            [path addLineToPoint:CGPointMake(minX+kMJPopoverArrowHeightBleedExtra, minY)];
            [path addCurveToPoint:CGPointMake(maxX, midY) controlPoint1:CGPointMake(minX+kMJPopoverArrowHeightBleedExtra+kMJPopoverControlPointSizeBottom, minY) controlPoint2:CGPointMake(maxX, midY-kMJPopoverControlPointSizeTop)];
            [path addCurveToPoint:CGPointMake(minX+kMJPopoverArrowHeightBleedExtra, maxY) controlPoint1:CGPointMake(maxX, midY+kMJPopoverControlPointSizeTop) controlPoint2:CGPointMake(minX+kMJPopoverArrowHeightBleedExtra+kMJPopoverControlPointSizeBottom, maxY)];
            [path addLineToPoint:CGPointMake(minX, maxY)];
        }
            break;

        default:
            break;
    }

    CAShapeLayer *shapeLayer = (CAShapeLayer*)self.layer;
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [[UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1.0] CGColor];
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

@end
