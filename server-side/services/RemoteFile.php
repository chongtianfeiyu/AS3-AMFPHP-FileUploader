<?php
require_once ('./vo/FileVO.php');

class RemoteFile { 
/** 
* Upload files! 
* 
* @param  FileVO $file
* @return string
**/ 
   public function upload(FileVO $file) { 
      $data = $file->filedata->data;
      file_put_contents( 'uploads/' . $file->filename, $data);
      return 'File: ' . $file->filename .' Uploaded '; 
   } 
} 
?>