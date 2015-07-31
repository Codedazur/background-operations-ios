//
//  CDAPageRefFromImagePaths.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDAPageRefFromImagePaths.h"
#import "CDABGTaskData.h"
@interface CDAPageRefFromImagePaths()
@end
@implementation CDAPageRefFromImagePaths
- (void)main{
    if (self.cancelled) {
        return;
    }
    
    CGSize dimensions = [[self.processData.userInfo valueForKey:@"dimensions"] CGSizeValue];
    NSArray *imagePaths = [self.processData.userInfo valueForKey:@"image-paths"];
    
    NSMutableData *pdfData = [NSMutableData data];
    CGRect dinA4Bounds = CGRectMake(0, 0, dimensions.width, dimensions.height);
    UIGraphicsBeginPDFContextToData(pdfData, dinA4Bounds, nil);
    CGContextRef pdfContext=UIGraphicsGetCurrentContext();
    
    for(NSString *path in imagePaths){
        UIGraphicsBeginPDFPage();
        CGContextSaveGState(pdfContext);
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [image drawInRect:dinA4Bounds];
        CGContextRestoreGState(pdfContext);
        if (self.cancelled) {
            UIGraphicsEndPDFContext();
            return;
        }
    }
    UIGraphicsEndPDFContext();
    
    if (self.cancelled) {
        return;
    }
    NSData *pdfD = [NSData dataWithData:pdfData];
    CFDataRef myPDFData = (__bridge CFDataRef)pdfD;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
    
    int numbOfPages = CGPDFDocumentGetNumberOfPages(pdf);
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:numbOfPages];
    for (NSInteger i = 1; i <= numbOfPages; i++) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(pdf, i);
        [tempPages addObject:(__bridge id)(pageRef)];
    }
    [self setResult:[NSArray arrayWithArray:tempPages]];
    CGDataProviderRelease(provider);
    CGPDFDocumentRelease(pdf);
}

@end
