//
//  CDAProcessDataProtocol.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum
{
    CDAProcessDataCreationStateNew = 0,
    CDAProcessDataFinished,
    CDAProcessDataFailed
} CDAProcessDataState;

@protocol CDABGTaskDataProtocol <NSObject>
@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSObject *result;
@property (nonatomic) NSDictionary *userInfo;
@property (nonatomic) CDAProcessDataState state;
- (instancetype)initWithName:(NSString *)name AndUserInfo:(NSDictionary*) userInfo;
@end
