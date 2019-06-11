package com.spring.service;
import java.util.List;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardService {
	//CRUD 기능의 메소드 구현
	//글 등록
	public void register(BoardVO vo) throws Exception;
	
	//글 수정
	public boolean modify(BoardVO vo) throws Exception;
	
	//글 삭제
	public boolean remove(int bno) throws Exception;
	
	//글 상세 조회
	public BoardVO get(int bno) throws Exception;
	
	//글 목록 조회
	//public List<BoardVO> getList() throws Exception;	
	
	//페이징 처리된 글 목록 조회
	//public List<BoardVO> getList(Criteria cri) throws Exception;
	
	//전체 목록 수 구하기
	public int getTotal(Criteria cri) throws Exception;
	
	//페이징 처리 + 검색
	public List<BoardVO> getListWithPaging(Criteria cri) throws Exception;
	
	//첨부파일 정보
	public List<BoardAttachVO> getAttachList(int bno);
	
}

