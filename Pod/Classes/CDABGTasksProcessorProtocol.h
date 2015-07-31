//
//  CDAPorcessProcessorProtocol.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDABGTaskDataProtocol.h"
#import "CDABGPendingTasksProtocol.h"
@protocol CDABGTasksProcessorDelegate;

@protocol CDABGTasksProcessorProtocol <NSObject>
@property (nonatomic, weak) NSObject<CDABGTasksProcessorDelegate> *delegate;
@property (nonatomic, strong) NSObject<CDABGPendingTasksProtocol> *pendingOperations;
@property (nonatomic, strong) NSArray *processesDatas;
@end
@protocol CDABGTasksProcessorDelegate <NSObject>
- (void)CDABGTasksProcessor:(NSObject<CDABGTasksProcessorProtocol> *)processor DidFinishWithProcessData:(NSObject<CDABGTaskDataProtocol> *)processData AndKey:(id <NSCopying>)key;
@end