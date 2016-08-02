//
//  DragDropView.h
//  DragAndDrop
//
//  Created by Jolie_Yang on 16/8/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface DragDropView : NSView<NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider>

@property (nonatomic, copy) void(^dragDropBlock)(NSURL *url);

@end
