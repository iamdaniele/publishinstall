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
#import <FacebookSDK/FacebookSDK.h>

@implementation ComFacebookPublishinstallModule

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

#pragma Public APIs
-(id)publishInstall:(id)args {
  ENSURE_UI_THREAD_1_ARG(args);
  if (args) {
    args = (NSString *)[args objectAtIndex:0];
  }
  
  if (args) {
    [FBSettings publishInstall:args];
  }
}
@end