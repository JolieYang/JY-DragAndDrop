//
//  JYTextField.m
//  DragAndDrop
//
//  Created by Jolie_Yang on 16/8/3.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "JYTextField.h"

@implementation JYTextField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
#pragma mark NSDraggingDestination
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender {
    return NSDragOperationNone;
}
@end
