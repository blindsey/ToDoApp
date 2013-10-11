//
//  ToDoItem.h
//  ToDoApp
//
//  Created by Ben Lindsey on 10/11/13.
//  Copyright (c) 2013 Ben Lindsey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoItem : NSObject

@property (strong, nonatomic) NSString *text;
@property (nonatomic) BOOL *done;

- (id)initWithText:(NSString *)text;

@end
