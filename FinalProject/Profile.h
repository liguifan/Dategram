//
//  Profile.h
//  FinalProject
//
//  Created by Cong Zhu on 4/28/14.
//  Copyright (c) 2014 COMS6998. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Profile : NSManagedObject

@property (nonatomic, retain) id pictureData;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * favorite_teams;
@property (nonatomic, retain) id favoritewithid;
@property (nonatomic, retain) NSString * favorite_athletes;
@property (nonatomic, retain) NSString * sports;
@property (nonatomic, retain) NSString * iD;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * photourl;
@property (nonatomic, retain) NSString * locale;
@property (nonatomic, retain) NSString * movies;
@property (nonatomic, retain) NSString * music;

@end
