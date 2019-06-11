package com.spring.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.spring.domain.BoardAttachVO;
import com.spring.mapper.BoardAttachMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class FileCheckTask {
	@Autowired
	private BoardAttachMapper attachMapper;
	
	//어제 날짜의 폴더 구하기
	private String getFolderYesterDay() {
		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal=Calendar.getInstance();
		
		cal.add(Calendar.DATE, -1);  //Calendar.DATE : 일자 day of the month
		//log.info("Date "+Calendar.DATE);  //토요일일 때  5를 가져옴
		String str = sdf.format(cal.getTime());  //어제날짜 가져옴
				
		return str.replace("-", File.separator); //2019-04-12  => 2014/04/12 로 변경
	}
	
	
	@Scheduled(cron="0 0 2 * * *")
	public void checkFiles() throws Exception{
		log.warn("File Check Task run.....");
		
		//데이터베이스에서 파일 리스트 가져오기
		List<BoardAttachVO> fileList=attachMapper.getOldFiles();
		
		//fileList에서 내용을 순차적으로 가져와서 
		//목록의 형태로 만들어 냄		
		List<Path> fileListPaths = fileList.stream().map(vo -> 
				Paths.get("D:\\upload",vo.getUploadPath(),
						vo.getUuid()+"_"+vo.getFileName())).collect(Collectors.toList());
		
		//log.info("fileListPaths "+fileListPaths.toString());
		
		//썸네일을 가지고 있는 이미지 파일
		fileList.stream().filter(vo -> vo.isFileType()==true).
				map(vo -> Paths.get("D:\\upload",vo.getUploadPath(),
						"s_"+vo.getUuid()+"_"+vo.getFileName())).forEach(p -> fileListPaths.add(p));
		
		fileListPaths.forEach(p -> log.warn(""+p));
		
		File targetDir = Paths.get("D:\\upload",getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath())==false);
		
		for(File file:removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}		
	}
}
