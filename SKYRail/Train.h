//
//  Train.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject

@property (strong, nonatomic) NSString *trainName;
@property (nonatomic) NSInteger trainId;
@property (nonatomic) NSInteger capacity;
@property (nonatomic) NSInteger startPid;
@property (nonatomic) NSInteger endPid;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <Train *> *)returnArrayFromJSONStructure:(id)json;

@end
