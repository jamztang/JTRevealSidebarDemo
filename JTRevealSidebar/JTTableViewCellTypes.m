/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTTableViewCellTypes.h"

@implementation JTTableViewCellTypeBase
@synthesize title;
- (void)dealloc {
    [title release];
    [super dealloc];
}
+ (JTTableViewCellTypeBase *)baseWithTitle:(NSString *)title {
    JTTableViewCellTypeBase *base = [[[self class] alloc] init];
    base.title = title;
    return [base autorelease];
}
@end

@implementation JTTableViewCellTypeExpandable
@synthesize datasource;
- (void)dealloc {
    [datasource release];
    [super dealloc];
}
+ (JTTableViewCellTypeExpandable *)expandableWithTitle:(NSString *)title url:(NSString *)url {
    JTTableViewCellTypeExpandable *expandable = [[[self class] alloc] init];
    expandable.title = title;
    JTTableViewDatasource *datasource = [[JTTableViewDatasource alloc] init];
    datasource.sourceInfo = [NSDictionary dictionaryWithObject:url forKey:@"url"];
    expandable.datasource = [datasource autorelease];
    return [expandable autorelease];
}
@end

@implementation JTTableViewCellTypeBack
@end

@implementation JTTableViewCellTypeLoader
@synthesize datasource, sourceInfo;
+ (JTTableViewCellTypeLoader *)loader {
    return [self loaderWithUrl:nil parentDatasource:nil];
}
+ (JTTableViewCellTypeLoader *)loaderWithUrl:(NSString *)url parentDatasource:(JTTableViewDatasource *)datasource {
    JTTableViewCellTypeLoader *loader = [[[self class] alloc] init];
    if (url && datasource) {
        loader.sourceInfo = [NSDictionary dictionaryWithObject:url forKey:@"url"];
        loader.datasource = datasource;
    }
    return [loader autorelease];
}
@end


#pragma mark Generic Data types

@implementation NSString (JTTableViewCellType)
- (NSString *)title {
    return self;
}
@end