//
//  BookingHistory.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookingHistory : NSObject

@property (nonatomic) NSInteger personId;
@property (strong, nonatomic) NSNumber *PNR;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <BookingHistory *> *)returnArrayFromJSONStructure:(id)json;

@end
