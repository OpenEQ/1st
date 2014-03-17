package com.kurimotokenichi.www.earth003;

import android.os.Environment;
import android.util.Log;
import android.content.Context;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;  
import java.io.IOException;  


public class MyRingBuffer {
	
	private int pointer;  //次にコールされた時に入れる場所
	private byte[] buffer;
	private int byteNum;
	private int maxSize;
	
	public MyRingBuffer(int elementNum, int elementByte){
		buffer = new byte[elementNum * elementByte];
		for(int i=0; i< elementNum * elementByte; i++){
			buffer[i] = 0;
		}
		pointer = 0;
		maxSize = elementNum;
		byteNum = elementByte;
	}
	
	public void pushData(byte[] data){
		if(data.length != byteNum){
			Log.d("debug", "elements size is not equal initial value.\n");
		}
		for(int i=0; i<byteNum; i++){
			buffer[pointer * byteNum + i] = data[i];
		}
		pointer++;
	    if(pointer==maxSize){
	    	pointer=0;
	    }
	}
	
	public void writeOutData(String filename, Context cont){
        try{
// data格納が /data/data/(app)....の場合
        	FileOutputStream file = cont.openFileOutput(filename, cont.MODE_WORLD_WRITEABLE);
        	BufferedOutputStream out = new BufferedOutputStream(file);

// data格納が /sdcard.....の場合
 //       	File file = new File( Environment.getExternalStorageDirectory().getPath()+"/" + filename );
 //       	FileOutputStream out = new FileOutputStream(file);
//
        	
        	for(int i=0;i< byteNum * maxSize;i++){
        		out.write(buffer[i]);
//        		Log.d("debug", "writing out");
        	}
        	out.flush();
//        	file.close();
        	out.close();
        	
        	
        	Log.d("debug", "come 1");
        }catch(IOException e){
        	e.printStackTrace();
        }		
	}
}