//
//  DBManager.m
//  SKYRail
//
//  Created by YASH on 18/04/16.
//  Copyright © 2016 YASH. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@property (nonatomic, strong) FMDatabaseQueue *dbqueue;
@property (nonatomic, strong) FMDatabase *database;

@end

@implementation DBManager

- (instancetype)initWithDatabasePath:(NSString *)path
{
    
    self = [super init];
    
    if (self)
    {
        self.database = [FMDatabase databaseWithPath:path];
        self.dbqueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    
    return self;
}

- (void)dbManagerOpenDatabaseWithPath:(NSString *)path
{
    
    self.database = [FMDatabase databaseWithPath:path];
    self.dbqueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    if (![self.database open])
    {
        NSLog(@"Database Opening Error");
    }
    
}

- (void)dbManagerCloseDatabase
{
    
    if (![self.database close])
    {
        NSLog(@"Database Closing Error");
    }
    [self.dbqueue close];
    
}

- (id)dbExecuteQuery:(NSString *)query error:(NSError *__autoreleasing *)error {
    
    NSMutableArray *columnNames = [NSMutableArray new];
    NSMutableArray *results = [NSMutableArray new];
    
    [self.dbqueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *fmrset = [db executeQuery:query values:nil error:error];
        
        for (int i = 0; i < [fmrset columnCount]; ++i) {
            
            NSString *cname = [fmrset columnNameForIndex:i];
            
            [columnNames addObject:[NSString stringWithFormat:@"%@", cname]];
            
        }
        
        while ([fmrset next]) {
            
            NSMutableDictionary *dict = [NSMutableDictionary new];
            
            for (NSString *cname in columnNames)
                [dict setObject:[fmrset objectForColumnName:cname] forKey:cname];
            
            [results addObject:dict];
            
        }
        
    }];
    
    return results;
}

- (BOOL)dbExecuteUpdate:(NSString *)query error:(NSError *__autoreleasing *)error {
    
    __block BOOL success = YES;
    
    [self.dbqueue inDatabase:^(FMDatabase *db) {
        
        if (![db executeUpdate:query values:nil error:error])
            success = NO;
        
    }];
    
    return success;
    
}

+ (DBManager *)sharedManager
{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

@end
