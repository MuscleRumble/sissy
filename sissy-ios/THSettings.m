//
//  THSettings.m
//  sissy
//
//  Created by Tobias Hagemann on 22/05/15.
//  Copyright (c) 2015 tobiha.de. All rights reserved.
//

#import "THSettings.h"

#import <FXKeychain/FXKeychain.h>
#import "GVUserDefaults+THSettings.h"

NSString *const kTHSettingsLastFetchDateKey = @"lastFetchDate";
NSString *const kTHSettingsFetchNewGradeResultsSettingKey = @"fetchNewGradeResultsSetting";
NSString *const kTHSettingsUsernameKey = @"username";
NSString *const kTHSettingsPasswordKey = @"password";
NSString *const kTHSettingsLoggedInKey = @"loggedIn";

NSTimeInterval const kSETOSettingsFetchNewGradeResultsEvery15Minutes = 900.0;
NSTimeInterval const kSETOSettingsFetchNewGradeResultsEvery30Minutes = 1800.0;
NSTimeInterval const kSETOSettingsFetchNewGradeResultsHourly = 3600.0;

@implementation THSettings

+ (instancetype)sharedInstance {
	static THSettings *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[THSettings alloc] init];
	});
	return sharedInstance;
}

- (NSDate *)lastFetchDate {
	return [GVUserDefaults standardUserDefaults].lastFetchDate;
}

- (void)setLastFetchDate:(NSDate *)lastFetchDate {
	[GVUserDefaults standardUserDefaults].lastFetchDate = lastFetchDate;
}

- (THFetchNewGradeResultsOption)fetchNewGradeResultsSetting {
	return [GVUserDefaults standardUserDefaults].fetchNewGradeResultsSetting;
}

- (void)setFetchNewGradeResultsSetting:(THFetchNewGradeResultsOption)fetchNewGradeResultsSetting {
	[GVUserDefaults standardUserDefaults].fetchNewGradeResultsSetting = fetchNewGradeResultsSetting;
}

- (NSString *)username {
	return [GVUserDefaults standardUserDefaults].username;
}

- (void)setUsername:(NSString *)username {
	[GVUserDefaults standardUserDefaults].username = username;
}

- (NSString *)password {
	return [FXKeychain defaultKeychain][kTHSettingsPasswordKey];
}

- (void)setPassword:(NSString *)password {
	[FXKeychain defaultKeychain][kTHSettingsPasswordKey] = password;
}

- (NSString *)lastHashedResults {
	return [GVUserDefaults standardUserDefaults].lastHashedResults;
}

- (void)setLastHashedResults:(NSString *)lastHashedResults {
	[GVUserDefaults standardUserDefaults].lastHashedResults = lastHashedResults;
}

- (NSTimeInterval)fetchNewGradeResultsTimeInterval {
	switch (self.fetchNewGradeResultsSetting) {
		case THFetchNewGradeResultsEvery15Minutes:
			return kSETOSettingsFetchNewGradeResultsEvery15Minutes;
		case THFetchNewGradeResultsEvery30Minutes:
			return kSETOSettingsFetchNewGradeResultsEvery30Minutes;
		case THFetchNewGradeResultsHourly:
			return kSETOSettingsFetchNewGradeResultsHourly;
	}
}

- (BOOL)loggedIn {
	return self.username && self.password;
}

- (void)reset {
	self.lastFetchDate = nil;
	self.username = nil;
	self.password = nil;
}

@end
