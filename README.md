JTRevealSidebarV2
===============

An iOS objective-c library template for mimic the sidebar layout of the new Facebook app and the Path app.  
JTRevealSidebarV2 is aimed to be a truly flexible and reusable solution for this which has been carefully implemented.  

It has been developed under iOS 4.3 and 5.0 devices, sample code has been built using ARC, but the library itself should be both ARC and non-ARC compatible.

Demo
----
![Initialized](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo1.png)
![Left Revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo2.png)
![Left Selected](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo3.png)
![Right Revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo4.png)
![New Pushed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo5.png)
![New Right Revealed](https://github.com/mystcolor/JTRevealSidebarDemo/raw/JTRevealSidebarV2/demo6.png)

Abstract
--------

In JTRevealSidebarV2, all sidebars should be considered as navigation items, each sidebar is expected to be able to configure directly through the current view controller.  
It is designed to be used with UINavigationController, but technically it should work on other subclasses of UIViewControllers.

How To Use It
-------------

### Installation

Include all header and implementation files in JTRevealSidebarV2/ into your project. 

### Setting up your first sidebar, configure your viewController and conform to the JTRevealSidebarV2Delegate

    @interface ViewController () <JTRevealSidebarV2Delegate>
    @end

    @implementation ViewController

    - (void)viewDidLoad
    {
        [super viewDidLoad];

        self.navigationItem.revealSidebarDelegate = self;
    }
    /*
    :
    :
    */
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

### Interacting and revealing your sidebar

    @implementation ViewController
    /*
    :
    :
    */
    #pragma mark Action

    - (void)revealLeftSidebar:(id)sender {
        JTRevealedState state = JTRevealedStateLeft;
        if (self.navigationController.revealedState == JTRevealedStateLeft) {
            state = JTRevealedStateNo;
        }
        [self.navigationController setRevealedState:state];
    }

    - (void)revealRightSidebar:(id)sender {
        JTRevealedState state = JTRevealedStateRight;
        if (self.navigationController.revealedState == JTRevealedStateRight) {
            state = JTRevealedStateNo;
        }
        [self.navigationController setRevealedState:state];
    }

    @end

### Known Issues

Orientation changing is not an officially completed feature, the main thing to fix is the rotation animation and the necessarity of the container created in AppDelegate. Please let me know if you've got any elegant solution and send me a pull request!  
Go to JTRevealSidebarV2/ViewController.h and change EXPERIEMENTAL_ORIENTATION_SUPPORT to 1 for testing purpose.

31/1/2012 updated:  
Improved orientation support with a better animation, now you needed to #import &lt;QuartzCore/QuartzCore.h&gt; in your project for this sake

1/2/2012 update:
Fixed #6 Wrong origin for sidebar views when first revealed in landscape mode (Experiental), the orientation support should be ready!


### Reminder

Remember to check out the sample working code in JTRevealSidebarDemoV2/ViewController.m, feel free to provide feedback and pull requests. Thanks!

James

