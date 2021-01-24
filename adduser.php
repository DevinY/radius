#!/usr/bin/php
<?php
error_reporting(E_ALL);
ini_set( 'display_errors','0');
if(!isset($argv[1])&&!isset($argv[2])){
    echo sprintf("%s [username] [password]", $argv[0]);
    exit;
}
$user = $argv[1];
$pwd = password_hash($argv[2],PASSWORD_DEFAULT);
echo sprintf('INSERT into radius.radcheck (username,attribute,op,value) values("%s", "Crypt-Password", ":=", "%s");
',$user, $pwd);
