//
//  ViewController.m
//  DragAndDrop
//
//  Created by Jolie_Yang on 16/8/1.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ViewController.h"
#import "DragDropImageView.h"

@interface ViewController()

@property (weak) IBOutlet DragDropImageView *dragDropImageView;
@property (weak) IBOutlet NSTextField *tf;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    __weak typeof(self)weakSelf = self;
    weakSelf.dragDropImageView.dragDropBlock = ^(NSURL *url) {
        if (url.absoluteString) {
            weakSelf.tf.stringValue = [url path];
        }
    };
}

- (IBAction)chooseFilePanel:(id)sender {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.canChooseDirectories = YES;
    [openPanel setDirectoryURL:[NSURL URLWithString: [self getDocumentPath]]];
    [openPanel setAllowedFileTypes:[[NSArray alloc] initWithObjects:@"mobileprovision", nil]];
    
    NSInteger modalResponse = [openPanel runModal];
    if (modalResponse == NSModalResponseOK) {
        NSString *fileName = [[openPanel URL] path];
        self.tf.stringValue = fileName;
    } else {
        return;
    }
}
- (NSString *)getDocumentPath {
    NSArray *userLibraryDirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (userLibraryDirs.count <= 0) {
        return nil;
    }
    NSString *userLibraryDir = userLibraryDirs[0];
    
    return userLibraryDir;
}
- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
