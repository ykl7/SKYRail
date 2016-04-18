//
//  CancelledTickets.h
//  SKYRail
//
//  Created by YASH on 19/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CancelledTickets : NSObject

@property (strong, nonatomic) NSNumber *PNR;
@property (nonatomic) NSInteger trainId;
@property (strong, nonatomic) NSNumber *distance;
@property (strong, nonatomic) NSString *dateOfJourney;
@property (nonatomic) NSInteger startPid;
@property (nonatomic) NSInteger endPid;
@property (nonatomic) NSInteger personId;
@property (strong, nonatomic) NSString *cancelTime;

- (instancetype)initWithDict:(id)dict;

+ (NSMutableArray <CancelledTickets *> *)returnArrayFromJSONStructure:(id)json;

@end
