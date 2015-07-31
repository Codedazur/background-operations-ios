//
//  CDAViewController.m
//  CDABackgroundOperations
//
//  Created by tamarabernad on 07/31/2015.
//  Copyright (c) 2015 tamarabernad. All rights reserved.
//

#import "CDAViewController.h"
#import "CDAPdfThumbsCreatorProcessor.h"
#import "CDACollectionViewCell.h"

@interface CDAViewController ()<CDABGTasksProcessorDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) CDAPdfThumbsCreatorProcessor *thumbsCreationProcessor;
@property (nonatomic, strong) NSArray *pdfPages;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation CDAViewController

- (CDAPdfThumbsCreatorProcessor *)thumbsCreationProcessor{
    if(!_thumbsCreationProcessor){
        _thumbsCreationProcessor = [CDAPdfThumbsCreatorProcessor new];
        _thumbsCreationProcessor.delegate = self;
    }
    return _thumbsCreationProcessor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([CDACollectionViewCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass([CDACollectionViewCell class])];
    
    [self createPageRefsFromPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"]];
    self.images = [NSMutableArray new];
    for(int i=0;i<self.pdfPages.count;i++){
        [self.images addObject:[NSNull null]];
    }
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
	// Do any additional setup after loading the view, typically from a nib.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.pdfPages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CDACollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CDACollectionViewCell class]) forIndexPath:indexPath];
    UIImage *img = [self.images objectAtIndex:indexPath.row];
    img = [img isEqual:[NSNull null]] ? nil : img;
    if(!img){
        [self.thumbsCreationProcessor processThumbsWithPageRefs:@[[self.pdfPages objectAtIndex:indexPath.row]] ThumbSize:CGSizeMake(100, 100) ScreenScale:1.0 ForIndexPaths:@[indexPath]];
    }
    cell.imgView.image = img;
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.thumbsCreationProcessor suspendAllThumbConversionOperations];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self loadThumbsForOnscreenCells];
        [self.thumbsCreationProcessor resumeAllThumbConversionOperations];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadThumbsForOnscreenCells];
    [self.thumbsCreationProcessor resumeAllThumbConversionOperations];
}

#pragma mark - Helpers
- (void)loadThumbsForOnscreenCells{
    NSArray *indexPaths = [self.collectionView indexPathsForVisibleItems];
    NSMutableArray *pageRefs = [NSMutableArray new];
    for(NSIndexPath *indexPath in indexPaths){
        [pageRefs addObject:[self.pdfPages objectAtIndex:indexPath.row]];
    }
    [self.thumbsCreationProcessor processThumbsWithPageRefs:pageRefs ThumbSize:CGSizeMake(100, 100) ScreenScale:1.0 ForIndexPaths:indexPaths];
}

- (id) createPageRefsFromPath:(NSString *) pdfPath {
    
    if (!pdfPath || pdfPath.length == 0) {
#ifdef DEBUG
        [NSException raise:NSGenericException format:@"%@ - Document path can't be a nil or empty string", NSStringFromClass([self class])];
#endif
        NSLog(@"ERROR!!! %@ - Document path can't be a nil or empty string", NSStringFromClass([self class]));
        return nil;
    }
    
    const char *filepath = [pdfPath cStringUsingEncoding:NSASCIIStringEncoding];
    CFStringRef path = CFStringCreateWithCString(NULL, filepath, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, 0);
    
    CFRelease(path);
    
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    if (document == NULL) {
#ifdef DEBUG
        [NSException raise:NSGenericException format:@"%@ - Invalid PDF document: there is no document at %@", NSStringFromClass([self class]),  pdfPath];
#endif
        NSLog(@"ERROR!!! %@ - Invalid PDF document: there is no document at %@", NSStringFromClass([self class]), pdfPath);
        CGPDFDocumentRelease(document);
        return nil;
    }
    
    int numberOfPages = CGPDFDocumentGetNumberOfPages(document);
    
    NSMutableArray *tempPages = [NSMutableArray arrayWithCapacity:numberOfPages];
    for (NSInteger i = 1; i <= numberOfPages; i++) {
        CGPDFPageRef pageRef = CGPDFDocumentGetPage(document, i);
        [tempPages addObject:(__bridge id)(pageRef)];
    }
    
    self.pdfPages = tempPages;
    
    CGPDFDocumentRelease(document);
    
    return self;
}

#pragma mark - CDAProcessorDelegate
- (void)CDABGTasksProcessor:(NSObject<CDABGTasksProcessorProtocol> *)processor DidFinishWithProcessData:(NSObject<CDABGTaskDataProtocol> *)processData AndKey:(id <NSCopying>)key{
    NSIndexPath *indexPath = (NSIndexPath *)key;
    [self.images replaceObjectAtIndex:indexPath.row withObject:processData.result];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//    [self.viewModel addPdfPageRefs:(NSArray *)processData.result];
//    [self.thumbsLoader cancelAllThumbConversionOperations];
//    [self.collectionView reloadData];
}
@end
