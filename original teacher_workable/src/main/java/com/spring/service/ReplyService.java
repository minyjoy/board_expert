package com.spring.service;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;

public interface ReplyService {
	public ReplyVO get(int rno);
	public int register(ReplyVO vo);
	public int modify(ReplyVO vo);
	public int remove(int rno);
	//public List<ReplyVO> getList(Criteria cri,int bno);
	public ReplyPageDTO getList(Criteria cri,int bno);
	
	//ReplyPageDTO 안에는 댓글 게시물 수를 리스트로 받는 프로퍼티와 게시물 댓글 수를 가지는 
	//형태로 만들어서 사용
	

}
