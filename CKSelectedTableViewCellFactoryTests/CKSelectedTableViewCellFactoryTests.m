//
//  CKSelectedTableViewCellFactoryTests.m
//  CKSelectedTableViewCellFactoryTests
//
//  Created by Cody Kimberling on 7/28/13.
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//

#import "CKSelectedTableViewCellFactoryTests.h"
#import "CKSelectedTableViewCellFactory.h"
#import <QuartzCore/QuartzCore.h>
#import "OCMock.h"

@interface CKSelectedTableViewCellFactoryTests ()

@property (nonatomic) UITableView *plainTableView;
@property (nonatomic) UITableView *groupedTableView;

@property (nonatomic) UITableViewCell *cell;
@property (nonatomic) CGRect cellBounds;

@property (nonatomic) NSInteger numberOfRows;

@property (nonatomic) id mockBezierPath;
@property (nonatomic) id cgPath;

@end

@implementation CKSelectedTableViewCellFactoryTests

- (void)setUp
{
    [super setUp];
    
    CKSelectedTableViewCellFactory.sharedInstance.cornerRadius = 5.f;
    CKSelectedTableViewCellFactory.sharedInstance.backgroundColor = UIColor.lightGrayColor;
    
    self.plainTableView = UITableView.new;
    self.groupedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0) style:UITableViewStyleGrouped];
    
    self.cellBounds = CGRectMake(0.f, 0.f, 100.f, 50.f);
    
    self.cell = [[UITableViewCell alloc] initWithFrame:self.cellBounds];

    self.numberOfRows = 3;
    
    self.plainTableView.dataSource = self;
    self.groupedTableView.dataSource = self;
    
    self.mockBezierPath = [OCMockObject niceMockForClass:UIBezierPath.class];
    
//    [[[self.mockBezierPath stub] andReturn:self.cgPath] CGPath];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDefaults
{
    STAssertEquals(CKSelectedTableViewCellFactory.sharedInstance.cornerRadius, 5.f, nil);
    STAssertEquals(CKSelectedTableViewCellFactory.sharedInstance.backgroundColor, UIColor.lightGrayColor, nil);
}

- (void)testDefaultsCanBeOverridden
{
    CGFloat expectedCornerRadius = 10.f;
    UIColor *expectedColor = UIColor.redColor;
    
    CKSelectedTableViewCellFactory.sharedInstance.cornerRadius = expectedCornerRadius;
    CKSelectedTableViewCellFactory.sharedInstance.backgroundColor = expectedColor;
    
    STAssertEquals(CKSelectedTableViewCellFactory.sharedInstance.cornerRadius, expectedCornerRadius, nil);
    STAssertEquals(CKSelectedTableViewCellFactory.sharedInstance.backgroundColor, expectedColor, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_plainTopRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.plainTableView atIndexPath:indexPath];
    
    STAssertEquals(backgroundView.layer.mask.cornerRadius, 0.f, nil);
    STAssertTrue(backgroundView.clipsToBounds, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_plainMiddleRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.plainTableView atIndexPath:indexPath];
    
    STAssertEquals(backgroundView.layer.mask.cornerRadius, 0.f, nil);
    STAssertTrue(backgroundView.clipsToBounds, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_plainBottomRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.plainTableView atIndexPath:indexPath];
    
    STAssertEquals(backgroundView.layer.mask.cornerRadius, 0.f, nil);
    STAssertTrue(backgroundView.clipsToBounds, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_groupedTopRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

    UIRectCorner rectCorner = (UIRectCornerTopLeft | UIRectCornerTopRight);
    CGSize size = CGSizeMake(5.f, 5.f);

    [[self.mockBezierPath expect] CGPath];
    [[[self.mockBezierPath expect] andReturn:self.mockBezierPath] bezierPathWithRoundedRect:self.cell.bounds
                                                                        byRoundingCorners:rectCorner
                                                                              cornerRadii:size];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.groupedTableView atIndexPath:indexPath];
    
    [self.mockBezierPath verify];
    
    STAssertEquals(backgroundView.layer.mask.bounds, self.cell.bounds, nil);
    STAssertEquals(backgroundView.layer.mask.bounds, self.cell.bounds, nil);
    STAssertEquals(backgroundView.layer.mask.borderWidth, 0.f, nil);
    STAssertEquals(backgroundView.layer.mask.borderColor, UIColor.clearColor.CGColor, nil);
    STAssertTrue(backgroundView.clipsToBounds, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_groupedMiddleRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    CALayer *mask = self.cell.layer.mask;
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.groupedTableView atIndexPath:indexPath];
    
    STAssertTrue(backgroundView.clipsToBounds, nil);
    STAssertEqualObjects(backgroundView.layer.mask, mask, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_groupedBottomRow
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    
    UIRectCorner rectCorner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
    CGSize size = CGSizeMake(5.f, 5.f);
    
    [[self.mockBezierPath expect] CGPath];
    [[[self.mockBezierPath expect] andReturn:self.mockBezierPath] bezierPathWithRoundedRect:self.cell.bounds
                                                                          byRoundingCorners:rectCorner
                                                                                cornerRadii:size];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.groupedTableView atIndexPath:indexPath];
    
    [self.mockBezierPath verify];
    
    STAssertEquals(backgroundView.layer.mask.bounds, self.cell.bounds, nil);
    STAssertEquals(backgroundView.layer.mask.bounds, self.cell.bounds, nil);
    STAssertEquals(backgroundView.layer.mask.borderWidth, 0.f, nil);
    STAssertEquals(backgroundView.layer.mask.borderColor, UIColor.clearColor.CGColor, nil);
    STAssertTrue(backgroundView.clipsToBounds, nil);
}

- (void)testSelectedBackgroundViewForTableViewCell_groupedSingleRow
{
    self.numberOfRows = 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    UIView *backgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:self.cell inTableView:self.groupedTableView atIndexPath:indexPath];
    
    [self.mockBezierPath verify];
    
    STAssertEquals(backgroundView.layer.cornerRadius, 5.f, nil);
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cell;
}

@end