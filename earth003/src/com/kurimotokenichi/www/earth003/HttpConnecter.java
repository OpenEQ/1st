package com.kurimotokenichi.www.earth003;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import android.util.Log;

public class HttpConnecter{
	//URL��GET���N�G�X�gURL��������w��
	public static String doGetRequest(String sUrl){
		
	    String sReturn = "";
	    HttpGet httpGetObj   = new HttpGet(sUrl);
	    HttpClient httpClientObj = new DefaultHttpClient();  
	    HttpParams httpParamsObj = httpClientObj.getParams();
	    HttpEntity httpEntityObj = null;
	    InputStream inpurStreamObj = null;
	    InputStreamReader inputStreamReaderObj = null;
	    BufferedReader bufferedReaderObj = null;
	    
	    //�ڑ��̃^�C���A�E�g�i�P�ʁFms�j
	    HttpConnectionParams.setConnectionTimeout(httpParamsObj, 5000);
	    //�f�[�^�擾�̃^�C���A�E�g�i�P�ʁFms�j�T�[�o���̃v���O����(php�Ƃ�)��sleep�Ȃǂ��g���΃e�X�g�ł���
	    HttpConnectionParams.setSoTimeout(httpParamsObj, 10000);   
	    //user-agent
	    httpParamsObj.setParameter("http.useragent", "hogehoge testHttp ua");
	    
	    try {  
	        //http���N�G�X�g�i���Ԑ؂�ȂǃT�[�o�ւ̃��N�G�X�g���ɖ�肪����Ɨ�O����������j
	        HttpResponse httpResponseObj = httpClientObj.execute(httpGetObj);
	        //http���X�|���X��400�ԑ�ȍ~�̓G���[������
	        if (httpResponseObj.getStatusLine().getStatusCode() < 400){
	        	//
	        	httpEntityObj = httpResponseObj.getEntity();
	        	//���X�|���X�{�̂��擾
	        	inpurStreamObj = httpEntityObj.getContent();
	            
	            inputStreamReaderObj = new InputStreamReader(inpurStreamObj);  
	            bufferedReaderObj = new BufferedReader(inputStreamReaderObj);  
	            StringBuilder stringBuilderObj = new StringBuilder();  
	            String sLine;  
	            while((sLine = bufferedReaderObj.readLine()) != null){  
	            	stringBuilderObj.append(sLine+"\r\n");  
	            }
	            //
	            sReturn = stringBuilderObj.toString();  
	            
	        }  
	    } catch (Exception e) { 
	    	Log.v("debug","return null 1");
	        return null;  
	    }
	    finally{
	    	try {
		    	if(bufferedReaderObj != null)
		    		bufferedReaderObj.close();
		    	if(inpurStreamObj != null)
		    		inpurStreamObj.close();
		    	if(inputStreamReaderObj != null)
		    		inputStreamReaderObj.close();
			} catch (IOException e) {
				// TODO �����������ꂽ catch �u���b�N
				//e.printStackTrace();
		    	Log.v("debug","return null 2");
				return null;
			}
	    	
	    }
	    
	    return sReturn;	
	}
	
}
