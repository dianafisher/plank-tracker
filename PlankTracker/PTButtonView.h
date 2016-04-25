//
//  PTButtonView.h
//  PlankTracker
//
//  Created by Diana Fisher on 4/24/16.
//  Copyright © 2016 Diana Fisher. All rights reserved.
//

@import UIKit;

IB_DESIGNABLE

@interface PTButtonView : UIButton

@property (nonatomic) IBInspectable UIColor *fillColor;
@property (nonatomic) IBInspectable UIColor *strokeColor;
@property (nonatomic) IBInspectable CGFloat lineWidth;

@property (nonatomic, getter=isStartButton) IBInspectable BOOL startButton;

@end
