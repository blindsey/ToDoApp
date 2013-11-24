//
//  ToDoViewController.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoViewController.h"
#import "EditableTableCell.h"
#import "ToDoList.h"

#define REUSE_IDENTIFIER @"EditableTableCell"
#define kTextViewPadding 11.0

@interface ToDoViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ToDoList *list;
@property (strong, nonatomic) UIGestureRecognizer *gestureRecognizer;

- (void)onAdd;
- (void)onEdit;
- (void)onDoneEdit;
- (void)onTap;

@end

@implementation ToDoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = @"To Do List";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorInset = UIEdgeInsetsZero;

    [self onDoneEdit];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties

- (ToDoList *)list
{
    if (!_list) {
        _list = [[ToDoList alloc] init];
    }
    return _list;
}

- (UIGestureRecognizer *)gestureRecognizer
{
    if (!_gestureRecognizer) {
        _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
    }
    return _gestureRecognizer;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditableTableCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_IDENTIFIER forIndexPath:indexPath];
    cell.item = [self.list getItemAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.list removeItemAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.list moveItemFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToDoItem *item = [self.list getItemAtIndex:indexPath.row];

    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14.0] };
    NSString *newString = [NSString stringWithFormat:@"%@|", item.text];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:newString attributes:attributes];

    CGRect frame = [string boundingRectWithSize:CGSizeMake(250 - kTextViewPadding, CGFLOAT_MAX)
                                        options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                        context:nil];
    return ceilf(frame.size.height + 20);
}

#pragma mark - Editable table cell delegate

- (void)itemDidChange:(EditableTableCell *)cell
{
    [self.list save];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

- (void)itemDidBeginEditing:(EditableTableCell *)cell
{
    [self.tableView scrollRectToVisible:cell.frame animated:YES];
}

#pragma mark - Private methods

- (void)onAdd
{
    [self.list newItem];
    [self.tableView reloadData];
    [self onDoneEdit];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
    [cell.textView becomeFirstResponder];
}

- (void)onEdit
{
    [self.view removeGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneEdit)];

    for (int i = [self.list count] - 1; i >= 0; --i) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.textView.editable = NO; // disable keyboard
    }
}

- (void)onDoneEdit
{
    [self.view addGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.leftBarButtonItem = [self.list count] == 0 ? nil : [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)];

    for (int i = [self.list count] - 1; i >= 0; --i) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.textView.editable = !cell.item.done; // only editable if not finished
    }
}

- (void)onTap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.tableView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height - keyboardSize.height);
    } else {
        self.tableView.frame = CGRectMake(0, 0, screen.size.height, screen.size.width - keyboardSize.width);
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGRect screen = [[UIScreen mainScreen] bounds];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        self.tableView.frame = CGRectMake(0, 0, screen.size.width, screen.size.height);
    } else {
        self.tableView.frame = CGRectMake(0, 0, screen.size.height, screen.size.width);
    }
}

@end
