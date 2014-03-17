<?php



$url = 'https://android.apis.google.com/c2dm/send';


require_once("../../earth_dbinfo.php");


if($_POST["code"] != $code_send){
return;
}

$s=mysql_connect($SERVE,$USER,$PASS) or die("fail to open database");
print "connecting db!\n";
mysql_select_db($DBNM);

$num = htmlspecialchars($_POST["phone_num"]);
$message = htmlspecialchars($_POST["message"]);
//print($num);
//print"\n";
//print($mes);
if(preg_match("/[^0-9]/",$num)){
     die("we can't accept not numeric character for num");
}

$query1 = "select reg_id from regist_table where terminal_num = $num";
//print($query1);
$result1 = mysql_query($query1);
$row1 = mysql_fetch_assoc($result1);
$registration_id = $row1["reg_id"];
//print($registration_id);

$query2 = "select token from auth_token where fixkey = 1";
$result2 = mysql_query($query2);
$row2 = mysql_fetch_assoc($result2);
$auth_token = $row2["token"];
//print("\n");
//print($auth_token);
//print("\n");

//$message = 'あいうえおかきくけこ';
 
$header = array(
  'Content-type: application/x-www-form-urlencoded',
  'Authorization: GoogleLogin auth='.$auth_token, // 認証Token
);
//print("\n");
//print($header[1]);
//print("\n");
$post_list = array(
  'registration_id' => $registration_id,
  'collapse_key' => 1,
  'data.message' => $message,
);
$post = http_build_query($post_list, '&');
 
print("Let's send message!");
$ch = curl_init($url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_FAILONERROR, 1);
curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
curl_setopt($ch, CURLOPT_POST, TRUE);
curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
curl_setopt($ch, CURLOPT_POSTFIELDS, $post);
curl_setopt($ch, CURLOPT_TIMEOUT, 5);
$ret = curl_exec($ch);

  echo 'Curl error: ' . curl_error($ch);

print("\n");
var_dump($ret);
