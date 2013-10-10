//
//  ToDoViewController.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoViewController.h"
#import "EditableTableCell.h"

#define DEFAULTS_KEY @"ToDoList_ALL"
#define REUSE_IDENTIFIER @"EditableTableCell"

@interface ToDoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *cells; // of EditableTableCell
@property (strong, nonatomic) UIGestureRecognizer *gestureRecognizer;

- (void)onAdd;
- (void)onEdit;
- (void)onDoneEdit;
- (void)onTap;

- (EditableTableCell *)editableCellWithText:(NSString *)text;
- (void)saveToUserDefaults;

@end

@implementation ToDoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"To Do List";
    self.tableView.dataSource = self;
    [self onDoneEdit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (NSMutableArray *)cells
{
    if (!_cells) {
        _cells = [[NSMutableArray alloc] init];
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:DEFAULTS_KEY];
        for (NSString *text in list) {
            [_cells addObject:[self editableCellWithText:text]];
        }
    }
    return _cells;
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
    return [self.cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cells[indexPath.item];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.cells removeObjectAtIndex:indexPath.item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveToUserDefaults];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    EditableTableCell *cell = self.cells[sourceIndexPath.row];
    [self.cells removeObjectAtIndex:sourceIndexPath.row];
    [self.cells insertObject:cell atIndex:destinationIndexPath.row];
    [self saveToUserDefaults];
}

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self saveToUserDefaults];
}

#pragma mark - Private methods

- (void)onAdd
{
    EditableTableCell *cell = [self editableCellWithText:@""];
    [self.cells insertObject:cell atIndex:0];
    [self.tableView reloadData];
    [cell.textField becomeFirstResponder];
}

- (void)onEdit
{
    [self.view removeGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneEdit)];
    for (EditableTableCell *cell in self.cells) {
        cell.textField.enabled = NO;
    }
}

- (void)onDoneEdit
{
    [self.view addGestureRecognizer:self.gestureRecognizer];
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(onEdit)];
    for (EditableTableCell *cell in self.cells) {
        cell.textField.enabled = YES;
    }
}

- (void)onTap
{
    [self.view endEditing:YES];
}

- (EditableTableCell *)editableCellWithText:(NSString *)text
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EditableTableCell" owner:self options:nil];
    EditableTableCell *cell = [nib objectAtIndex:0];
    cell.textField.text = text;
    cell.textField.delegate = self;
    return cell;
}

- (void)saveToUserDefaults
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (EditableTableCell *cell in self.cells) {
        [list addObject:cell.textField.text];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:list forKey:DEFAULTS_KEY];
    [userDefaults synchronize];
}

@end
