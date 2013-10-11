//
//  ToDoItem.m
//  ToDoApp
//
//  Created by Ben Lindsey on 10/11/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import "ToDoItem.h"

@implementation ToDoItem

- (id)initWithText:(NSString *)text
{
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

- (NSString *)text
{
    if (_text == nil) {
        return @"";
    }
    return _text;
}

@end
