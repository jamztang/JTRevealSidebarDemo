/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "JTTableViewDatasource.h"

@protocol JTTableViewCellTypeBase <NSObject>

- (NSString *)title;

@end


@protocol JTTableViewCellTypeExpandable <JTTableViewCellTypeBase>

- (JTTableViewDatasource *)datasource;

@end

@protocol JTTableViewCellTypeBack <NSObject>

@end


@interface JTTableViewCellTypeBase : NSObject <JTTableViewCellTypeBase>
@property (nonatomic, copy) NSString *title;
+ (JTTableViewCellTypeBase *)baseWithTitle:(NSString *)title;
@end

@interface JTTableViewCellTypeExpandable : JTTableViewCellTypeBase <JTTableViewCellTypeExpandable>
@property (nonatomic, retain) JTTableViewDatasource *datasource;
+ (JTTableViewCellTypeExpandable *)expandableWithTitle:(NSString *)title url:(NSString *)url;
@end


@interface JTTableViewCellTypeBack : JTTableViewCellTypeBase <JTTableViewCellTypeBack>
@end