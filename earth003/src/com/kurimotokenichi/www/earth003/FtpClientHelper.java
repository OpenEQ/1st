package com.kurimotokenichi.www.earth003;

import java.io.FileInputStream;  
import java.io.FileOutputStream;  
import java.io.IOException;  
import java.io.InputStream;  
import java.io.OutputStream;  
  
import org.apache.commons.net.ftp.FTP;  
import org.apache.commons.net.ftp.FTPClient;  
import org.apache.commons.net.ftp.FTPReply;  

import android.util.Log;
  

public class FtpClientHelper {  
    
  //ファイルアップロード  
  public static void sendFile (String host,   
          int port,  
          String user,  
          String password,  
          String remoteFilename,  
          InputStream is  
          ) throws Exception {  
      FTPClient ftpclient = new FTPClient();  
        
      try {  
          //指定するホスト、ポートに接続します  
    	  Log.d("debug", "ftClientHelper starting connect server");
    	  Log.d("debug", "host=" + host + " port=" + port + " user=" + user + " password=" + password + " remoteFilename=" + remoteFilename);
    	  if(is == null){
    		  Log.d("debug", "FtpClientHelper.sendFile is called null InputStream");
    	  }
    	  Log.d("debug", "connecting...");
    	  ftpclient.connect(host, port);  
    	  Log.d("debug", "getReplayCode");
          int reply = ftpclient.getReplyCode();
          Log.d("debug", "getReplyCode ="+reply);
          if (!FTPReply.isPositiveCompletion(reply)) {  
              //接続エラー時処理  
        	  Log.d("debug", "ftp reply error");
              Exception ee = new Exception("Can't Connect to :" + host);  
              throw ee;  
          }  
          Log.d("debug","starting Log-in");
          //ログイン  
          if (ftpclient.login(user, password) == false) {  
              // invalid user/password  
        	  Log.d("debug","ftp login error");
              Exception ee = new Exception("Invalid user/password");  
              throw ee;  
          }  

          //ファイル転送モード設定  
          ftpclient.setFileType(FTP.BINARY_FILE_TYPE);  
          //ftpclient.cwd("filetype=pdf");  
         
          Log.d("debug", "starting trasfer");
          //ファイル転送  
          ftpclient.storeFile(remoteFilename, is);  
          //"ファイル転送完了  

          // ファイル受信  
//          FileOutputStream fos = new FileOutputStream("localfile");  
//          ftpclient.retrieveFile("remotefile", fos);  

      } catch (IOException e) {  
          //TODO エラー処理  
    	  Log.d("debug", "error at ftp upload!");
          throw e;  
      } finally {  
          try {  
              ftpclient.disconnect(); //接続解除  
          } catch (IOException e) {  
          }  
      }  
        
  }  
    
  //ファイルダウンロード  
  public static void retrieveFile(String host,   
          int port,  
          String user,  
          String password,  
          String remoteFilename,  
          OutputStream os) throws Exception {  
      FTPClient ftpclient = new FTPClient();  
        
      try {  
          //指定するホスト、ポートに接続します  
          ftpclient.connect(host, port);  
          int reply = ftpclient.getReplyCode();  
          if (!FTPReply.isPositiveCompletion(reply)) {  
              //接続エラー時処理  
              Exception ee = new Exception("Can't Connect to :" + host);  
              throw ee;  
          }  
            
          //ログイン  
          if (ftpclient.login(user, password) == false) {  
              // invalid user/password  
              Exception ee = new Exception("Invalid user/password");  
              throw ee;  
          }  

          //ファイル転送モード設定  
          ftpclient.setFileType(FTP.BINARY_FILE_TYPE);  
          //ftpclient.cwd("filetype=pdf");  
            
          // ファイル受信  
          ftpclient.retrieveFile(remoteFilename, os);  

      } catch (IOException e) {  
          //TODO エラー処理  
          throw e;  
      } finally {  
          try {  
              ftpclient.disconnect(); //接続解除  
          } catch (IOException e) {  
          }  
      }  
  }  
}  
