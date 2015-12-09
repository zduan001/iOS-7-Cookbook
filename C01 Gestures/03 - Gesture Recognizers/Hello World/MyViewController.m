//
//  MyViewController.m
//  Hello World
//
//  Created by David Duan on 12/5/15.
//  Copyright © 2015 Erica Sadun. All rights reserved.
//
@import UIKit;
#import "MyViewController.h"
#import "UIView-Transform.h"


@interface FlowerView : UIImageView
@end

@interface FlowerView() <UIGestureRecognizerDelegate>
@end;

@implementation FlowerView
{
    CGPoint startLocation;
    CGFloat tx;
    CGFloat ty;
    CGFloat scale;
    CGFloat theta;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
    self = [super initWithImage:anImage];
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.transform = CGAffineTransformIdentity;
        tx = 0.0f;
        ty = 0.0f;
        scale = 0.0f;
        theta = 0.0f;
        
        UIRotationGestureRecognizer *rot =
        [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                     action:@selector(handleRotation:)];
        UIPinchGestureRecognizer *pin =
        [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handlePinch:)];
        UIPanGestureRecognizer *pan =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePan:)];
        self.gestureRecognizers = @[rot, pin, pan];
        for (UIGestureRecognizer *recogizerin in self.gestureRecognizers) {
            recogizerin.delegate = self;
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event
{
    
    [self.superview bringSubviewToFront:self];
    
    tx = self.transform.tx;
    ty = self.transform.ty;
    scale = self.scaleX;
    theta = self.rotation;
}

- (void)touchEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (touch.tapCount ==2) {
        self.transform = CGAffineTransformIdentity;
        tx = 0.0f;
        ty = 0.0f;
        scale = 0.0f;
        theta = 0.0f;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchEnded:touches withEvent:event];
}

- (void)updateTransformWithOffset:(CGPoint)translation
{
    self.transform = CGAffineTransformMakeTranslation(translation.x + tx, translation.y + ty);
    self.transform = CGAffineTransformRotate(self.transform, theta);
    
    if (scale > 0.5f) {
        self.transform = CGAffineTransformScale(self.transform, scale, scale);
    } else {
        self.transform = CGAffineTransformScale(self.transform, 0.5f, 0.5f);
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:self.superview];
    [self updateTransformWithOffset:translation];
}

- (void)handleRotation:(UIRotationGestureRecognizer *)gestureRecognizer
{
    theta = gestureRecognizer.rotation;
    [self updateTransformWithOffset:CGPointZero];
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gestureRecognizer
{
    scale = gestureRecognizer.scale;
    [self updateTransformWithOffset:CGPointZero];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
    // Calculate offset
    CGPoint pt = [[touches anyObject] locationInView:self];
    float dx = pt.x - startLocation.x;
    float dy = pt.y - startLocation.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    // Set new location
    self.center = newcenter;
}

@end


@implementation MyViewController
- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor brownColor];
    
    // Provide a "Randomize" button
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Randomize"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(layoutFlowers)];
    
    NSUInteger maxFlowers = 12; // number of flowers to add
    NSArray *flowerArray = @[@"blueFlower.png", @"pinkFlower.png", @"orangeFlower.png"];
    
    // Add the flowers
    for (NSUInteger i = 0; i < maxFlowers; i++)
    {
        NSString *whichFlower = [flowerArray objectAtIndex:(random() % flowerArray.count)];
        FlowerView *flowerDragger = [[FlowerView alloc] initWithImage:[UIImage imageNamed:whichFlower]];
        [self.view addSubview:flowerDragger];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutFlowers];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Check for any off-screen flowers and move them into place
    
    CGFloat halfFlower = 32.0f;
    CGRect targetRect = CGRectInset(self.view.bounds, halfFlower * 2, halfFlower * 2);
    targetRect = CGRectOffset(targetRect, halfFlower, halfFlower);
    
    for (UIView *flowerDragger in self.view.subviews)
    {
        if (!CGRectContainsPoint(targetRect, flowerDragger.center))
        {
            [UIView animateWithDuration:0.3f animations:
             ^(){flowerDragger.center = [self randomFlowerPosition];}];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (CGPoint)randomFlowerPosition
{
    CGFloat halfFlower = 32.0f; // half of the size of the flower
    
    // The flower must be placed fully within the view. Inset accordingly
    CGSize insetSize = CGRectInset(self.view.bounds, 2*halfFlower, 2*halfFlower).size;
    
    // Return a random position within the inset bounds
    CGFloat randomX = random() % ((int)insetSize.width) + halfFlower;
    CGFloat randomY = random() % ((int)insetSize.height) + halfFlower;
    return CGPointMake(randomX, randomY);
}

- (void)layoutFlowers
{
    // Move every flower into a new random place
    [UIView animateWithDuration:0.3f animations: ^(){
        for (UIView *flowerDragger in self.view.subviews)
        {
            flowerDragger.center = [self randomFlowerPosition];
        }
    }];
}

@end

