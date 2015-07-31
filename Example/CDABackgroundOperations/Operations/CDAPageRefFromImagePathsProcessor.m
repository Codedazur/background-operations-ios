//
//  CDAPageRefFromImagePathsProcessor.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAPageRefFromImagePathsProcessor.h"
#import "CDABGTaskData.h"
#import "CDAPageRefFromImagePaths.h"
@interface CDAPageRefFromImagePathsProcessor()
@end
@implementation CDAPageRefFromImagePathsProcessor
- (NSOperation<CDABGTaskProtocol> *)createProcessWithData:(NSObject<CDABGTaskDataProtocol> *)processData{
    return [[CDAPageRefFromImagePaths alloc] initWithProcessData:processData];
}
- (void)addJPGPaths:(NSArray *)jpgPaths AndDimension:(CGSize )dimension{
    CDABGTaskData *processData = [[CDABGTaskData alloc] initWithName:@"Process jpgs" AndUserInfo:@{@"image-paths":[jpgPaths copy], @"dimensions": [NSValue valueWithCGSize:dimension]}];
    self.processesDatas = [[self processesDatas] arrayByAddingObject:processData];
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    [self startProcessForData:processData AndKey:timestamp];
}
@end
