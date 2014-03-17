package com.kurimotokenichi.www.earth003;
 
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
 
import com.google.android.c2dm.C2DMBaseReceiver;
import com.google.android.c2dm.C2DMessaging;
 
public class C2DMReceiver extends C2DMBaseReceiver {
    public String regID;
    private String rets;
    private static final String SERVER_REGID = "http://49.212.118.187/openeq/rec_regid.php?";
    private int stationID = 0;

    public C2DMReceiver() {
        super("kurimoto@k2-garage.com");
    }

    @Override
    public void onRegistered(Context context, String registrationId) { 	
        Log.w("registration id:", registrationId);
//        sendMessage("id:" + registrationId);

        regID = C2DMessaging.getRegistrationId(this);
		try {
			String encregID = URLEncoder.encode(regID,"UTF-8");
			String encAndID = URLEncoder.encode(Earth003Activity.getAndID());
            String sendurl = SERVER_REGID + "code=kurioda&termnum="+ Integer.toString(Earth003Activity.getTerminalNum())
        		            +"&andID="+ encAndID + "&regid="+ encregID + "&long="+Double.toString(Earth003Activity.getLongitude())
        		            + "&lati=" + Double.toString(Earth003Activity.getLatitude());      
        rets = HttpConnecter.doGetRequest(sendurl);            
        Log.v("debug",sendurl);
		stationID = Integer.parseInt(rets);
		Earth003Activity.setTerminalNum(stationID);
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch(NumberFormatException e){
			e.printStackTrace();
		}
    }
 
    @Override
    public void onUnregistered(Context context) {
        sendMessage("C2DM Unregistered");
    }
 
    @Override
    public void onError(Context context, String errorId) {
        sendMessage("err:" + errorId);
    }
 
    @Override
    protected void onMessage(Context context, Intent intent) {
        String str = intent.getStringExtra("message");
        Log.w("message:", str);
        sendMessage(str);
    }
   
    private void sendMessage(String str) {
        Message mes = Message.obtain(Earth003Activity.mH);
        Bundle data = mes.getData();
        data.putBoolean("receivedMessageFlag", true);
        data.putString("receivedMessageString", str);
        Earth003Activity.mH.sendMessage(mes);
        mes = null;
    }
 }