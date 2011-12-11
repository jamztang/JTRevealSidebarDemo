//
//  UINavigationItem+JTRevealSidebarV2.h
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTRevealSidebarV2Delegate;

@interface UINavigationItem (JTRevealSidebarV2)

@property (nonatomic, assign) id <JTRevealSidebarV2Delegate> revealSidebarDelegate;

@end
