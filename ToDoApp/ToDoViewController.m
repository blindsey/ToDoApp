//
//  ToDoViewController.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/6/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoViewController.h"
#import "EditableTableCell.h"

@interface ToDoViewController ()

@property (strong, nonatomic) NSMutableArray *items; // of EditableTableCell

- (EditableTableCell *)createCell:(NSString *)text;
- (void)synchronize;

@end

#define TO_DO_KEY @"ToDoList_ALL"

@implementation ToDoViewController

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:TO_DO_KEY];
        for (NSString *text in list) {
            [_items addObject:[self createCell:text]];
        }
    }
    return _items;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"To Do List";
        [self finishEdit];
     
// TODO: figure out why tap doesn't work
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)];
//        [self.view addGestureRecognizer:tap];
    }
    return self;
}

- (void)addItem
{
    [self.items insertObject:[self createCell:@""] atIndex:0];
    [self synchronize];
    [self.tableView reloadData];
}

- (void)startEdit
{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishEdit)];
}

- (void)finishEdit
{
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(startEdit)];
}

- (IBAction)onTap
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.items[indexPath.item];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.items removeObjectAtIndex:indexPath.item];
        [self synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    id cell = self.items[sourceIndexPath.item];
    [self.items insertObject:cell atIndex:destinationIndexPath.item];
    [self.items removeObjectAtIndex:sourceIndexPath.item];
    [self synchronize];
}

#pragma mark - Table view delegate
/*

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

#pragma mark - Text field delegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self synchronize];
}

#pragma mark - Private methods

- (EditableTableCell *)createCell:(NSString *)text
{
    static NSString *identifier = @"EditableTableCell";
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
    EditableTableCell *cell = [nib objectAtIndex:0];
    cell.textField.text = text;
    cell.textField.delegate = self;
    return cell;
}

- (void)synchronize
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (EditableTableCell *cell in self.items) {
        [list addObject:cell.textField.text];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:list forKey:TO_DO_KEY];
    [userDefaults synchronize];
}

@end
