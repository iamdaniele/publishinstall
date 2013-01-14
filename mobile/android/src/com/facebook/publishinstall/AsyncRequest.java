package com.facebook.publishinstall;

import java.util.ArrayList;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;

import android.os.Handler;
import android.os.Message;

public class AsyncRequest implements Runnable {

	public static final int SUCCESS = 0;
	
	private Handler handler;
	private HttpClient client;
	private String url;
	private ArrayList<NameValuePair> body;
	public AsyncRequest(String _url, ArrayList<NameValuePair> _body, Handler _handler) {
		url = _url;
		body = _body;
		handler = _handler;
		Thread thread = new Thread(this);
		thread.start();
	}
	
	@Override
	public void run() {
		client = new DefaultHttpClient();
		HttpResponse response = null;
		try {
			HttpPost post = new HttpPost(url);
			post.setEntity(new UrlEncodedFormEntity(body));
			response = client.execute(post);
			int statusCode = response.getStatusLine().getStatusCode();
			if (200 == statusCode) {
				Message message = Message.obtain(handler, SUCCESS, statusCode);
				handler.sendMessage(message);
			}
		} catch (Exception e) {	}
	}
}
