//
//  LLResponseCacheUtil.m
//  LLNetworkingHelper
//
//  Created by 李龙 on 2017/8/28.
//  Copyright © 2017年 李龙. All rights reserved.
//


#import <pthread.h>
#import "LLResponseCacheUtil.h"
#import "YYCache.h"
#import "LxDBAnything.h"
#import "LLNetworkingHelperUtil.h"
#import "LLNetworkingHelperDefine.h"


//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ LLCacheMetadataModel ================
//-----------------------------------------------------------------------------------------------------------

@interface LLCacheMetadata : NSObject<NSSecureCoding>//NSSecureCoding

@property (nonatomic, strong) NSString *cacheMetadataKey;  //缓存 key
@property (nonatomic, assign) NSTimeInterval cacheStayTime; //缓存持久时间
@property (nonatomic, strong) NSDate* saveDate; //请求的缓存数据

@end

@implementation LLCacheMetadata


+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cacheMetadataKey forKey:NSStringFromSelector(@selector(cacheMetadataKey))];
    [aCoder encodeObject:@(self.cacheStayTime) forKey:NSStringFromSelector(@selector(cacheStayTime))];
    [aCoder encodeObject:self.saveDate forKey:NSStringFromSelector(@selector(saveDate))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [self init]) {
        self.cacheMetadataKey = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(cacheMetadataKey))];
        self.cacheStayTime = [[aDecoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(cacheStayTime))] doubleValue];
        self.saveDate = [aDecoder decodeObjectOfClass:[NSDate class] forKey:NSStringFromSelector(@selector(saveDate))];
        
    }
    return self;
}

@end


//#define Lock() dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER)
//#define PUnlock() dispatch_semaphore_signal(_lock)

#define PLock() pthread_mutex_lock(&_lock)
#define PUnlock() pthread_mutex_unlock(&_lock)

@implementation LLResponseCacheUtil

static NSString *const NetworkResponseCache = @"PPNetworkResponseCache";
static YYMemoryCache *_dataCache;
static NSString *_cacheKey;
static NSTimeInterval _ageTime;
static LLCacheMetadata *_cacheMetadata;
static NSTimeInterval const _defaultAgeTime = -1; //内存持续时间，默认-1，表示不需要缓存
pthread_mutex_t _lock;

+ (void)initialize {
    YYCache *cache = [YYCache cacheWithName:NetworkResponseCache];
    _dataCache = cache.memoryCache;
    _ageTime = _defaultAgeTime;
}

//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 接口 ================
//-----------------------------------------------------------------------------------------------------------

+ (void)ll_setHttpCache:(id)httpData
                    URL:(NSString *)URL
              cacheTime:(NSTimeInterval)cacheTime
             parameters:(NSDictionary *)parameters
{
    
    PLock();
    [self _setHttpCache:httpData URL:URL cacheTime:cacheTime parameters:parameters];
    PUnlock();
    
}

+ (id)ll_gethttpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    PLock();
    id httpCache =  [self _gethttpCacheForURL:URL parameters:parameters];
    PUnlock();
    return httpCache;
}

+ (void)ll_gethttpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block {
    PLock();
    [self _gethttpCacheForURL:URL parameters:parameters withBlock:block];
    PUnlock();
}



+ (NSString *)ll_cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    PLock();
    NSString * cacheKey = [self _cacheKeyWithURL:URL parameters:parameters];
    PUnlock();
    return cacheKey;
}



+ (void)ll_cachetime:(NSTimeInterval)time
{
    PLock();
    [self _cachetime:time];
    PUnlock();
}

+ (NSInteger)ll_getAllHttpCacheSize {
    PLock();
    NSInteger cacheSize =  [self _getAllHttpCacheSize];
    PUnlock();
    return cacheSize;
}

+ (void)ll_removeAllHttpCache {
    PLock();
    [self _removeAllHttpCache];
    PUnlock();
}



//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 实现方法 ================
//-----------------------------------------------------------------------------------------------------------
+ (void)_setHttpCache:(id)httpData
                  URL:(NSString *)URL
            cacheTime:(NSTimeInterval)cacheTime
           parameters:(NSDictionary *)parameters
{
    _cacheKey = [self ll_cacheKeyWithURL:URL parameters:parameters];
    LLLog(@"");
    LLLog(@"🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗 _setHttpCache beign ->%@ ",_cacheKey);
    //验证缓存是否有效
    BOOL isCacheValidly = [self checkHadSavedCache];
    if (isCacheValidly) {
        LLLog(@"🐳🐳🐳🐳🐳🐳🐳 缓存有效");
        LLLog(@"🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗 _setHttpCache end ->%@ ",_cacheKey);
        LLLog(@"");
        return;
    }
    
    
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 存储缓存以及更新配置文件信息");
    
    //存储缓存配置类
    [self _saveCacheMetadata:cacheTime];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self _saveCacheMetadata:cacheTime];
//    });
    
    
    //异步缓存,不会阻塞主线程
    [self ll_cachetime:cacheTime]; //设置YYCache缓存存活时间
    [_dataCache setObject:httpData forKey:_cacheKey];
    LLLog(@"🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗🚗 _setHttpCache end ->%@ ",_cacheKey);
    LLLog(@"");
}


+ (id)_gethttpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters
{
    _cacheKey = [self ll_cacheKeyWithURL:URL parameters:parameters];
    LLLog(@"");
    LLLog(@"🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚 _gethttpCacheForURL beign ->%@ ",_cacheKey);
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 cacheKey = %@",_cacheKey);
    
    //验证缓存是否有效
    BOOL isCacheValidly = [self checkCacheIsValid];
    if (!isCacheValidly) {
        LLLog(@"🐳🐳🐳🐳🐳🐳🐳 缓存无效,不从YYCache获取缓存");
        LLLog(@"🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚 _gethttpCacheForURL end ->%@ ",_cacheKey);
        LLLog(@"");
        return nil;
    }
    
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 存在缓存,开始获取到内存的缓存");
    LLLog(@"🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚🚚 _gethttpCacheForURL end ->%@ ",_cacheKey);
    LLLog(@"");
    return [_dataCache objectForKey:_cacheKey];
}

+ (void)_gethttpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block
{
    _cacheKey = [self ll_cacheKeyWithURL:URL parameters:parameters];
    LLLog(@"");
    LLLog(@"🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲 _gethttpCacheForURL二 beign ->%@ ",_cacheKey);
    id<NSCoding> object = [_dataCache objectForKey:_cacheKey];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            block(object);
            LLLog(@"🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲🚲 _gethttpCacheForURL二 end ->%@ ",_cacheKey);
            LLLog(@"");
        });
    });
}




+ (void)_cachetime:(NSTimeInterval)time
{
    LLLog(@"🐳🐳🐳🐳🐳🐳🐳 🐱🐱🐱🐱 🐱🐱🐱🐱 设置缓存时间  key:%@ <---------> _ageTime: %f", _cacheKey,time);
    _ageTime = time;
    [_dataCache trimToAge:time];
}

+ (NSInteger)_getAllHttpCacheSize {
    return [_dataCache totalCost];
}

+ (void)_removeAllHttpCache {
    [_dataCache removeAllObjects];
}




//验证缓是否保存过缓存
+ (BOOL)checkHadSavedCache
{
    //判断缓存配置是否存在
    BOOL isLoadCacheMetadataSuccess = [self _loadCacheMetadata];
    if (!isLoadCacheMetadataSuccess) {
        LLLog(@"✈️✈️✈️✈️✈️✈️存储-没有找到匹配的缓存配置类");
        return NO;
    }
    
    //判断缓存是否存在
    BOOL isHadContainCache = [_dataCache containsObjectForKey:_cacheKey];
    if (!isHadContainCache) {
        LLLog(@"✈️✈️✈️✈️✈️✈️存储-YYMemoneryCache不存在已经存储的key:%@",_cacheKey);
        return NO;
    }
    
    return YES;
}

//验证缓存是否有效
+ (BOOL)checkCacheIsValid
{
    //判断缓存配置是否存在
    BOOL isLoadCacheMetadataSuccess = [self _loadCacheMetadata];
    if (!isLoadCacheMetadataSuccess) {
        LLLog(@"✈️✈️✈️✈️✈️✈️获取-没有找到匹配的缓存配置类");
        return NO;
    }
    
    //判断缓存是否存在
    BOOL isHadContainCache = [_dataCache containsObjectForKey:_cacheKey];
    if (!isHadContainCache) {
        LLLog(@"✈️✈️✈️✈️✈️✈️获取-YYMemoneryCache不存在已经存储的key:%@",_cacheKey);
        return NO;
    }
    
    //判断缓存是否在有效期
    NSTimeInterval duration = - [_cacheMetadata.saveDate timeIntervalSinceNow]; //timeIntervalSinceNow 获取存储缓存的时间到目前的差值
    LLLog(@"✈️✈️✈️✈️✈️✈️        获取到该缓存-:%@",_cacheMetadata.saveDate);
    LLLog(@"✈️✈️✈️✈️✈️✈️获取到缓存，该缓存存在-:%f",duration);
    
    if (duration < 0 || duration > _cacheMetadata.cacheStayTime) {
        LLLog(@"✈️✈️✈️✈️✈️✈️获取-已经超过有效期缓存时间");
        [self _removeTimeOutCache];//清理过期掉缓存
        return NO;
    }
    
    return YES;
    
}




+ (void)_removeTimeOutCache
{
    [_dataCache removeObjectForKey:_cacheKey];
}


+ (BOOL)_saveCacheMetadata:(NSTimeInterval)cacheTime
{
    @try {
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 ------------------------  保存缓存数据信息开始  ------------------------");
        LLCacheMetadata *cacheMetadata = [LLCacheMetadata new];
        cacheMetadata.cacheMetadataKey = _cacheKey;
        cacheMetadata.cacheStayTime = cacheTime;
        cacheMetadata.saveDate = [NSDate date];
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 cacheMetadataKey:%@",cacheMetadata.cacheMetadataKey);
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 cacheStayTime:%f",cacheMetadata.cacheStayTime);
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 saveDate:%@",cacheMetadata.saveDate);
        
        BOOL isaveOk = [NSKeyedArchiver archiveRootObject:cacheMetadata toFile:[self _cacheMetadataFilePath]];
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 ------------------------  保存缓存数据结束  ------------------------");
        return isaveOk;
        
    } @catch (NSException *exception) {
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 Save cache failed, reason = %@", exception.reason);
        return NO;
    }
}

+ (BOOL)_loadCacheMetadata
{
    @try {
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 ------------------------  获取到缓存数据开始  ------------------------");
        _cacheMetadata = [NSKeyedUnarchiver unarchiveObjectWithFile:[self _cacheMetadataFilePath]];
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 cacheMetadataKey:%@",_cacheMetadata.cacheMetadataKey);
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 cacheStayTime:%f",_cacheMetadata.cacheStayTime);
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 ------------------------  获取缓存结束  ------------------------");
        return YES;
    } @catch (NSException *exception) {
        LLLog(@"✈️✈️✈️✈️✈️✈️ 🐓🐓🐓🐓🐓 Load cache metadata failed, reason = %@", exception.reason);
        return NO;
    }
    
    return NO;
    
}




//-----------------------------------------------------------------------------------------------------------
#pragma mark ================ 存储地址 ================
//-----------------------------------------------------------------------------------------------------------

+ (NSString *)_cacheMetadataFilePath {
    NSString *cacheMetadataFileName = [NSString stringWithFormat:@"%@.archiver", [self _cacheFileName]];
    NSString *path = [self _cacheBasePath];
    //    path = [path stringByAppendingPathComponent:@"history.archiver"];
    path = [path stringByAppendingPathComponent:cacheMetadataFileName];
    //    LxDBAnyVar(path);
    return path;
}

+ (NSString *)_cacheFileName {
    NSString *requestUrl = _cacheKey;
    return  [LLNetworkingHelperUtil md5StringFromString:requestUrl];
}


+ (NSString *)_cacheBasePath
{
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"LazyRequestCache"];
    return pathOfLibrary;
}



// 生成cache的key
+ (NSString *)_cacheKeyWithURL:(NSString *)URL parameters:(NSDictionary *)parameters {
    return [LLNetworkingHelperUtil getRequestURLWithURL:URL parameters:parameters];
}

@end
