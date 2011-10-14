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
#import "JTTableViewDatasource.h"
#import "JTTableViewCellTypes.h"
#import "JTTableViewCellFactory.h"

typedef enum {
    JTTableRowPush,
    JTTableRowsCount
} JTTableRow;

@interface ViewController (UITableView) <JTTableViewDatasourceDelegate>
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
    _datasource = [[JTTableViewDatasource alloc] init];
    _datasource.sections = [NSArray arrayWithObject:
                            [NSArray arrayWithObjects:
                             [JTTableViewCellTypeExpandable expandableWithTitle:@"Friends" url:@"friends"],
                             [JTTableViewCellTypeExpandable expandableWithTitle:@"Pagination" url:@"pagination"],
                             nil]];
    _datasource.delegate = self;
    
    // Setup a view to be the rootView of the sidebar
    UITableView *tableView = [[[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds] autorelease];
    tableView.delegate = _datasource;
    tableView.dataSource = _datasource;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

- (void)simulateFetchingDatasource:(JTTableViewDatasource *)datasource {
    NSString *url = [datasource.sourceInfo objectForKey:@"url"];
    if ([url isEqualToString:@"friends"]) {
        datasource.sections = [NSArray arrayWithObject:
                               [NSArray arrayWithObjects:
                                [JTTableViewCellTypeBack baseWithTitle:@"Back"],
                                [JTTableViewCellTypeExpandable expandableWithTitle:@"Mary" url:@"mary"],
                                [JTTableViewCellTypeExpandable expandableWithTitle:@"James" url:@"james"],
                                nil
                                ]];
        [(id)[_revealView.sidebarView topView] reloadData];
    } else if ([url isEqualToString:@"mary"]) {
        datasource.sections = [NSArray arrayWithObject:
                               [NSArray arrayWithObjects:
                                [JTTableViewCellTypeBack baseWithTitle:@"Back"],
                                @"Name: Mary",
                                @"Age: 22",
                                nil
                                ]];
        [(id)[_revealView.sidebarView topView] reloadData];
    } else if ([url isEqualToString:@"james"]) {
        datasource.sections = [NSArray arrayWithObject:
                               [NSArray arrayWithObjects:
                                [JTTableViewCellTypeBack baseWithTitle:@"Back"],
                                @"Name: James",
                                @"Age: 23",
                                nil
                                ]];
        [(id)[_revealView.sidebarView topView] reloadData];
    } else if ([url isEqualToString:@"pagination"]) {
        datasource.sections = [NSArray arrayWithObject:
                               [NSArray arrayWithObjects:
                                [JTTableViewCellTypeBack baseWithTitle:@"Back"],
                                [JTTableViewCellTypeLoader loaderWithUrl:@"page1" parentDatasource:datasource],
                                nil
                                ]];
        [(id)[_revealView.sidebarView topView] reloadData];
    }
}

- (void)simulateFetchingLoader:(id <JTTableViewCellTypeLoader>)loader {
    NSString *url = [[loader sourceInfo] objectForKey:@"url"];
    if ([url isEqualToString:@"page1"]) {

        JTTableViewDatasource *datasource = [loader datasource];
        
        [datasource replaceLoader:loader
                      withObjects:[NSArray arrayWithObjects:
                                   @"1",
                                   @"2",
                                   @"3",
                                   @"4",
                                   @"5",
                                   [JTTableViewCellTypeLoader loaderWithUrl:@"page2" parentDatasource:[loader datasource]],
                                   nil]];
        [(id)[_revealView.sidebarView topView] reloadData];

    } else if ([url isEqualToString:@"page2"]) {
        
        JTTableViewDatasource *datasource = [loader datasource];
        
        [datasource replaceLoader:loader
                      withObjects:[NSArray arrayWithObjects:
                                   @"6",
                                   @"7",
                                   @"8",
                                   @"9",
                                   @"0",
                                   [JTTableViewCellTypeLoader loaderWithUrl:@"page1" parentDatasource:[loader datasource]],
                                   nil]];
        [(id)[_revealView.sidebarView topView] reloadData];
    }
}

@end


@implementation ViewController (UITableView)

- (void)datasource:(JTTableViewDatasource *)datasource shouldFetchLoader:(id<JTTableViewCellTypeLoader>)loader {
    [self performSelector:@selector(simulateFetchingLoader:) withObject:loader afterDelay:1];
}

- (void)datasourceShouldFetch:(JTTableViewDatasource *)datasource {
    [self performSelector:@selector(simulateFetchingDatasource:) withObject:datasource afterDelay:1];
}

- (void)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView didSelectObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellTypeExpandable)]) {
        id <JTTableViewCellTypeExpandable> expandable = (id)object;

        UITableView *tableView = [[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds style:UITableViewStylePlain];
        tableView.dataSource = expandable.datasource;
        tableView.delegate   = expandable.datasource;
        expandable.datasource.delegate = self;
        [_revealView.sidebarView pushView:tableView animated:YES];
        [tableView release];
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellTypeBack)]) {
        [_revealView.sidebarView popViewAnimated:YES];
        UITableView *previousView = (UITableView *)[_revealView.sidebarView topView];
        [previousView deselectRowAtIndexPath:[previousView indexPathForSelectedRow] animated:YES];
    }
}

- (UITableViewCell *)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView cellForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellTypeExpandable)]) {
        static NSString *cellIdentifier = @"expandable";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ( ! cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIdentifier] autorelease];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = [(id <JTTableViewCellTypeExpandable>)object title];
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellTypeBase)]) {
        static NSString *cellIdentifier = @"base";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ( ! cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.textLabel.text = [(id <JTTableViewCellTypeBase>)object title];  
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellTypeLoader)]) {
        static NSString *cellIdentifier = @"loader";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if ( ! cell) {
            cell = [JTTableViewCellFactory loaderCellWithIdentifier:cellIdentifier];
        }
        return cell;
    }
    return nil;
}


@end