//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "CKSelectedTableViewCellFactory.h"
#import <QuartzCore/QuartzCore.h>

static CKSelectedTableViewCellFactory *sharedInstance = nil;
static dispatch_once_t once_token = 0;

typedef enum : NSInteger {
    CellPositionGroupedTop,
    CellPositionGroupedMiddle,
    CellPositionGroupedBottom,
    CellPositionGroupedSingle
} CellPosition;

@implementation CKSelectedTableViewCellFactory

+ (CKSelectedTableViewCellFactory *)sharedInstance
{
    dispatch_once(&once_token, ^{
        if (!sharedInstance) {
            sharedInstance = [[super allocWithZone:nil] init];
            sharedInstance.cornerRadius = 5.0;
            sharedInstance.backgroundColor = UIColor.lightGrayColor;
        }
    });
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
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
    CGFloat width;
    
    BOOL portraitOrientation = UIDeviceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    
    if(portraitOrientation){
        width = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? 302 : 680;
    }else{
        width = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone ? 550 : 936;
    }
    
    CGRect frame = CGRectMake(0, 0, width, cell.frame.size.height);
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
            break;
    }
    selectionView.clipsToBounds = YES;
    
    return selectionView;
}

- (CAShapeLayer *)makeLayerForCellPosition:(CellPosition)cellPosition withView:(UIView *)view
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                               byRoundingCorners:(cellPosition == CellPositionGroupedTop) ? (UIRectCornerTopLeft | UIRectCornerTopRight) :
                                                                                                            (UIRectCornerBottomLeft | UIRectCornerBottomRight)
                                                     cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)];
    
    CAShapeLayer *maskLayer = CAShapeLayer.new;
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    maskLayer.borderColor = UIColor.clearColor.CGColor;
    maskLayer.borderWidth = 0.f;
    
    return maskLayer;
}

@end