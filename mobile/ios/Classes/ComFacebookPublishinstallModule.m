/**
 * Copyright 2013 Facebook, Inc.
 *
 * You are hereby granted a non-exclusive, worldwide, royalty-free license to
 * use, copy, modify, and distribute this software in source code or binary
 * form for use in connection with the web services and APIs provided by
 * Facebook.
 *
 * As with any software that integrates with the Facebook platform, your use
 * of this software is subject to the Facebook Developer Principles and
 * Policies [http://developers.facebook.com/policy/]. This copyright notice
 * shall be included in all copies or substantial portions of the software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComFacebookPublishinstallModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <AdSupport/AdSupport.h>

NSString *const kFbPasteboardName = @"fb_app_attribution";
NSString *const kPingbackUrl = @"http://fbpingback.herokuapp.com/titanium/ios";
NSString *const kLastPingKey = @"com.facebook.publishinstall:lastAttributionPing%@";

@implementation ComFacebookPublishinstallModule
@synthesize appID;

#pragma mark Internal

-(id)moduleGUID {
	return @"ac06d854-3548-4de1-bfaf-2267c6b44fbc";
}

-(NSString*)moduleId {
	return @"com.facebook.publishinstall";
}

#pragma mark Lifecycle

-(void)startup {
	[super startup];
}

-(void)shutdown:(id)sender {
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc {
	[super dealloc];
}

#pragma mark Internal Memory Management
-(void)didReceiveMemoryWarning:(NSNotification*)notification {
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count { }
-(void)_listenerRemoved:(NSString *)type count:(int)count { }

-(void)sendPingbackWithAttributionId:(NSString *)attributionID
                     andAdvertiserId:(NSString *)advertiserID
                  andCompletionBlock:(void (^)(int status))block {

  NSMutableString *bodyTemplate = [[NSMutableString alloc] init];
  
  [bodyTemplate appendFormat:@"app_id=%@", [self appID]];
  
  if (attributionID) {
    [bodyTemplate appendFormat:@"&attribution_id=%@", attributionID];
  }
  
  if (advertiserID) {
    [bodyTemplate appendFormat:@"&advertiser_id=%@", advertiserID];
  }
  
  NSData *body = [bodyTemplate dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  NSString *contentLength = [NSString stringWithFormat:@"%d", [body length]];
  NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
  [request setURL:[NSURL URLWithString:kPingbackUrl]];
  [request setHTTPMethod:POST];
  [request setValue:contentLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:body];

  if ([NSURLConnection respondsToSelector:@selector(sendAsynchronousRequest:queue:completionHandler:)]) {
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      int statusCode = [httpResponse statusCode];
      block(statusCode);
    }];
  } else {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      NSError *err = nil;
      NSURLResponse *response = nil;
      NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
      dispatch_async(dispatch_get_main_queue(), ^{
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = [httpResponse statusCode];
        block(statusCode);
      });
    });
  }
}

-(NSDate *)lastPingForKey:(NSString *)key {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDate *lastPing = [defaults objectForKey:key];
  return lastPing;
}

-(void)setLastPingForKey:(NSString *)key {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:[NSDate date] forKey:key];
  [defaults synchronize];
}

#pragma Public APIs
-(id)publishInstall:(id)args {
  ENSURE_UI_THREAD_1_ARG(args);
  
  args = (NSString *)[args objectAtIndex:0];
  NSString *key = nil;
  if (args) {
    [self setAppID:args];
    key = [NSString stringWithFormat:kLastPingKey, args];
  } else {
    return;
  }
  
  if ([self lastPingForKey:key]) {
    NSLog(@"last ping detected: %@", [self lastPingForKey:key]);
    return;
  }
  
  UIPasteboard *pb = [UIPasteboard pasteboardWithName:kFbPasteboardName create:NO];
  NSString *attributionID = nil;
  NSString *advertiserID = nil;
  if (pb) {
    NSString *attributionID = pb.string;
  }

  if ([ASIdentifierManager class]) {
    ASIdentifierManager *manager = [ASIdentifierManager sharedManager];
    advertiserID = [[manager advertisingIdentifier] UUIDString];
  }

  
  if ([self appID] && (attributionID || advertiserID)) {
    [self sendPingbackWithAttributionId:attributionID
                        andAdvertiserId:advertiserID
                     andCompletionBlock:^(int status) {
                       if (200 == status) {
                         [self setLastPingForKey:key];
                       }
                     }];
  }
}
@end