//
//  CKSelectedTableViewCellFactory.h
//
//  Created by Cody Kimberling on 5/16/13.

#import <Foundation/Foundation.h>

@interface CKSelectedTableViewCellFactory : NSObject

@property (strong, nonatomic) UIColor *backgroundColor; // default: [UIColor lightGrayColor]
@property (nonatomic) CGFloat cornerRadius; // defaul: 5.0

+ (CKSelectedTableViewCellFactory *)sharedSelectedTableViewCellFactory;

- (UIView *)selectedBackgroundViewForTableViewCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
