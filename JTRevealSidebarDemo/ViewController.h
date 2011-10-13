//
//  ViewController.h
//  JTRevealSidebarDemo
//
//  Created by james on 10/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTRevealSidebarView;
@class JTTableViewDatasource;

@interface ViewController : UIViewController {
    JTRevealSidebarView *_revealView;
    JTTableViewDatasource *_datasource;
}

@end
