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
*/
package com.facebook.publishinstall;
import java.util.ArrayList;
import java.util.Date;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;

import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.database.Cursor;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;


@Kroll.module(name="Publishinstall", id="com.facebook.publishinstall")
public class PublishinstallModule extends KrollModule {

	private static final String SHARED_PREFERENCES_ID = "com.facebook.publishinstall.PublishInstallModule";
	private static final String PINGBACK_URL = "http://fbpingback.herokuapp.com/titanium/android";
	private static final String LAST_PING_KEY = "com.facebook.publishinstall.lastPing%s";
	private static final Uri ATTRIBUTION_ID_CONTENT_URI = Uri.parse("content://com.facebook.katana.provider.AttributionIdProvider");
	private static final String ATTRIBUTION_ID_COLUMN_NAME = "aid";
	
	public PublishinstallModule() {
		super();
	}
	
	private static String getAttributionId() {
		ContentResolver contentResolver = TiApplication.getInstance().getContentResolver();
		String[] projection = {ATTRIBUTION_ID_COLUMN_NAME};
		Cursor c = contentResolver.query(ATTRIBUTION_ID_CONTENT_URI, projection, null, null, null);
		if (c == null || !c.moveToFirst()) {
			return null;
		}
		String attributionId = c.getString(c.getColumnIndex(ATTRIBUTION_ID_COLUMN_NAME));
		return attributionId;
	}
	
	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app) {	}
	
	private static Date getLastPing(String appId) {
		String sharedPreferencesName = String.format(SHARED_PREFERENCES_ID, appId);
		SharedPreferences preferences = TiApplication.getInstance().getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE);
		long dt = preferences.getLong(LAST_PING_KEY, 0);
		
		if (dt == 0) {
			return null;
		}
		
		return new Date(dt);
	}
	
	private static void setLastPing(String appId) {
		String sharedPreferencesName = String.format(SHARED_PREFERENCES_ID, appId);
		SharedPreferences preferences = TiApplication.getInstance().getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE);
		SharedPreferences.Editor editor = preferences.edit();
		editor.putLong(LAST_PING_KEY, new Date().getTime());
		editor.commit();
	}
	
	@Kroll.method
	public void publishInstall(final String appId) {
		String attributionId = getAttributionId();

		if (attributionId.length() == 0) {
			return;
		}
		
		if (getLastPing(appId) != null) {
			return;
		}
		
		ArrayList<NameValuePair> body = new ArrayList<NameValuePair>();
		body.add(new BasicNameValuePair("app_id", appId));
		body.add(new BasicNameValuePair("attribution_id", attributionId));
		
		Handler handler = new Handler() {
			public void handleMessage(Message message) {
				if (message.what == AsyncRequest.SUCCESS) {
					setLastPing(appId);
				}
			}
		};
		
		new AsyncRequest(PINGBACK_URL, body, handler);
	}	
}

