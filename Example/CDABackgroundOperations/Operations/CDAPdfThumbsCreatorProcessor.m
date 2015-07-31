//
//  CDAPdfThumbsCreatorProcessor.m
//  CDABackgroundOperations
//
//  Created by Tamara Bernad on 31/07/15.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAPdfThumbsCreatorProcessor.h"
#import "CDAPdfThumbCreationTask.h"
#import "CDABGTaskData.h"

@implementation CDAPdfThumbsCreatorProcessor
- (NSOperation<CDABGTaskProtocol> *)createProcessWithData:(NSObject<CDABGTaskDataProtocol> *)processData{
    return [[CDAPdfThumbCreationTask alloc] initWithProcessData:processData];
}
- (void) cancelAllThumbConversionOperations{
    [self.pendingOperations.processesQueue cancelAllOperations];
}
- (void) suspendAllThumbConversionOperations{
    self.pendingOperations.processesQueue.suspended = true;
}
- (void) resumeAllThumbConversionOperations{
    self.pendingOperations.processesQueue.suspended = false;
}
- (void)processThumbsWithPageRefs:(NSArray *)pageRefs ThumbSize:(CGSize)thumbSize ScreenScale:(CGFloat)screenScale ForIndexPaths:(NSArray *)visiblePaths{
    
    NSArray *allPendingOperations = [self.pendingOperations.processesInProgress allKeys];
    
    NSMutableArray *toBeCancelled = [allPendingOperations copy];
    [toBeCancelled removeObjectsInArray:visiblePaths];
    
    NSMutableArray *toBeStarted = [visiblePaths copy];
    [toBeCancelled removeObjectsInArray:allPendingOperations];
    
    
    for (NSIndexPath *indexPath in toBeCancelled) {
        CDAPdfThumbCreationTask *pendingOp = self.pendingOperations.processesInProgress[indexPath];
        if (pendingOp) {
            [pendingOp cancel];
        }
        [self.pendingOperations.processesInProgress removeObjectForKey:indexPath];
    }
    
    for (int i=0;i<toBeStarted.count;i++){
        CDABGTaskData *processData = [[CDABGTaskData alloc] initWithName:@"Process pdf thumb"
                                                             AndUserInfo:@{@"page-ref":[pageRefs objectAtIndex:i],
                                                                           @"thumb-size": [NSValue valueWithCGSize:thumbSize],
                                                                           @"screen-scale":[NSNumber numberWithFloat:screenScale]}];
        
        [self startProcessForData:processData AndKey:[visiblePaths objectAtIndex:i]];
    }
}
@end
