/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTTableViewDatasource.h"
#import "JTTableViewCellTypes.h"

@implementation JTTableViewDatasource

@synthesize sections, delegate, sourceInfo;

- (void)dealloc {
    [sections release];
    delegate = nil;
    [sourceInfo release];
    [super dealloc];
}

#pragma mark Instance method

- (NSObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (NSArray *)sections {
    if ( ! sections) {
        [self.delegate datasourceDidExpandSection:self];
        sections = [[NSArray arrayWithObject:
                     [NSArray arrayWithObject:
                      [JTTableViewCellTypeBase baseWithTitle:@"Loading..."]
                      ]
                     ]
                    retain];
    }
    return sections;
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.delegate datasource:self
                                            tableView:tableView
                                        cellForObject:[self objectAtIndexPath:indexPath]];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate datasource:self tableView:tableView didSelectObject:[self objectAtIndexPath:indexPath]];
}

#pragma mark NSProxy

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.delegate];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [[self.delegate class] instanceMethodSignatureForSelector:aSelector];
}

@end
