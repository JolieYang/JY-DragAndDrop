//
//  JYTextView.m
//  DragAndDrop
//
//  Created by Jolie_Yang on 16/8/3.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYTextView.h"

@interface JYTextView()
@property (nonatomic, assign) BOOL allowDrag;
@end
@implementation JYTextView
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.allowDrag = NO;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

#pragma mark NSDraggingDestination
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationNone;
}
- (BOOL)prepareForDragOperation:(id<NSDraggingInfo>)sender {
    return self.allowDrag;
}
- (void)draggingExited:(id<NSDraggingInfo>)sender {
    NSLog(@"draggingExited");
}
@end
