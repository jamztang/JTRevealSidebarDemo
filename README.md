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

### Using JTRevealView

Just #import the JTRevealView.h header, and construct a JTRevealView, and add it to your viewController.

    #import "JTRevealSidebarView.h"

    ...


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

    - (void)toggleButtonPressed:(id)sender {
        [_revealView revealSidebar: ! [_revealView isSidebarShowing]];
    }

