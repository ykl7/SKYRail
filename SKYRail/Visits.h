//
//  Visits.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Visits : NSObject

@property (nonatomic) NSInteger trainId;
@property (nonatomic) NSInteger platformId;
@property (strong, nonatomic) NSString *depTime;
@property (strong, nonatomic) NSString *arrTime;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <Visits *> *)returnArrayFromJSONStructure:(id)json;

@end
