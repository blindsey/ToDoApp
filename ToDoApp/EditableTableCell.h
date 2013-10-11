//
//  EditableTableCell.h
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableTableCell : UITableViewCell

@property (strong, nonatomic) NSMutableString *dataSource;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
