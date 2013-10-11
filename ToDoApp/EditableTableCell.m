//
//  EditableTableCell.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "EditableTableCell.h"

@interface EditableTableCell ()

@end

@implementation EditableTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ToDoItem *)item
{
    _item = item;
    self.textView.text = item.text;
    self.textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.item.text = textView.text;
    [self.delegate textDidChange:self];
}

@end
