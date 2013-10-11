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

@interface ToDoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ToDoList *list;
@property (strong, nonatomic) UIGestureRecognizer *gestureRecognizer;

- (void)onAdd;
- (void)onEdit;
- (void)onDoneEdit;
- (void)onTap;

@end

@implementation ToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"To Do List";
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0); // remove top margin
    [self onDoneEdit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    cell.dataSource = [self.list getItemAtIndex:indexPath.row];
    cell.textField.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.list removeItemAtIndex:indexPath.row];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.list moveItemFromIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.list save];
}

#pragma mark - Private methods

- (void)onAdd
{
    [self.list newItem];
    [self.tableView reloadData];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
    [cell.textField becomeFirstResponder];
}

- (void)onEdit
{
    [self.view removeGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneEdit)];

    for (int i = self.list.count - 1; i >= 0; --i) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.textField.enabled = NO;
    }
}

- (void)onDoneEdit
{
    [self.view addGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)];

    for (int i = self.list.count - 1; i >= 0; --i) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        EditableTableCell *cell = (EditableTableCell *)[self.tableView cellForRowAtIndexPath:path];
        cell.textField.enabled = YES;
    }
}

- (void)onTap
{
    [self.view endEditing:YES];
}

@end
