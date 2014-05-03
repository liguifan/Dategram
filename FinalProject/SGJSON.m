//
//  SGJSON.m
//  Assignment1
//
//  Created by bread on 4/14/14.
//  Copyright (c) 2014 Shuguan Yang. All rights reserved.
//
//Network interface: The word in the () is the key or key:value.
//
//1. register: (ID, name, gender, photourl, age, movies[], favorites[]) ——> respond:(OK);
//
//2. update:(ID, pushrecv[]: pushID) ——>respond:(OK, missedmatch[]: (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) ); Send after the first heartbeat when come back.
//
//3. friendlist:(ID) ——> respond:userself, friendlist[](ID, name gender, photourl, age, movies[], favorites[], rate, piechart[])  first one is for the user himself; Send when game finished.
//
//4. heartbeat:(ID, status{ online, offline, playing, pushrecv: pushID}) Send every 4s in normal mode——>respond:(OK:{enter; quit; nothing;}, matchrequest(optional): (ID, name, gender,  age, blurphoto, common, rate,piechart[] ) );
//
//5. match:(ID, answer:ID/quit, fliter); ——> respond:(OK:enter, quit, wait) (ID, blurphoto, commoninterest, rate,piechart[] );
//
//6. gamemode:(ID, command, detail) Commandlist: {submit:answer, quit, nothing, wait}  Send every second——> respond:(status, ID, blurphoto, gamepic, stage) status:{continue, wait, success, fail, quit})
//Upon success, the document of the new connection’s info is append in the respond
#import "SGJSON.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#define GOOGLE_API @"AIzaSyDgJnx2d155hyZWyikVFT7K8TcWfvHJVBI"// My API is defined here
#define server @"http://liguifan-v4x52xpc98.elasticbeanstalk.com/HTTPhandler"

@implementation SGJSON

+(void)Register:(NSString*)ID withname:(NSString*)name withgender:(NSString*)gender withphotourl:(NSString*) photourl withage:(NSString*)age withmovies:(NSArray*)movies withfavorite:(NSArray*)favorites completionHandler:(void(^)(bool success))completion{
    
    NSMutableDictionary *regist = [[NSMutableDictionary alloc] init];
    [regist setValue:ID forKey:@"ID"];
    [regist setValue:name forKey:@"name"];
    [regist setValue:gender forKey:@"gender"];
    [regist setValue:photourl forKey:@"photourl"];
    [regist setValue:age forKey:@"age"];
    [regist setValue:movies forKey:@"movies"];
    [regist setValue:favorites forKey:@"favorites"];
    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:regist forKey:@"register"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    //    NSLog(jsonData);
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        bool result = false;
        if(success){
            NSString *temp =respond.allKeys[0];
            if([temp isEqualToString:@"OK"]){
                result = true;
                NSString *fuck = [respond objectForKey:@"OK"];}
        }
        completion(result);
    }];
}

+(void)update:(NSString*) ID withpushrecv:(NSArray*) pushrecv completionHandler:(void(^)(NSArray* missedmatch))completion{
    
    NSMutableDictionary *update = [[NSMutableDictionary alloc] init];
    [update setValue:ID forKey:@"ID"];
    [update setValue:pushrecv forKey:@"pushrecv"];
    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:update forKey:@"update"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        if(success){
            NSArray *missedmatch = [respond objectForKey:@"missedmatch"];
            completion(missedmatch);//return the list of missedmatch, need to check if this is empty;
            if(missedmatch.count == 0){NSLog(@"missedmatch list is empty");}
        }
    }];
}

+(void)friendlist:(NSString*)ID withdevicetoken:(NSString*)devicetoken completionHandler:(void(^)(NSArray* friendlist, NSDictionary* userself))completion{

    NSMutableDictionary *friendlist = [[NSMutableDictionary alloc] init];
    [friendlist setValue:ID forKey:@"ID"];
    [friendlist setValue:devicetoken forKey:@"devicetoken"];
    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:friendlist forKey:@"friendlist"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        if(success){
            NSArray *friendlist = [respond objectForKey:@"friendlist"];
            NSDictionary* userself = [respond objectForKey:@"userself"];
            completion(friendlist, userself);//return the list of missedmatch, need to check if this is empty;
        }
    }];
}

+(void)heartbeat:(NSString*)ID withstatus:(NSString*)status completionHandler:(void(^)(NSString* respond, NSDictionary* matchrequest, bool isrequest))completion{
   
    NSMutableDictionary *heartbeat = [[NSMutableDictionary alloc] init];
    [heartbeat setValue:ID forKey:@"ID"];
    [heartbeat setValue:status forKey:@"status"];

    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:heartbeat forKey:@"heartbeat"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        if(success){
            NSString* msg = [respond objectForKey:@"OK"];
            NSLog(@"%@",msg);
            if(![msg isEqualToString:@"nothing"]){
            NSDictionary *matchrequest = [respond objectForKey:@"matchrequest"];
            completion(msg, matchrequest, 1);//there is a matchrequest
            }
            else {
                NSDictionary* nothing = [[NSDictionary alloc]init];
                completion(msg, nothing, 0);//no matchrequest
            }
        }
    }];

}

+(void)match:(NSString*)ID withanswer:(NSString*) answer withfliter:(NSDictionary*)fliter completionHandler:(void(^)(NSDictionary* respond))completion{
    
    NSMutableDictionary *match = [[NSMutableDictionary alloc] init];
    [match setValue:ID forKey:@"ID"];
    [match setValue:answer forKey:@"answer"];
    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:match forKey:@"match"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        if(success){
            NSLog(@"%@",[respond objectForKey:@"OK"]);
            if([[respond objectForKey:@"OK"] isEqualToString:@"wait"]){
                NSLog(@"wait mate to respond");
            }
            else if([[respond objectForKey:@"OK"] isEqualToString:@"enter"]){NSLog(@"enter the game");}
            else if([[respond objectForKey:@"OK"] isEqualToString:@"quit"]){NSLog(@"mate quitted");}

            completion(respond);
        }
    }];

}

+(void)gamemode:(NSString*)ID withcommand:(NSString*)command withdetail:(NSString*)detail completionHandler:(void(^)(NSDictionary* respond))completion{
    NSMutableDictionary *gamemode = [[NSMutableDictionary alloc] init];
    [gamemode setValue:ID forKey:@"ID"];
    [gamemode setValue:command forKey:@"command"];
    [gamemode setValue:detail forKey:@"detail"];
    NSMutableDictionary *all = [[NSMutableDictionary alloc] init];
    [all setValue:gamemode forKey:@"gamemode"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error:&e];
    [self PostHttpRequestForUrl:server withData:jsonData compeltionHandler:^(NSDictionary *respond, BOOL success){
        if(success){
            NSLog(@"%@",[respond objectForKey:@"status"]);
    }
        completion(respond);
     }];

}

+(void)PostHttpRequestForUrl:(NSString*)url withData:(NSData*)data compeltionHandler:(void (^)(NSDictionary *respond, BOOL success)) completion
{
    
    NSString *length = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:length forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSString *errcode = [error localizedDescription];
        NSError *e = nil;
        BOOL success = true;
        NSDictionary *recev = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        NSDictionary * json  = [recev valueForKey:@"respond"];
        if (!json) {
            NSLog(@"Error parsing JSON: %@", e);
            NSString *wrong = (NSString *)data;
            NSLog(@"%@", errcode);
            success = false;
        } else {
            success = true;
        }
        
        completion(json, success);// check if return value is json and check if is "respond"
        
        if (error) {
            //  [self.delegate fetchingGroupsFailedWithError:error];
        } else {        }
    }];
    
}

+(void)Downloadimg: (NSString*)url handler:(void(^)(UIImage* img))completion{
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {if (error) {NSLog(@"Fail to download img");}
         else {
             UIImage *image=[UIImage imageWithData:data];
             completion(image);
         } }];
    
}




+(void)dataReceived:(NSData *)data
{
    NSError *e = nil;
    //    NSArray *list;
    NSDictionary *jsonall = [NSJSONSerialization JSONObjectWithData: data options: kNilOptions error: &e];
    NSDictionary * json  = [jsonall valueForKey:@"respond"];
    if (!json) {
        NSLog(@"Error parsing JSON: %@", e);
        NSString *wrong = (NSString *)data;
        NSLog(@"Error code: %@" , wrong);
        
    } else {
        // list = [json objectForKey:@"twitter"];
        
    }
    
    for(NSString *key in json.allKeys) {
        
        if ([[json objectForKey:key] isKindOfClass:[NSDictionary class]]){
            NSDictionary* tempdic = [json objectForKey:key];
            for(NSString *tempkey in tempdic.allKeys) {
                NSLog(@"Item: %@", [tempdic objectForKey:tempkey]);
            }
        }
        else NSLog(@"Answer: %@", [json objectForKey:key]);
    }
}

+ (NSData *)JSONwrite:(NSDictionary *)data{
    NSMutableDictionary *jsonall = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *jsonall1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *subdic = [[NSMutableDictionary alloc] init];
    [subdic setValue:@"hello1val" forKey:@"hello1"];
    [subdic setValue:@"hello2val" forKey:@"hello2"];
    [subdic setValue:@"hello3val" forKey:@"hello3"];
    [jsonall setValue:subdic forKey:@"request"];
    [jsonall setValue:@"123123123" forKey:@"ID"];
    [jsonall1 setValue:jsonall forKey:@"test"];
    NSError *e;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonall1 options:NSJSONWritingPrettyPrinted error:&e];
    return jsonData;
}
@end
