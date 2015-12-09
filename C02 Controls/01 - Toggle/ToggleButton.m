//
//  ToggleButton.m
//  Hello World
//
//  Created by David Duan on 12/8/15.
//  Copyright © 2015 Erica Sadun. All rights reserved.
//

#import "ToggleButton.h"

#define CAPWIDTH 110.0f
#define INSETS (UIEdgeInsets){0.0f, CAPWIDTH, 0.0f, CAPWIDTH}
#define BASEGREEN [[UIImage imageNamed:@"green-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHEDGREEN [[UIImage imageNamed:@"green-in.png"] resizableImageWithCapInsets:INSETS]
#define BASERED [[UIImage imageNamed:@"red-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHEDRED [[UIImage imageNamed:@"red-in.png"] resizableImageWithCapInsets:INSETS]

@implementation ToggleButton

- (void)toggleButton:(UIButton *)aButton
{
    
}

+ (instancetype)button
{
    ToggleButton *button = [ToggleButton buttonWithType:UIButtonTypeCustom];
    
    return button;
}

@end
