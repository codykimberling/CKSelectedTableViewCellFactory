# CKSelectedTableViewCellFactory
##  This library works for both styles of iPhone UITableView (Plain and Grouped)

In your AppDelegate class import this file:

    #import "CKSelectedTableViewCellFactory.h"

and set the Selected background color and corner radius, defaults are [UIColor lightGrayColor] and 5.0

    CKSelectedTableViewCellFactory.sharedInstance.backgroundColor = UIColor.redColor;

    CKSelectedTableViewCellFactory.sharedInstance.cornerRadius = 5.0;

To use in a UITableView:

    cell.selectedBackgroundView = [CKSelectedTableViewCellFactory.sharedInstance selectedBackgroundViewForTableViewCell:cell inTableView:tableView atIndexPath:indexPath];