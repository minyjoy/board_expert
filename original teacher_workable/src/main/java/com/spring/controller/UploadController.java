package com.spring.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.spring.domain.BoardAttachVO;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnailator;

@Slf4j
@Controller  
public class UploadController {
	//@RestController로 안한 이유는 void uploadAjax()와 같은 일반적인 jsp페이지를 찾아야 되는 경우도 있기 때문	
	
	@GetMapping(value="/uploadAjax")
	public void uploadAjax(){
		log.info("ajax 폼 요청");
	}
	
	/* 파일 하나에 대한 결과만 보낼 때
	 * 
	 * @PostMapping("/uploadAjax")*/
	/*@ResponseBody
	@PostMapping("/uploadAjax")
	public ResponseEntity<String> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("파일 저장 요청");
		String uploadPath="d:\\upload";
		String uploadFileName=null;
		
		for (MultipartFile multipartFile : uploadFile) {
			
			uploadFileName= multipartFile.getOriginalFilename();
			//IE 브라우저가 파일 패스를 끌고 오는 것 해결
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
						
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString()+"_"+uploadFileName;
						
			try {
				File saveFile = new File(uploadPath,uploadFileName);
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			} // end catch
		} // end for
		
		return new ResponseEntity<>(uploadFileName,HttpStatus.OK);		
	}	*/
	
	//첨부파일이 여러개일 때
	@PostMapping(value="/uploadAjax",produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		log.info("파일 저장 요청");
		String uploadFolder="d:\\upload";	
		
		// d:\\upload 폴더 안에 년/월/일 폴더 생성
		String uploadFolderPath=getFolder();
		File uploadPath=new File(uploadFolder,uploadFolderPath);
		log.info("uploadPath : "+uploadPath);
		
		if(!uploadPath.exists()) {
			uploadPath.mkdirs();
		}
		
		List<BoardAttachVO> attachList=new ArrayList<>();
		for (MultipartFile multipartFile : uploadFile) {
			
			String uploadOriFileName= multipartFile.getOriginalFilename();
			//IE 브라우저가 파일 패스를 끌고 오는 것 해결
			String uploadFileName = uploadOriFileName.substring(uploadOriFileName.lastIndexOf("\\") + 1);
			
			//uuid 생성
			UUID uuid = UUID.randomUUID();			
			uploadFileName = uuid.toString()+"_"+uploadFileName;
					
			BoardAttachVO attach=new BoardAttachVO();
			attach.setFileName(uploadOriFileName);			
			attach.setUploadPath(uploadFolderPath);
			attach.setUuid(uuid.toString());
			
			try {
				File saveFile = new File(uploadPath,uploadFileName);
						
				// check image type file
				if (checkImageType(saveFile)) {
					attach.setFileType(true);	
					//이미지 파일이라면 섬네일로 한번 더 저장하기
					FileOutputStream thumbnail=new FileOutputStream(new File(uploadPath,"s_"+uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(),thumbnail,100,100);
					thumbnail.close();
				}				
				//이미지던 일반 파일이던 원본 그대로 저장 - 이 문장이 위에 있으면 File has been moved 메세지 나옴
				multipartFile.transferTo(saveFile);
				log.info("attach : "+attach);
				attachList.add(attach);
			} catch (Exception e) {
				e.printStackTrace();
			} // end catch
		} // end for		0
		
		log.info("attach12 : ");
		return new ResponseEntity<>(attachList, HttpStatus.OK);		
	}	
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	private boolean checkImageType(File file) {
		try { //이미지 파일인지 확인
			String contentType = Files.probeContentType(file.toPath());
			return contentType.startsWith("image");
		} catch (IOException e) {			
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {

		File file = new File("d:\\upload\\"+fileName);
		log.info("file: " + file);

		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();

			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), 
					header, HttpStatus.OK);
		} catch (IOException e) {			
			e.printStackTrace();
		}
		return result;
	}
	
	
	@GetMapping(value="/download",produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody  //@Controller 이기 때문에 이걸 쓴 것임
	public ResponseEntity<Resource> downloadFile(String fileName,@RequestHeader("User-Agent")String userAgent){
		
		log.info("download file :"+fileName);
		//org.springframework의 Resource
		Resource resource = new FileSystemResource("d:\\upload\\"+fileName);
		
		
		
		
		if(!resource.exists()) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}		
		
		//다운로드 할 때 uuid 값 제거하기
		String resourceName = resource.getFilename();	
		String resourceOriName=resourceName.substring(resourceName.indexOf("_")+1);	
		HttpHeaders headers = new HttpHeaders();	
		
		try {
			String downloadName = null;		
			
			if(userAgent.contains("Trident") || userAgent.contains("Edge")) {
				downloadName = URLEncoder.encode(resourceOriName, "UTF-8").replaceAll("\\+"," ");
			}else {
				log.info("chrome browser");
				downloadName = new String(resourceOriName.getBytes("utf-8"),"ISO-8859-1");
			}
				
			headers.add("Content-Disposition", "attachment;filename="+downloadName);
						
		} catch (UnsupportedEncodingException e) {			
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource,headers,HttpStatus.OK);
	}
	
	
	
	
	
	@PostMapping("/deleteFile")
	public ResponseEntity<String> deleteFile(String fileName,String type){
		//d%3A%5Cupload%2F471c7ea9-f4b8-4500-82cc-1b60a1594534_GoodsDAO.txt
		//log.info("fileName "+fileName);
		//type : file
		log.info("type : "+type);
		File file=null;
		
		try {
			file=new File("D:\\upload\\"+URLDecoder.decode(fileName, "utf-8"));
			
			log.info("fileName "+file.getPath());
			
			file.delete(); //섬네일 파일 삭제
			
			if(type.equals("image")) {//이미지인 경우 섬네일 삭제
				String largeName=file.getAbsolutePath().replace("s_", "");
				log.info("largeName "+largeName);
				file=new File(largeName);
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {			
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}		
		return new ResponseEntity<String>("deleted",HttpStatus.OK);
	}
	
}
