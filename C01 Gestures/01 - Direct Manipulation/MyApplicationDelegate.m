//
//  MyApplicationDelegate.m
//  Hello World
//
//  Created by David Duan on 12/5/15.
//  Copyright © 2015 Erica Sadun. All rights reserved.
//

#import "MyApplicationDelegate.h"
#import "MyViewController.h"

@implementation MyApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = [UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f];
    MyViewController *tbvc = [[MyViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end
