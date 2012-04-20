//
//  AppDelegate.m
//  JTRevealSidebarDemoV2
//
//  Created by James Apple Tang on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "SidebarViewController.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"

@interface AppDelegate () <JTRevealSidebarV2Delegate>
@property (nonatomic, strong) SidebarViewController  *leftSidebarViewController;
@property (nonatomic, strong) UINavigationController *navController;
@property (nonatomic, strong) UITabBarController     *tabBarController;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize leftSidebarViewController, navController, tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    ViewController *controller = [[ViewController alloc] init];
    controller.title = @"ViewController";
    self.navController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    self.tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObject:self.navController]];
    self.navController.navigationItem.revealSidebarDelegate = self;

    
    controller.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(revealLeftSidebar:)];

#if EXPERIEMENTAL_ORIENTATION_SUPPORT
//    UINavigationController *container = [[UINavigationController alloc] init];
//    [container setNavigationBarHidden:YES animated:NO];
//    [container setViewControllers:[NSArray arrayWithObject:navController] animated:NO];
    self.window.rootViewController = tabBarController;
#else
    self.window.rootViewController = navController;
#endif

    [self.window makeKeyAndVisible];
    return YES;
}


#pragma mark JTRevealSidebarDelegate

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForLeftSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view 
    CGRect viewFrame = self.navController.applicationViewFrame;
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
//        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
}

#pragma mark Action


- (void)revealLeftSidebar:(id)sender {
    [self.tabBarController toggleRevealState:JTRevealedStateLeft];
}

@end
