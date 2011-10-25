JTRevealSidebar
===============

An iOS objective-c library template for mimic the sidebar layout of the new Facebook app.
It's still in very early development state and doesn't have any functions, so please see it as demonstrating purpose.
Caution! Use this carefully since a single view controller pattern may ultimately lead to a very large class manipulating all view transition logic in a single file.
Please let us know any tips to split out and reduce unmaintainable circumstances.

Demo
----
![Not revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo1.png)
![Revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo2.png)
![Pushed ContentView1](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo3.png)
![Pushed Subview](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo4.png)

Motivation
----------

Just for fun and for demonstration purpose!

How To Use It
-------------


### Installation

Include all files in JTRevealSidebar into your project.


### Setting up with JTRevealSidebarView

Just #import the JTRevealSidebarView.h header, and construct a JTRevealSidebarView, and add it to your viewController, (any subclass of UIViewController).

    #import "JTRevealSidebarView.h"
    #import "JTNavigationView.h"

    ...


    - (void)viewDidLoad
    {
        [super viewDidLoad];

        // Create a default style RevealSidebarView
        _revealView = [[JTRevealSidebarView defaultViewWithFrame:self.view.bounds] retain];
        
        // Setup a view to be the rootView of the sidebar
        UITableView *tableView = ...;
        [_revealView.sidebarView pushView:tableView animated:NO];

        // Construct a toggle button for our contentView and add into it
        UIButton *toggleButton = ...;
        [_revealView.contentView addSubview:toggleButton];
        
        [self.view addSubview:_revealView];
    }


    - (void)toggleButtonPressed:(id)sender {
        [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
    }


### Interacting on the sidebar (JTNavigationView)

    // Pushing a view on the sidebar
    [_revealView.sidebarView pushView:view animated:YES];
    
    // Popping a view from the sidebar
    [_revealView.sidebarView popViewAnimated:YES];


### Interacting on the mainview (JTNavigationView)

    // Setting the root view on the content view
    UIView *yourView = ...;
    // Setting appropriate title and navigationItems just like you'd did on a UINavigationController
    yourView.title = ...;
    yourView.navigationItem.rightBarButtonItem = ...;
    _revealView.contentView.rootView = yourView;

    // Pushing a view on the contentView
    [_revealView.contentView pushView:view animated:YES];
    
    // Popping a view from the contentView
    [_revealView.contentView popViewAnimated:YES];


Update Logs
-----------

- Added JTNavigationViewAnimationStyle to mimic two different animation styles. (Default "Push" style in sidebar, and "CoverUp" style in content view)
- Added rootView property on JTNavigationView
- Added title/navigationItem associative property by category to let JTNavigationView to push appropriate navigation bar details

- Added JTTableViewDatasource
- Added push/pop mechanism on main content view


Potential Future enhancements
-------------------

- Custom navigation bar
- Different styles of tableViewCells
- Dragging gesture on contentView to toggle sidebar
- and more.

