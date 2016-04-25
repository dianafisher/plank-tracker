//
//  PTButtonView.m
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

#import "PTButtonView.h"

@implementation PTButtonView

- (void)drawRect:(CGRect)rect
{
    // Draw a circle with a UIBezierPath.       
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect: CGRectInset(rect, 5, 5)];
    [self.fillColor setFill];
    [path fill];
    
    path.lineWidth = self.lineWidth;
    
    [self.strokeColor setStroke];
    [path stroke];    
}

@end
