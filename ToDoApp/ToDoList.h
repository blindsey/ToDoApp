//
//  ToDoList.h
//  ToDoApp
//
//  Created by Ben Lindsey on 10/10/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoList : NSObject

- (NSUInteger)count;
- (NSMutableString *)newItem;
- (NSMutableString *)getItemAtIndex:(NSUInteger)index;
- (void)removeItemAtIndex:(NSUInteger)index;
- (void)moveItemFromIndex:(NSUInteger)source toIndex:(NSUInteger)destination;
- (void)save;

@end
