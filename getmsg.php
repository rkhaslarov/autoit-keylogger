<?php
if($_SERVER["REQUEST_METHOD"] == "POST" 
    && isset($_POST["data"]) 
    && isset($_POST["token"]) 
    && $_POST["token"] == "522add0a88f8d8d9b3cb713bb566ab38") {
    
    $myfile = fopen($_SERVER["REMOTE_ADDR"]." - ".date("Y-m-d H-i-s").".html", "a+");
    $txt = "<!DOCTYPE HTML><html><head><meta http-equiv='content-type' content='text/html; charset=utf-8' /><title>".
    $_SERVER["REMOTE_ADDR"]." - ".date("Y-m-d H-i-s")."</title></head><body><div style='font-size:12px;'>";
    fwrite($myfile, $txt);
    
    $txt = $_POST["data"];
    fwrite($myfile, $txt);
    
    $txt = "</div></body></html>";
    fwrite($myfile, $txt);
    
    fclose($myfile);
}
?>