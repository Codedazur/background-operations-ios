//
//  CDAPageRefFromImagePathsProcessor.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDABGTaskData.h"
#import "CDAAbstractBGTasksProcessor.h"

@protocol CDAProcessorDelegate;
@interface CDAPageRefFromImagePathsProcessor : CDAAbstractBGTasksProcessor
- (void)addJPGPaths:(NSArray *)jpgPaths AndDimension:(CGSize )dimension;
@end