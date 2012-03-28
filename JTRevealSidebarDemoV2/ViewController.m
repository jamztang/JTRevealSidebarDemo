//
//  ViewController.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 7/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "NewViewController.h"
#import "JTRevealSidebarV2Delegate.h"

#if EXPERIEMENTAL_ORIENTATION_SUPPORT
#import <QuartzCore/QuartzCore.h>
#endif

@interface ViewController (Private) <UITableViewDataSource, UITableViewDelegate, SidebarViewControllerDelegate>
@end

@implementation ViewController

@synthesize leftSidebarViewController;
@synthesize rightSidebarView;
@synthesize leftSelectedIndexPath;
@synthesize label;

- (id)init {
    self = [super init];
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, 260, 60)];
    self.label.backgroundColor  = [UIColor clearColor];
    self.label.textColor        = [UIColor whiteColor];
    self.label.textAlignment    = UITextAlignmentCenter;
    self.label.numberOfLines    = 2;
    [self.view addSubview:self.label];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(revealLeftSidebar:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(revealRightSidebar:)];

    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton setTitle:@"Push NewViewController" forState:UIControlStateNormal];
    [pushButton sizeToFit];
    [pushButton addTarget:self action:@selector(pushNewViewController:) forControlEvents:UIControlEventTouchUpInside];
    pushButton.frame = (CGRect){10, 150, self.view.frame.size.width - 20, pushButton.frame.size.height};
    [self.view addSubview:pushButton];

    self.navigationItem.revealSidebarDelegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.label = nil;
    self.rightSidebarView = nil;
}

#if EXPERIEMENTAL_ORIENTATION_SUPPORT

// Doesn't support rotating to other orientation at this moment
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _containerOrigin = self.navigationController.view.frame.origin;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    self.navigationController.view.layer.bounds       = (CGRect){-_containerOrigin.x, _containerOrigin.y, self.navigationController.view.frame.size};
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    self.navigationController.view.layer.bounds       = (CGRect){CGPointZero, self.navigationController.view.frame.size};
    self.navigationController.view.frame              = (CGRect){_containerOrigin, self.navigationController.view.frame.size};
   
    NSLog(@"%@", self);
}

- (NSString *)description {
    NSString *logMessage = [NSString stringWithFormat:@"ViewController {"];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t%@", self.view];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t%@", self.navigationController.view];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t%@", self.leftSidebarViewController.view];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t%@", self.rightSidebarView];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t%@", self.navigationController.navigationBar];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t <statusBarFrame> %@", NSStringFromCGRect([[UIApplication sharedApplication] statusBarFrame])];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t <applicationFrame> %@", NSStringFromCGRect([[UIScreen mainScreen] applicationFrame])];
    logMessage = [logMessage stringByAppendingFormat:@"\n\t <preferredViewFrame> %@", NSStringFromCGRect(self.navigationController.applicationViewFrame)];
    logMessage = [logMessage stringByAppendingFormat:@"\n}"];
    return logMessage;
}

#endif

#pragma mark Action

- (void)revealLeftSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateLeft];
}

- (void)revealRightSidebar:(id)sender {
    [self.navigationController toggleRevealState:JTRevealedStateRight];
}

- (void)pushNewViewController:(id)sender {
    NewViewController *controller = [[NewViewController alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    controller.title = @"NewViewController";
    controller.label.text = @"Pushed NewViewController";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark JTRevealSidebarDelegate

// This is an examle to configure your sidebar view through a custom UIViewController
- (UIView *)viewForLeftSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view 
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UITableViewController *controller = self.leftSidebarViewController;
    if ( ! controller) {
        self.leftSidebarViewController = [[SidebarViewController alloc] init];
        self.leftSidebarViewController.sidebarDelegate = self;
        controller = self.leftSidebarViewController;
        controller.title = @"LeftSidebarViewController";
    }
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    return controller.view;
}

// This is an examle to configure your sidebar view without a UIViewController
- (UIView *)viewForRightSidebar {
    // Use applicationViewFrame to get the correctly calculated view's frame
    // for use as a reference to our sidebar's view 
    CGRect viewFrame = self.navigationController.applicationViewFrame;
    UITableView *view = self.rightSidebarView;
    if ( ! view) {
        view = self.rightSidebarView = [[UITableView alloc] initWithFrame:CGRectZero];
        view.dataSource = self;
        view.delegate   = self;
    }
    view.frame = CGRectMake(self.navigationController.view.frame.size.width - 270, viewFrame.origin.y, 270, viewFrame.size.height);
    view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    return view;
}

// Optional delegate methods for additional configuration after reveal state changed
- (void)didChangeRevealedStateForViewController:(UIViewController *)viewController {
    // Example to disable userInteraction on content view while sidebar is revealing
    if (viewController.revealedState == JTRevealedStateNo) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

@end


@implementation ViewController (Private)

#pragma mark UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( ! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.rightSidebarView) {
        return @"RightSidebar";
    }
    return nil;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController setRevealedState:JTRevealedStateNo];
    if (tableView == self.rightSidebarView) {
        self.label.text = [NSString stringWithFormat:@"Selected %d at RightSidebarView", indexPath.row];
    }
}

#pragma mark SidebarViewControllerDelegate

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath {

    [self.navigationController setRevealedState:JTRevealedStateNo];

    ViewController *controller = [[ViewController alloc] init];
    controller.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    controller.title = (NSString *)object;
    controller.leftSidebarViewController  = sidebarViewController;
    controller.leftSelectedIndexPath      = indexPath;
    controller.label.text = [NSString stringWithFormat:@"Selected %@ from LeftSidebarViewController", (NSString *)object];
    sidebarViewController.sidebarDelegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];

}

- (NSIndexPath *)lastSelectedIndexPathForSidebarViewController:(SidebarViewController *)sidebarViewController {
    return self.leftSelectedIndexPath;
}

@end