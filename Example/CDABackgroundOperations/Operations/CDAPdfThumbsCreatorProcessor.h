//
//  CDAPdfThumbsCreatorProcessor.h
//  CDABackgroundOperations
//
//  Created by Tamara Bernad on 31/07/15.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDAAbstractBGTasksProcessor.h"

@interface CDAPdfThumbsCreatorProcessor : CDAAbstractBGTasksProcessor
- (void) cancelAllThumbConversionOperations;
- (void) suspendAllThumbConversionOperations;
- (void) resumeAllThumbConversionOperations;
- (void)processThumbsWithPageRefs:(NSArray *)pageRefs ThumbSize:(CGSize)thumbSize ScreenScale:(CGFloat)screenScale ForIndexPaths:(NSArray *)visiblePaths;
@end
