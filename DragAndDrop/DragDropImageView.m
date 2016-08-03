/*
     File: DragDropImageView.m 
 Abstract: Custom subclass of NSImageView with support for drag and drop operations. 
  Version: 1.1 
  
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple 
 Inc. ("Apple") in consideration of your agreement to the following 
 terms, and your use, installation, modification or redistribution of 
 this Apple software constitutes acceptance of these terms.  If you do 
 not agree with these terms, please do not use, install, modify or 
 redistribute this Apple software. 
  
 In consideration of your agreement to abide by the following terms, and 
 subject to these terms, Apple grants you a personal, non-exclusive 
 license, under Apple's copyrights in this original Apple software (the 
 "Apple Software"), to use, reproduce, modify and redistribute the Apple 
 Software, with or without modifications, in source and/or binary forms; 
 provided that if you redistribute the Apple Software in its entirety and 
 without modifications, you must retain this notice and the following 
 text and disclaimers in all such redistributions of the Apple Software. 
 Neither the name, trademarks, service marks or logos of Apple Inc. may 
 be used to endorse or promote products derived from the Apple Software 
 without specific prior written permission from Apple.  Except as 
 expressly stated in this notice, no other rights or licenses, express or 
 implied, are granted by Apple herein, including but not limited to any 
 patent rights that may be infringed by your derivative works or by other 
 works in which the Apple Software may be incorporated. 
  
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE 
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION 
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS 
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND 
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS. 
  
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL 
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, 
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED 
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), 
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE 
 POSSIBILITY OF SUCH DAMAGE. 
  
 Copyright (C) 2011 Apple Inc. All Rights Reserved. 
  
 */

#import "DragDropImageView.h"

@implementation DragDropImageView

NSString *kPrivateDragUTI = @"com.yourcompany.cocoadraganddrop";

- (id)initWithCoder:(NSCoder *)coder
{
    /*------------------------------------------------------
        Init method called for Interface Builder objects
    --------------------------------------------------------*/
    self=[super initWithCoder:coder];
    if ( self ) {
            //register for all the image types we can display
        // NSFilenamesPboardType,
        // pdf kUTTypeCompositeContent
//        NSArray *array = [NSArray arrayWithObjects:kUTTypeDirectory,kUTTypePlainText,kUTTypeCompositeContent,kUTTypeItem, nil];
        // 注册可以接收拖拽的文件类型
//        [self registerForDraggedTypes:[NSImage imageTypes]];
//        [self registerForDraggedTypes:array];
        [self registerForDraggedTypes:[NSArray arrayWithObject:NSCreateFilenamePboardType(@"php")]];
        self.allowDrag = NO;
        self.allowDrop = YES;
    }
    return self;
}

-(void)drawRect:(NSRect)rect
{
    /*------------------------------------------------------
     draw method is overridden to do drop highlighing
     --------------------------------------------------------*/
    //do the usual draw operation to display the image
    [super drawRect:rect];
    
    if ( highlight ) {
        //highlight by overlaying a gray border
        [[NSColor grayColor] set];
        [NSBezierPath setDefaultLineWidth: 5];
        [NSBezierPath strokeRect: rect];
    }
}
#pragma mark NSDraggingDestination
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingEntered");
    if (!self.allowDrop) {
        return NSDragOperationNone;
    }
    /*------------------------------------------------------
        method called whenever a drag enters our drop zone
     --------------------------------------------------------*/
    
            // Check if the pasteboard contains image data and source/user wants it copied
    // [NSImage canInitWithPasteboard:[sender draggingPasteboard]]  &&
    if (
        [sender draggingSourceOperationMask] &
        NSDragOperationCopy ) {
    
            //highlight our drop zone
        highlight=YES;
            
        [self setNeedsDisplay: YES];
    
            /* When an image from one window is dragged over another, we want to resize the dragging item to
             * preview the size of the image as it would appear if the user dropped it in. */
        // finder com.apple.finder.node
        [sender enumerateDraggingItemsWithOptions:NSDraggingItemEnumerationConcurrent 
            forView:self
            classes:[NSArray arrayWithObject:[NSPasteboardItem class]] 
            searchOptions:nil 
            usingBlock:^(NSDraggingItem *draggingItem, NSInteger idx, BOOL *stop) {
                
                    /* Only resize a fragging item if it originated from one of our windows.  To do this,
                     * we declare a custom UTI that will only be assigned to dragging items we created.  Here
                     * we check if the dragging item can represent our custom UTI.  If it can't we stop. */
                NSLog(@"rose show types:%@" , [[draggingItem item] types]);
                // kUTTypeDirectory
                if ( ![[[draggingItem item] types] containsObject:kPrivateDragUTI] ) {
                    *stop = YES;

                } else {
                        /* In order for the dragging item to actually resize, we have to reset its contents.
                         * The frame is going to be the destination view's bounds.  (Coordinates are local 
                         * to the destination view here).
                         * For the contents, we'll grab the old contents and use those again.  If you wanted
                         * to perform other modifications in addition to the resize you could do that here. */
                    [draggingItem setDraggingFrame:self.bounds contents:[[[draggingItem imageComponents] objectAtIndex:0] contents]];
                    NSLog(@"resize");
                    
                }
            }];
  
        //accept data as a copy operation
        return NSDragOperationCopy;
    }
    
    return NSDragOperationNone;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    NSLog(@"draggingExited");
    /*------------------------------------------------------
       method called whenever a drag exits our drop zone
    --------------------------------------------------------*/
        //remove highlight of the drop zone
    highlight=NO;
    
    [self setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    NSLog(@"prepareForDragOperation");
    /*------------------------------------------------------
        method to determine if we can accept the drop
    --------------------------------------------------------*/
        //finished with the drag so remove any highlighting
    highlight=NO;
    
    [self setNeedsDisplay: YES];
    
    BOOL canAccept = [NSImage canInitWithPasteboard:[sender draggingPasteboard]];
    if (canAccept) {
        NSLog(@"hahhahhhhhh");
    }
        //check to see if we can accept the data
//    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]];
    return YES;
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    NSLog(@"performDragOperation");
    /*------------------------------------------------------
        method that should handle the drop data
    --------------------------------------------------------*/
    if ( [sender draggingSource] != self ) {
        NSURL* fileURL;

            //set the image using the best representation we can get from the pasteboard
        if([NSImage canInitWithPasteboard: [sender draggingPasteboard]]) {
            NSImage *newImage = [[NSImage alloc] initWithPasteboard: [sender draggingPasteboard]];
            [self setImage:newImage];
        } else {
            NSImage *newImage = [NSImage imageNamed:@"drag"];
            [self setImage:newImage];
        }
        
        NSPasteboard *pboard = [sender draggingPasteboard];
        if ([[pboard types] containsObject:NSURLPboardType]) {
            // ....
        }
        
            //if the drag comes from a file, set the window title to the filename
        fileURL=[NSURL URLFromPasteboard: [sender draggingPasteboard]];
        [[self window] setTitle: fileURL!=NULL ? [fileURL lastPathComponent] : @"(no name)"];

        // m1 Block
        if (_dragDropBlock) {
            _dragDropBlock(fileURL);
        }
        // m2 Delegate
        if ([self.delegate respondsToSelector:@selector(dropEndWithPath:)]) {
            [self.delegate dropEndWithPath: [fileURL path]];
        }
    }
    
    return YES;
}


#pragma mark NSDraggingSource
- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    NSLog(@"draggingSession");
    /*------------------------------------------------------
     NSDraggingSource protocol method.  Returns the types of operations allowed in a certain context.
     --------------------------------------------------------*/
    switch (context) {
        case NSDraggingContextOutsideApplication:
            NSLog(@"NSDraggingContextOutsideApplication");
            return NSDragOperationCopy;
            
            //by using this fall through pattern, we will remain compatible if the contexts get more precise in the future.
        case NSDraggingContextWithinApplication:
        default:
            NSLog(@"NSDraggingContextWithinApplication");
            return NSDragOperationCopy;
            break;
    }
}

#pragma  mark NsSView
- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    /*------------------------------------------------------
     accept activation click as click in window
     --------------------------------------------------------*/
    //so source doesn't have to be the active window
    return YES;
}
- (void)mouseDown:(NSEvent*)event
{
    if (!self.allowDrag) {
        return;
    }
    NSLog(@"mouseDown");
    /*------------------------------------------------------
     catch mouse down events in order to start drag
     --------------------------------------------------------*/
    
    /* Dragging operation occur within the context of a special pasteboard (NSDragPboard).
     * All items written or read from a pasteboard must conform to NSPasteboardWriting or
     * NSPasteboardReading respectively.  NSPasteboardItem implements both these protocols
     * and is as a container for any object that can be serialized to NSData. */
    
    NSPasteboardItem *pbItem = [NSPasteboardItem new];
    /* Our pasteboard item will support public.tiff, public.pdf, and our custom UTI (see comment in -draggingEntered)
     * representations of our data (the image).  Rather than compute both of these representations now, promise that
     * we will provide either of these representations when asked.  When a receiver wants our data in one of the above
     * representations, we'll get a call to  the NSPasteboardItemDataProvider protocol method –pasteboard:item:provideDataForType:. */
    [pbItem setDataProvider:self forTypes:[NSArray arrayWithObjects:NSPasteboardTypeTIFF, NSPasteboardTypePDF, kPrivateDragUTI, nil]];
    
    //create a new NSDraggingItem with our pasteboard item.
    NSDraggingItem *dragItem = [[NSDraggingItem alloc] initWithPasteboardWriter:pbItem];
    
    /* The coordinates of the dragging frame are relative to our view.  Setting them to our view's bounds will cause the drag image
     * to be the same size as our view.  Alternatively, you can set the draggingFrame to an NSRect that is the size of the image in
     * the view but this can cause the dragged image to not line up with the mouse if the actual image is smaller than the size of the
     * our view. */
    NSRect draggingRect = self.bounds;
    
    /* While our dragging item is represented by an image, this image can be made up of multiple images which
     * are automatically composited together in painting order.  However, since we are only dragging a single
     * item composed of a single image, we can use the convince method below. For a more complex example
     * please see the MultiPhotoFrame sample. */
    [dragItem setDraggingFrame:draggingRect contents:[self image]];
    
    //create a dragging session with our drag item and ourself as the source.
    NSDraggingSession *draggingSession = [self beginDraggingSessionWithItems:[NSArray arrayWithObject:dragItem] event:event source:self];
    //causes the dragging item to slide back to the source if the drag fails.
    draggingSession.animatesToStartingPositionsOnCancelOrFail = YES;
    
    draggingSession.draggingFormation = NSDraggingFormationNone;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)window defaultFrame:(NSRect)newFrame;
{
    /*------------------------------------------------------
       delegate operation to set the standard window frame
    --------------------------------------------------------*/
        //get window frame size
    NSRect ContentRect=self.window.frame;
    
        //set it to the image frame size
    ContentRect.size=[[self image] size];
    
    return [NSWindow frameRectForContentRect:ContentRect styleMask: [window styleMask]];
};


#pragma mark NSPasteboardItemDataProvider
- (void)pasteboard:(NSPasteboard *)sender item:(NSPasteboardItem *)item provideDataForType:(NSString *)type
{
    NSLog(@"pasteboard");
    /*------------------------------------------------------
       	method called by pasteboard to support promised 
        drag types.
    --------------------------------------------------------*/
        //sender has accepted the drag and now we need to send the data for the type we promised
    if ( [type compare: NSPasteboardTypeTIFF] == NSOrderedSame ) {
        
            //set data for TIFF type on the pasteboard as requested
        [sender setData:[[self image] TIFFRepresentation] forType:NSPasteboardTypeTIFF];
        
    } else if ( [type compare: NSPasteboardTypePDF] == NSOrderedSame ) {
        
            //set data for PDF type on the pasteboard as requested
        [sender setData:[self dataWithPDFInsideRect:[self bounds]] forType:NSPasteboardTypePDF];
    }    
}
@end
