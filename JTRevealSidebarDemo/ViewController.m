//
//  ViewController.m
//  JTRevealSidebarDemo
//
//  Created by james on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JTRevealSidebarView.h"

@implementation ViewController

- (void)dealloc {
    [_revealView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _revealView = [JTRevealSidebarView defaultViewWithFrame:self.view.bounds];

    // Construct a toggle button for our contentView
    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    {
        [toggleButton setTitle:@"Toggle" forState:UIControlStateNormal];
        [toggleButton sizeToFit];
        [toggleButton addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [_revealView.contentView addSubview:toggleButton];
    
    [self.view addSubview:_revealView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Actions

- (void)toggleButtonPressed:(id)sender {
    [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end