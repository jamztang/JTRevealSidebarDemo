JTRevealSidebar
===============

An iOS objective-c library template for mimic the sidebar layout of the new Facebook app.
It's still in very early development state and doesn't have any functions, so please see it as demonstrating purpose.

Demo
----
![Not revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo1.png)
![Revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/master/demo2.png)


Motivation
----------

Just for fun and for demonstration purpose!

How To Use It
-------------


### Installation

Include all files in JTRevealSidebar into your project.


### Setting up with JTRevealSidebarView

Just #import the JTRevealSidebarView.h header, and construct a JTRevealSidebarView, and add it to your viewController.

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



Potential Future enhancements
-------------------

- Custom navigation bar
- Push/Pop view on content view
- Different styles of tableViewCells
- Dragging gesture on contentView to toggle sidebar
- and more.

