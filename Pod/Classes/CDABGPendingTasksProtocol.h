//
//  CDAProcessesPendingOperationProtocol.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CDABGPendingTasksProtocol <NSObject>
@property (nonatomic, strong)NSMutableDictionary *processesInProgress;
@property (nonatomic, strong)NSOperationQueue *processesQueue;
@end
