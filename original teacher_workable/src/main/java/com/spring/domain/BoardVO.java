package com.spring.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	private int bno;
	private String title;
	private String writer;
	private String content;		
	private Date regdate;
	private Date updatedate;	
	
	private int replycnt;
	
	//첨부파일 처리를 위해
	private List<BoardAttachVO> attachList;
}
