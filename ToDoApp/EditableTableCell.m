//
//  EditableTableCell.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "EditableTableCell.h"

@interface EditableTableCell ()

- (void)setStateWithDone:(BOOL)done;

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

- (void)awakeFromNib
{
    [self.doneButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(ToDoItem *)item
{
    _item = item;
    [self setStateWithDone:item.done];
    self.textView.text = item.text;
    self.textView.delegate = self;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.item.text = textView.text;
    [self.delegate itemDidChange:self];
}

- (IBAction)onCheck:(UIButton *)sender
{
    [self setStateWithDone:!sender.selected];
    [self.delegate itemDidChange:self];
}

# pragma mark - Private methods

- (void)setStateWithDone:(BOOL)done
{
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    NSRange range = NSMakeRange(0, [mas length]);
    NSUnderlineStyle style = done ? NSUnderlineStyleSingle : NSUnderlineStyleNone;
    [mas addAttribute:NSStrikethroughStyleAttributeName
                value:[NSNumber numberWithInt:style]
                range:range];
    self.textView.attributedText = mas;
    self.textView.editable = NO;
    self.backgroundColor = done ? [UIColor lightGrayColor] : nil;
    self.item.done = self.doneButton.selected = done;
}

@end
