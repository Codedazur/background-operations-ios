//
//  CDAProcessProtocol.h
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDABGTaskDataProtocol.h"

@protocol CDABGTaskProtocol <NSObject>
- (instancetype)initWithProcessData:(NSObject<CDABGTaskDataProtocol> *)processData;
@end
