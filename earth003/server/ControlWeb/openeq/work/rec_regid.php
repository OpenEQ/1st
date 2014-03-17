<?php

//require_once("/home/kurimoto/OpenEarthQuark/earth_dbinfo.php");
require_once("../../earth_dbinfo.php");


if($_GET["code"] != $code_reg){
 return(0);
}


$s=mysql_connect($SERVE,$USER,$PASS) or die("fail to open database");
//print "connecting db!";
mysql_select_db($DBNM);

$num = htmlspecialchars($_GET["termnum"]);
$andid = htmlspecialchars($_GET["andID"]);
$regid = htmlspecialchars($_GET["regid"]);
$longi = htmlspecialchars($_GET["long"]);
$lati = htmlspecialchars($_GET["lati"]);

$query1 = sprintf("select * from regist_table where android_id = '%s';",$andid);
//print $query1;
$ret1 = mysql_query($query1);
$kekka = mysql_fetch_array($ret1);

if($kekka == FALSE and $num != 0){
//  print "get away ! 1";
  mysql_close($s);
  return(0);
}
if($num == 0 and $kekka != FALSE){
//  print "get away! 2";
  $query5 = sprintf("update regist_table set reg_id = '%s', longi = %d, lati = %d where android_id = '%s';", $regid, $longi,$lati,$kekka[2]);
  mysql_query($query5);
  mysql_close($s);

  return($kekka[0]);
}

if($num ==0 and $kekka == FALSE){
  print "called by new terminal!";
  $query2 = sprintf("insert into regist_table values(NULL,'%s', '%s', %d, %d);",$regid,$andid, $longi, $lati);
//print $query2;
  mysql_query($query2);
  $ret2 = mysql_query($query1);
  $kekka2 = mysql_fetch_array($ret2);
  mysql_close($s);
//print $kekka2[0];
  return($kekka2[0]);
}

//print "called by registered terminal!";
$query3 = sprintf("update regist_table set terminal_num = %d, reg_id = '%s', longi = %d, lati = %d where android_id = '%s';",$num,$regid,$longi,$lati,$kekka[2]);
mysql_query($query3);
mysql_close($s);
//print $num;
return($num);

