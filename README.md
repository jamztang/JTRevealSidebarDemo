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
        CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
        UITableViewController *controller = self.leftSidebarViewController;
        if ( ! controller) {
            self.leftSidebarViewController = [[SidebarViewController alloc] init];
            self.leftSidebarViewController.sidebarDelegate = self;
            controller = self.leftSidebarViewController;
            controller.view.frame = CGRectMake(0, mainFrame.origin.y, 270, mainFrame.size.height);
            controller.title = @"LeftSidebarViewController";
        }
        return controller.view;
    }

    // This is an examle to configure your sidebar view without a UIViewController
    - (UIView *)viewForRightSidebar {
        CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
        UITableView *view = self.rightSidebarView;
        if ( ! view) {
            view = self.rightSidebarView = [[UITableView alloc] initWithFrame:CGRectMake(50, mainFrame.origin.y, 270, mainFrame.size.height)];
            view.dataSource = self;
            view.delegate   = self;
        }
        return view;
    }
    @end

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
Improved orientation support with a better animation, now you needed to #import <QuartzCore/QuartzCore.h> in your project for this sake

### Reminder

Remember to check out the sample working code in JTRevealSidebarDemoV2/ViewController.m, feel free to provide feedback and pull requests. Thanks!

James

