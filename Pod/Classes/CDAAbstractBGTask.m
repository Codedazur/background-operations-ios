//
//  CDAAbstractProcess.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAAbstractBGTask.h"
#import "CDABGTaskDataProtocol.h"
@interface CDAAbstractBGTask()
@end
@implementation CDAAbstractBGTask
- (void)dealloc{
    _processData = nil;
}
- (instancetype)initWithProcessData:(NSObject<CDABGTaskDataProtocol> *)processData{
    if(!(self = [super init]))return nil;
    _processData = processData;
    return self;
}
- (void)setResult:(NSObject *)result{
    self.processData.result = result;
}
@end
