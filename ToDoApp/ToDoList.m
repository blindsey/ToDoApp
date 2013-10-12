//
//  ToDoList.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/10/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoList.h"

#define DEFAULTS_KEY @"ToDoList2_ALL"
#define DONE_KEY @"done"
#define TEXT_KEY @"text"

@interface ToDoList ()

@property (strong, nonatomic) NSMutableArray* items; // of ToDoItem

@end

@implementation ToDoList

-(id)init
{
    self = [super init];
    if (self) {
        NSArray *list = [[NSUserDefaults standardUserDefaults] arrayForKey:DEFAULTS_KEY];
        for (NSDictionary *dict in list) {
            ToDoItem *item = [[ToDoItem alloc] init];
            item.done = [dict[DONE_KEY] boolValue];
            item.text = dict[TEXT_KEY];
            [self.items addObject:item];
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
        [array addObject:@{ DONE_KEY : item.done ? @"1" : @"0", TEXT_KEY : item.text }];
    }
    [userDefaults setObject:array forKey:DEFAULTS_KEY];
    [userDefaults synchronize];
}

@end
