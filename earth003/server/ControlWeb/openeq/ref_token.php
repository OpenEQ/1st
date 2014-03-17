<?php

//require_once("/home/kurimoto/OpenEarthQuark/earth_dbinfo.php");
require_once("../../earth_dbinfo.php");
$s=mysql_connect($SERVE,$USER,$PASS) or die("fail to open database");
//print "connecting db!";
mysql_select_db($DBNM);


$url = 'https://www.google.com/accounts/ClientLogin';

// signupページで入力したgoogleアカウントのIDとパスワード

$header = array(
  'Content-type: application/x-www-form-urlencoded',
 );
$post_list = array(
  'accountType' => 'GOOGLE',
  'Email' => $google_id,
  'Passwd' => $google_pwd,
  'source' => 'sample-sample',
  'service' => 'ac2dm',
 );
$post = http_build_query($post_list, '&');

$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FAILONERROR, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_POST, TRUE);
curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
curl_setopt($ch, CURLOPT_TIMEOUT, 5);
$ret = curl_exec($ch);

//  echo 'Curl error: ' . curl_error($ch);

//$ans = split("Auth=", $ret);
$ans_pre = preg_split('/Auth=/', $ret, -1, PREG_SPLIT_NO_EMPTY);
//print_r($ans_pre);
$ans = preg_split('/\s/', $ans_pre[1], -1, PREG_SPLIT_NO_EMPTY);
//print($ans[0]);
$query_token = "update auth_token set token ="."'"."$ans[0]"."'";
//print($query_token);
mysql_query($query_token); 

mysql_close($s);

//print($ans[1]);
//print_r($ret);
