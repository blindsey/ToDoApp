//
//  ToDoList.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/10/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoList.h"

#define DEFAULTS_KEY @"ToDoList_ALL"

@interface ToDoList ()

@property (strong, nonatomic) NSMutableArray* items; // of ToDoItem

@end

@implementation ToDoList

-(id)init
{
    self = [super init];
    if (self) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:DEFAULTS_KEY];
        for (NSString *text in list) {
            [self.items addObject:[[ToDoItem alloc] initWithText:text]];
        }
    }
    return self;
}

- (NSMutableArray *)items
{
    if (!_items) {
        _items = [[NSMutableArray alloc] init];
    }
    return _items;
}

- (NSUInteger)count
{
    return [self.items count];
}

- (ToDoItem *)newItem
{
    ToDoItem *item = [[ToDoItem alloc] initWithText:@""];
    [self.items insertObject:item atIndex:0];
    [self save];
    return item;
}

- (ToDoItem *)getItemAtIndex:(NSUInteger)index
{
    return self.items[index];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    [self.items removeObjectAtIndex:index];
    [self save];
}

- (void)moveItemFromIndex:(NSUInteger)source toIndex:(NSUInteger)destination
{
    id item = self.items[source];
    [self.items removeObjectAtIndex:source];
    [self.items insertObject:item atIndex:destination];
    [self save];
}

- (void)save
{
    // TODO: persist done state as first character
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ToDoItem *item in self.items) {
        [array addObject:item.text];
    }
    [userDefaults setObject:array forKey:DEFAULTS_KEY];
    [userDefaults synchronize];
}

@end
