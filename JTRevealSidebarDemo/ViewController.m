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
#import "JTTableViewCellModal.h"
#import "JTTableViewCellFactory.h"

typedef enum {
    JTTableRowTypeBack,
    JTTableRowTypePushContentView,
} JTTableRowTypes;

@interface ViewController (UITableView) <JTTableViewDatasourceDelegate>
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _datasource = [[JTTableViewDatasource alloc] init];
        _datasource.sourceInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"root", @"url", nil];
        _datasource.delegate   = self;
    }
    return self;
}

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
    tableView.delegate   = _datasource;
    tableView.dataSource = _datasource;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_revealView.sidebarView pushView:tableView animated:NO];

    // Construct a toggle button for our contentView and add into it
//    UIButton *toggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    {
//        [toggleButton setTitle:@"Toggle" forState:UIControlStateNormal];
//        [toggleButton sizeToFit];
//        toggleButton.frame = CGRectOffset(toggleButton.frame, 4, 50);
//        [toggleButton addTarget:self action:@selector(toggleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    [_revealView.contentView addSubview:toggleButton];

    _revealView.contentView.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(toggleButtonPressed:)] autorelease];
    
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

- (void)pushContentView:(id)sender {
    UIView *subview = [[UIView alloc] initWithFrame:CGRectZero];
    subview.backgroundColor = [UIColor blueColor];
    subview.title           = @"Pushed Subview";
    [_revealView.contentView pushView:subview animated:YES];
    [subview release];
}

#pragma mark Helper

- (void)simulateDidSucceedFetchingDatasource:(JTTableViewDatasource *)datasource {
    NSString *url = [datasource.sourceInfo objectForKey:@"url"];
    if ([url isEqualToString:@"root"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObjects:
          [JTTableViewCellModalCustom modalWithInfo:
           [NSDictionary dictionaryWithObjectsAndKeys:
            @"Push", @"title",
            [JTTableViewDatasource dynamicDatasourceWithDelegate:self
                                                      sourceInfo:
             [NSDictionary dictionaryWithObjectsAndKeys:@"push", @"url", nil]], @"datasource", nil]],
          
          [JTTableViewCellModalSimpleType modalWithTitle:@"ContentView1" type:JTTableRowTypePushContentView],
          [JTTableViewCellModalSimpleType modalWithTitle:@"ContentView2" type:JTTableRowTypePushContentView],

          nil]
         ];
    } else if ([url isEqualToString:@"push"]) {
        [datasource configureSingleSectionWithArray:
         [NSArray arrayWithObject:
          [JTTableViewCellModalSimpleType modalWithTitle:@"Back" type:JTTableRowTypeBack]
          ]
         ];
    } else {
        NSAssert(NO, @"not handled!", nil);
    }
}

- (void)loadDatasourceSection:(JTTableViewDatasource *)datasource {
    [self performSelector:@selector(simulateDidSucceedFetchingDatasource:)
               withObject:datasource
               afterDelay:1];
}

@end


@implementation ViewController (UITableView)

- (BOOL)datasourceShouldLoad:(JTTableViewDatasource *)datasource {
    if ([datasource.sourceInfo objectForKey:@"url"]) {
        [self loadDatasourceSection:datasource];
        return YES;
    } else {
        return NO;
    }
}

- (UITableViewCell *)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView cellForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalLoadingIndicator)]) {
        static NSString *cellIdentifier = @"loadingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [JTTableViewCellFactory loaderCellWithIdentifier:cellIdentifier];
        }
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModal)]) {
        static NSString *cellIdentifier = @"titleCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        cell.textLabel.text = [(id <JTTableViewCellModal>)object title];
        return cell;
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            static NSString *cellIdentifier = @"datasourceCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [[custom info] objectForKey:@"title"];
            return cell;
        }
    }
    return nil;
}

- (void)datasource:(JTTableViewDatasource *)datasource tableView:(UITableView *)tableView didSelectObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(JTTableViewCellModalCustom)]) {
        id <JTTableViewCellModalCustom> custom = (id)object;
        JTTableViewDatasource *datasource = (JTTableViewDatasource *)[[custom info] objectForKey:@"datasource"];
        if (datasource) {
            UITableView *tableView = [[[UITableView alloc] initWithFrame:_revealView.sidebarView.bounds] autorelease];
            tableView.delegate   = datasource;
            tableView.dataSource = datasource;
            tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [_revealView.sidebarView pushView:tableView animated:YES];
        }
    } else if ([object conformsToProtocol:@protocol(JTTableViewCellModalSimpleType)]) {        
        switch ([(JTTableViewCellModalSimpleType *)object type]) {
            case JTTableRowTypeBack:
                [_revealView.sidebarView popViewAnimated:YES];
                UITableView *tableView = (UITableView *)[_revealView.sidebarView topView];
                [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
                break;
            case JTTableRowTypePushContentView:
            {
                UIView *view = [[UIView alloc] init];
                view.backgroundColor = [UIColor redColor];

                // Create a push button to demonstrate pushing subviews in the main content view
                UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [pushButton setTitle:@"Push" forState:UIControlStateNormal];
                [pushButton addTarget:self action:@selector(pushContentView:) forControlEvents:UIControlEventTouchUpInside];
                [pushButton sizeToFit];
                [view addSubview:pushButton];
                
                view.title = [(JTTableViewCellModalSimpleType *)object title];
                [_revealView.contentView setRootView:view];
                [view release];
                [_revealView revealSidebar:NO];
            }
            default:
                break;
        }
    }
}

- (void)datasource:(JTTableViewDatasource *)datasource sectionsDidChanged:(NSArray *)oldSections {
    [(UITableView *)[_revealView.sidebarView topView] reloadData];
}

@end