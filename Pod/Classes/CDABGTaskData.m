//
//  CDAProcessData.m
//  KvadratIpadApp
//
//  Created by Tamara Bernad on 28/07/15.
//  Copyright (c) 2015 Code d'Azur. All rights reserved.
//

#import "CDABGTaskData.h"

@implementation CDABGTaskData
@synthesize name = _name, result = _result, userInfo = _userInfo, state = _state;

- (instancetype)initWithName:(NSString *)name AndUserInfo:(NSDictionary *)userInfo{
    if(!(self = [super init]))return nil;
    self.name = name;
    self.userInfo = userInfo;
    return self;
}
@end
