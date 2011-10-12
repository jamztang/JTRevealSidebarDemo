//
//  ViewController.m
//  JTRevealSidebarDemo
//
//  Created by james on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JTRevealSidebarView.h"
#import "JTNavigationView.h"

typedef enum {
    JTTableRowPush,
    JTTableRowsCount
} JTTableRow;

@interface ViewController (UITableView) <UITableViewDelegate, UITableViewDataSource>
@end

@implementation ViewController

- (void)dealloc {
    [_revealView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Create a default style RevealSidebarView
    _revealView = [[JTRevealSidebarView defaultViewWithFrame:self.view.bounds] retain];
    
    // Setup a view to be the rootView of the sidebar
    UITableView *tableView = [[[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds] autorelease];
    tableView.delegate = self;
    tableView.dataSource = self;
    [_revealView.sidebarView pushView:tableView animated:NO];

    // Construct a toggle button for our contentView and add into it
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


@implementation ViewController (UITableView)

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return JTTableRowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    switch (indexPath.row) {
        case JTTableRowPush:
            if ([[_revealView.sidebarView views] count] == 1) { // If only root view, we don't show Back button
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"Push";
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.textLabel.text = @"Back";
            }
            break;
        default:
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == JTTableRowPush) {
        if ([[_revealView.sidebarView views] count] == 1) { // If only root view, we push a new view
            UITableView *view = [[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds];
            view.delegate   = self;
            view.dataSource = self;

            // Pushing a view on the sidebar
            [_revealView.sidebarView pushView:view animated:YES];
            [view release];
        } else {
            
            // Popping a view from the sidebar
            [_revealView.sidebarView popViewAnimated:YES];
            
            UITableView *previousView = (UITableView *)[_revealView.sidebarView topView];
            [previousView deselectRowAtIndexPath:[previousView indexPathForSelectedRow] animated:YES];
        }
    }
}

@end