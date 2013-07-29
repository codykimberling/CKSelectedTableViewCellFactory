//
//  CKSelectedTableViewCellFactory.m
//
//  Created by Cody Kimberling on 5/16/13.

#import "CKSelectedTableViewCellFactory.h"
#import <QuartzCore/QuartzCore.h>

typedef enum : NSInteger {
    CellPositionGroupedTop,
    CellPositionGroupedMiddle,
    CellPositionGroupedBottom,
    CellPositionGroupedSingle
} CellPosition;

@implementation CKSelectedTableViewCellFactory

+ (CKSelectedTableViewCellFactory *)sharedSelectedTableViewCellFactory
{
    static CKSelectedTableViewCellFactory *factory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        factory = [[super allocWithZone:nil] init];
        factory.cornerRadius = 5.0;
        factory.backgroundColor = [UIColor lightGrayColor];
    });
    return [factory init];
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedSelectedTableViewCellFactory];
}

- (UIView *)selectedBackgroundViewForTableViewCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    CellPosition cellPosition = CellPositionGroupedMiddle;
    
    if(tableView.style == UITableViewStyleGrouped){
        
        int numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
        
        if(numberOfRows == 1){
            cellPosition = CellPositionGroupedSingle;
        }else if(indexPath.row == 0){
                cellPosition = CellPositionGroupedTop;
        }else if(numberOfRows == indexPath.row+1){
                cellPosition = CellPositionGroupedBottom;
        }
    }
    return [self viewForTableView:tableView andCell:cell withPosition:cellPosition];
}

- (UIView *)viewForTableView:(UITableView *)tableView andCell:(UITableViewCell *)cell withPosition:(CellPosition)cellPosision
{
    CGRect frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    UIView *selectionView = [[UIView alloc] initWithFrame:frame];
    selectionView.backgroundColor = self.backgroundColor;
    
    switch (cellPosision) {
        case CellPositionGroupedTop:
            selectionView.layer.mask = [self makeLayerForCellPosition:cellPosision withView:selectionView];
            break;
        case CellPositionGroupedBottom:
            selectionView.layer.mask = [self makeLayerForCellPosition:cellPosision withView:selectionView];
            break;
        case CellPositionGroupedSingle:
            selectionView.layer.cornerRadius = self.cornerRadius;
            break;
        default://CellPositionGroupedSingle
            selectionView.layer.cornerRadius = 0.0;
            break;
    }
    selectionView.clipsToBounds = YES;
    
    return selectionView;
}

- (CAShapeLayer *)makeLayerForCellPosition:(CellPosition)cellPosition withView:(UIView *)view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                               byRoundingCorners:(cellPosition == CellPositionGroupedTop) ? (UIRectCornerTopLeft | UIRectCornerTopRight) : (UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                     cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    
    CAShapeLayer *maskLayer = CAShapeLayer.new;
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    maskLayer.borderColor = UIColor.clearColor.CGColor;
    
    return maskLayer;
}

@end