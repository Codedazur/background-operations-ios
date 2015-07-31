//
//  CDAPdfThumbCreationTask.m
//  CDABackgroundOperations
//
//  Created by Tamara Bernad on 31/07/15.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAPdfThumbCreationTask.h"

@implementation CDAPdfThumbCreationTask
- (void)main{
    if (self.cancelled) {
        return;
    }
    
    CGSize size = [[self.processData.userInfo valueForKey:@"thumb-size"] CGSizeValue];
    CGPDFPageRef page = (__bridge CGPDFPageRef)[self.processData.userInfo valueForKey:@"page-ref"];
    CGFloat screenScale = [[self.processData.userInfo valueForKey:@"screen-scale"] floatValue];
    
    CGFloat thumb_w = size.width; // Maximum thumb width
    CGFloat thumb_h = size.height; // Maximum thumb height
    
    CGRect cropBoxRect = CGPDFPageGetBoxRect(page, kCGPDFCropBox);
    CGRect mediaBoxRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGRect effectiveRect = CGRectIntersection(cropBoxRect, mediaBoxRect);
    
    NSInteger pageRotate = CGPDFPageGetRotationAngle(page); // Angle
    
    CGFloat page_w = 0.0f; CGFloat page_h = 0.0f; // Rotated page size
    
    switch (pageRotate) // Page rotation (in degrees)
    {
        default: // Default case
        case 0: case 180: // 0 and 180 degrees
        {
            page_w = effectiveRect.size.width;
            page_h = effectiveRect.size.height;
            break;
        }
            
        case 90: case 270: // 90 and 270 degrees
        {
            page_h = effectiveRect.size.width;
            page_w = effectiveRect.size.height;
            break;
        }
    }
    
    CGFloat scale_w = (thumb_w / page_w); // Width scale
    CGFloat scale_h = (thumb_h / page_h); // Height scale
    
    CGFloat scale = 0.0f; // Page to target thumb size scale
    
    if (page_h > page_w)
        scale = ((thumb_h > thumb_w) ? scale_w : scale_h); // Portrait
    else
        scale = ((thumb_h < thumb_w) ? scale_h : scale_w); // Landscape
    
    NSInteger target_w = (page_w * scale); // Integer target thumb width
    NSInteger target_h = (page_h * scale); // Integer target thumb height
    
    if (target_w % 2) target_w--; if (target_h % 2) target_h--; // Even
    
    target_w *= screenScale; target_h *= screenScale; // Screen scale
    CGSize targetThumbSize = CGSizeMake(target_w, target_h);
    
    UIGraphicsBeginImageContextWithOptions(targetThumbSize, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect pageRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, targetThumbSize.height);
    CGContextScaleCTM(context, targetThumbSize.width / pageRect.size.width, - targetThumbSize.height / pageRect.size.height);
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextFillEllipseInRect(context, CGRectMake(0, 0, targetThumbSize.width, targetThumbSize.height));
    CGContextDrawPDFPage(context, page);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self setResult:image];
}

@end
