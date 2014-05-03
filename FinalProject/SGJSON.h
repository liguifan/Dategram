//
//  SGJSON.h
//  Assignment1
//
//  Created by bread on 4/14/14.
//  Copyright (c) 2014 Shuguan Yang. All rights reserved.
//

//Network interface: The word in the () is the key or key:value.
//
//1. register: (ID, name, gender, photourl, age, movies[], favorites[]) ——> respond:(OK);
//
//2. update:(ID, pushrecv[]: pushID) ——>respond:(OK/missedmatch[]: (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) ); Send when come back.
//
//3. friendlist:(ID) ——> respond:userself, friendlist[](ID, name gender, photourl, age, movies[], favorites[], rate, piechart[])  first one is for the user himself; Send when game finished.
//
//4. heartbeat:(ID, status{ online, offline, playing, pushrecv: pushID}) Send every 5s in normal mode——>respond:(OK/matchrequest: (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) );
//
//5. match:(ID, fliter); ——> respond:(ID, blurphoto, commoninterest, rate,piechart[] ); OR timeout
//
//6. gamemode:(ID, command, detail) Commandlist: {submit:answer, start:ID(mate’s), quit, nothing}  Send every second——> respond:(status, ID, blurphoto, gamepic, stage) status:{ success, fail, quit})
//Upon success, the document of the new connection’s info is append in the respond


#import <Foundation/Foundation.h>

@interface SGJSON : NSObject

+(void)dataReceived:(NSData *)data;
+(NSData *)JSONwrite:(NSDictionary *)data;
+(void)PostHttpRequestForUrl:(NSString*)url withData:(NSData*)data compeltionHandler:(void(^)(NSDictionary *respond, BOOL success))completion;
+(void)Downloadimg: (NSString*)url handler:(void(^)(UIImage* img))completion;

+(void)Register:(NSString*)ID withname:(NSString*)name withgender:(NSString*)gender withphotourl:(NSString*) photourl withage:(NSString*)age withmovies:(NSArray*)movies withfavorite:(NSArray*)favorites completionHandler:(void(^)(bool success))completion;

+(void)update:(NSString*) ID withpushrecv:(NSArray*) pushrecv completionHandler:(void(^)(NSArray* missedmatch))completion;

+(void)friendlist:(NSString*)ID withdevicetoken:(NSString*)devicetoken completionHandler:(void(^)(NSArray* friendlist, NSDictionary* userself))completion;

+(void)heartbeat:(NSString*)ID withstatus:(NSString*)status completionHandler:(void(^)(NSString* msg, NSDictionary* matchrequest, bool isrequest))completion;

+(void)match:(NSString*)ID withanswer:(NSString*) answer withfliter:(NSDictionary*)fliter completionHandler:(void(^)(NSDictionary* respond))completion;

+(void)gamemode:(NSString*)ID withcommand:(NSString*)command withdetail:(NSString*)detail completionHandler:(void(^)(NSDictionary* respond))completion;


@end
