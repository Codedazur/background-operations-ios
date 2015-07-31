//
//  CDAProcessesPendinOperations.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABGPendingTasks.h"

@implementation CDABGPendingTasks
@synthesize processesInProgress = _processesInProgress, processesQueue = _processesQueue;
- (instancetype)init{
    if(!(self = [super init]))return nil;
    self.processesQueue = [[NSOperationQueue alloc] init];
    self.processesQueue.name = NSStringFromClass([CDABGPendingTasks class]);
    return self;
}
@end
