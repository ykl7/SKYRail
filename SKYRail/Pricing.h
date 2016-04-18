//
//  Pricing.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pricing : NSObject

@property (nonatomic) NSInteger trainId;
@property (strong, nonatomic) NSNumber *baseFare;
@property (strong, nonatomic) NSNumber *costPerKm;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <Pricing *> *)returnArrayFromJSONStructure:(id)json;

@end
