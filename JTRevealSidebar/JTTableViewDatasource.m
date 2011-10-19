/*
 * This file is part of the JTRevealSidebar package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTTableViewDatasource.h"
//#import "JTTableViewCellTypes.h"
#import "JTTableViewCellModal.h"

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
        BOOL shouldLoad = [self.delegate datasourceShouldLoad:self];

        if (shouldLoad) {
            sections = [[NSArray arrayWithObject:
                         [NSArray arrayWithObject:
                          [JTTableViewCellModalLoadingIndicator modal]
                          ]]
                        retain];
        } else {
            sections = [[NSArray arrayWithObject:[NSArray array]] retain];
        }
    }
    return sections;
}

//- (void)replaceLoader:(id <JTTableViewCellTypeLoader>)loader withObjects:(NSArray *)objects {
//    NSUInteger section = 0;
//    NSUInteger row = 0;
//    NSUInteger sectionCount = [self.sections count];
//    for (section = 0; section < sectionCount; section++) {
//        NSArray *array = [self.sections objectAtIndex:section];
//        row = [array indexOfObject:loader];
//        if (row != NSNotFound) {
//            break;
//        }
//    }
//    if (row != NSNotFound) {
//        NSMutableArray *copied = [[self.sections mutableCopy] autorelease];
//        NSMutableArray *targetSection = [[[copied objectAtIndex:section] mutableCopy] autorelease];
//        [targetSection removeObjectAtIndex:row];
//        [targetSection insertObjects:objects atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(row, [objects count])]];
//        
//        [copied replaceObjectAtIndex:section withObject:targetSection];
//        
//        self.sections = copied;
//    }
//}


- (void)configureSingleSectionWithArray:(NSArray *)objects {
    NSArray *oldSections = sections;
    sections = [[NSArray alloc] initWithObjects:objects, nil];
    [self.delegate datasource:self sectionsDidChanged:oldSections];
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
//    if ([[self objectAtIndexPath:indexPath] conformsToProtocol:@protocol(JTTableViewCellTypeLoader)]) {
//        if ([(id <JTTableViewCellTypeLoader>)[self objectAtIndexPath:indexPath] datasource]) {
//            [self.delegate datasource:self shouldFetchLoader:(id)[self objectAtIndexPath:indexPath]];
//        }
//    }
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

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.delegate respondsToSelector:aSelector]) {
        return YES;
    }
    // Use class method for determine whether self response to selector to prevent infinite loop
    return [[self class] instancesRespondToSelector:aSelector];
}

#pragma mark Class

+ (JTTableViewDatasource *)dynamicDatasourceWithDelegate:(id <JTTableViewDatasourceDelegate>)delegate sourceInfo:(NSDictionary *)sourceInfo {
    JTTableViewDatasource *datasource = [[JTTableViewDatasource alloc] init];
    datasource.delegate = delegate;
    datasource.sourceInfo = sourceInfo;
    return [datasource autorelease];
}

@end
