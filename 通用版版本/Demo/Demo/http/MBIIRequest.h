//
//  MBiiRequest.h
//  BOCMBCI
//
//  Created by Tracy E on 13-3-25.
//  Copyright (c) 2013年 China M-World Co.,Ltd. All rights reserved.
//
//  bii接口通讯类

#import <Foundation/Foundation.h>
#import "JSONKit.h"
#import "NSStringAdditions.h"



#define kBIIBaseURL   @""//投产BII地址


@interface MBRequestItem : NSObject

@property (nonatomic, copy) NSString *method;
@property (nonatomic, strong) NSDictionary *params;

+ (MBRequestItem *)itemWithMethod:(NSString *)method
                           params:(NSDictionary *)params;

@end



@interface MBIIRequest : NSObject

//通用通讯
+ (void)requestWithItems:(NSArray *)items
                 success:(void (^)(id JSON))success
                 failure:(void (^)(NSError *error, id JSON))failure;



//自定义通讯
//info keys:
#define MBRequest_ShowErrorAlert  @"MBRequestShowErrorAlert"    //@"yes" | @"no", default is @"yes".
#define MBRequest_ShowLoadingView @"MBRequestShowLoadingView"   //@"yes" | @"no", default is @"yes".
#define MBRequest_CanCancelRequest @"MBRequestCanCancelRequest" //@"yes" | @"no", default is @"yes".

+ (NSOperation *)requestWithItems:(NSArray *)items
                info:(NSDictionary *)info
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *, id))failure;

//新接口规范标准
/*
+ (void)newRequestWithItems:(NSArray *)items
                    success:(void (^)(id JSON))success
                    failure:(void (^)(NSError *error, id JSON))failure;
 */

+ (NSOperation *)requestXMLWithItems:(NSArray *)items
                             info:(NSDictionary *)info
                          success:(void (^)(id))success
                          failure:(void (^)(NSError *, id))failure;

+ (void)requestXMLWithItems:(NSArray *)items
                 success:(void (^)(id JSON))success
                 failure:(void (^)(NSError *error, id JSON))failure;

+ (void)requestXMLWithItemsAboutHost:(NSArray *)items
                    success:(void (^)(id JSON))success
                             failure:(void (^)(NSError *error, id JSON))failure;

+ (void)getValidationImageForView:(id)view withUrlStr:(NSString*)urlstr;

+(NSOperation *)requestAboutVisXMLWithItems:(NSArray *)items info:(NSDictionary *)info success:(void (^)(id))success failure:(void (^)(NSError *, id))failure;
+(void)requestAboutVisXMLWithItems:(NSArray *)items success:(void (^)(id))success failure:(void (^)(NSError *, id))failure;
+(NSOperation *)requestXMLWithItemsAboutHost:(NSArray *)items info:(NSDictionary *)info success:(void (^)(id))success failure:(void (^)(NSError *, id))failure;
+(void)requestXMLWithItemsPhone:(NSArray *)items success:(void (^)(id))success failure:(void (^)(NSError *, id))failure;
+(NSOperation *)requestXMLWithItemsAboutHostPHone:(NSArray *)items info:(NSDictionary *)info success:(void (^)(id))success failure:(void (^)(NSError *, id))failure;
@end
