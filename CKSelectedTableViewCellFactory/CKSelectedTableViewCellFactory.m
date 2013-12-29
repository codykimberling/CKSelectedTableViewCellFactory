//
//  Copyright (c) 2013 Cody Kimberling. All rights reserved.
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  •  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//  •  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import "CKSelectedTableViewCellFactory.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark - Singleton Constants

static CKSelectedTableViewCellFactory *sharedInstance = nil;
static dispatch_once_t once_token = 0;

#pragma mark - Constants Pre iOS 7

static int kPreIos7PortraitWidthPhone = 302;
static int kPreIos7PortraitWidthPad = 680;

static int kPreIos7LandscapeWidthPhone = 550;
static int kPreIos7LandscapeWidthPad = 936;

#pragma mark - Constants Post iOS 7

static int kPostIos7PortraitWidthPhone = 320;
static int kPostIos7PortraitWidthPad = 680;

static int kPostIos7LandscapeWidthPhone = 550;
static int kPostIos7LandscapeWidthPad = 936;

typedef enum : NSInteger {
    CellPositionGroupedTop,
    CellPositionGroupedMiddle,
    CellPositionGroupedBottom,
    CellPositionGroupedSingle
} CellPosition;

@interface CKSelectedTableViewCellFactory ()

@property (nonatomic) CGFloat widthPortrait;
@property (nonatomic) CGFloat widthLandscape;

@end

@implementation CKSelectedTableViewCellFactory

+ (CKSelectedTableViewCellFactory *)sharedInstance
{
    dispatch_once(&once_token, ^{
        if (!sharedInstance) {
            sharedInstance = [[super allocWithZone:nil] init];
            sharedInstance.cornerRadius = 5.0;
            sharedInstance.backgroundColor = UIColor.lightGrayColor;

            if(sharedInstance.isPhoneIdiom){
                sharedInstance.widthPortrait = (sharedInstance.isDevicePreIosSeven) ? kPreIos7PortraitWidthPhone : kPostIos7PortraitWidthPhone;
                sharedInstance.widthLandscape = (sharedInstance.isDevicePreIosSeven) ? kPreIos7LandscapeWidthPhone : kPostIos7LandscapeWidthPhone;
            }else{
                sharedInstance.widthPortrait = (sharedInstance.isDevicePreIosSeven) ? kPreIos7PortraitWidthPad : kPostIos7PortraitWidthPad;
                sharedInstance.widthLandscape = (sharedInstance.isDevicePreIosSeven) ? kPreIos7LandscapeWidthPad : kPostIos7LandscapeWidthPad;
            }
            
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
        
        NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
        
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
    
    BOOL portraitOrientation = UIDeviceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    
    CGFloat width = (portraitOrientation) ? self.widthPortrait : self.widthLandscape;
    
    CGRect frame = CGRectMake(0, 0, width, cell.frame.size.height);
    UIView *selectionView = [[UIView alloc] initWithFrame:frame];
    selectionView.backgroundColor = self.backgroundColor;
    
    if(!self.isDevicePreIosSeven){
        return selectionView;
    }
    
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

- (BOOL)isDevicePreIosSeven
{
    return (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1);
}

- (BOOL)isPhoneIdiom
{
    return (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone);
}

@end