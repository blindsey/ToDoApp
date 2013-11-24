//
//  EditableTableCell.h
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoItem.h"

@class EditableTableCell;

@protocol EditableTableCellDelegate <NSObject>

@optional
- (void)itemDidChange:(EditableTableCell *)cell;
- (void)itemDidBeginEditing:(EditableTableCell *)cell;

@end

@interface EditableTableCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) ToDoItem *item;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) id <EditableTableCellDelegate> delegate;

@end

