//
//  CDAProcessProcessor.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractBGTasksProcessor.h"
#import "CDABGTaskDataProtocol.h"
#import "CDABGTaskProtocol.h"
#import "CDAExceptionUtils.h"
#import "CDABGPendingTasks.h"

@implementation CDAAbstractBGTasksProcessor
@synthesize delegate = _delegate, processesDatas = _processesDatas, pendingOperations = _pendingOperations;
- (NSArray *)processesDatas{
    if(!_processesDatas){
        _processesDatas = [NSArray new];
    }
    return _processesDatas;
}
- (NSObject<CDABGPendingTasksProtocol> *)pendingOperations{
    if(!_pendingOperations){
        _pendingOperations  =[[CDABGPendingTasks alloc] init];
    }
    return _pendingOperations;
}
- (NSOperation<CDABGTaskProtocol> *)createProcessWithData:(NSObject<CDABGTaskDataProtocol> *)processData{
    [CDAExceptionUtils throwOverrideExceptionWithMethodName:NSStringFromSelector(_cmd)];
    return nil;
}
- (void)startProcessForData:(NSObject<CDABGTaskDataProtocol> *)processData AndKey:(id <NSCopying>)key{
    NSOperation<CDABGTaskProtocol> *operation = self.pendingOperations.processesInProgress[key];
    if (operation)return;
    
    operation = [self createProcessWithData:processData];
    NSOperation<CDABGTaskProtocol> __weak *weakOperation = operation;
    NSObject<CDABGTasksProcessorProtocol> __weak *weakSelf = self;
    
    [operation setCompletionBlock:^{
        if (weakOperation.cancelled)return;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.pendingOperations.processesInProgress removeObjectForKey:key];
            [weakSelf.delegate CDABGTasksProcessor:self DidFinishWithProcessData:processData AndKey:key];
        });
    }];
    [self.pendingOperations.processesInProgress setObject:operation forKey:key];
    [self.pendingOperations.processesQueue addOperation:operation];
}
@end
