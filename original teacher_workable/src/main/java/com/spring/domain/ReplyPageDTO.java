package com.spring.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ReplyPageDTO {
	private int replyCnt; //게시물 댓글 수
	private List<ReplyVO> list;
	
	//원래 ReplyService에서 List<ReplyVO> 형태를
	//가지면서 한 번호에 대한 댓글 전체 게시물 수를 같이 가지게 됨
}
