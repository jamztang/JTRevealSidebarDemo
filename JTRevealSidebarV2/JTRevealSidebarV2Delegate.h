//
//  JTRevealSidebarV2.h
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTRevealSidebarV2Delegate <NSObject>

@optional
- (UIView *)viewForLeftSidebar;
- (UIView *)viewForRightSidebar;

@end
