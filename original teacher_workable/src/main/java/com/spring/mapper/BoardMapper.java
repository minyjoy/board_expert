package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;

public interface BoardMapper {
	//public int insert(BoardVO vo);
	public int insertSelectKey(BoardVO vo);
	public BoardVO read(int bno);
	public int update(BoardVO vo);
	public int delete(int bno);
//	public List<BoardVO> getList();	
//	public List<BoardVO> getList(Criteria cri);
	
	//전체 게시물을 구할 때는 필요없지만 나중에 검색할 때 필요함
	public int getTotalCount(Criteria cri);
	
	//일반리스트 or 검색리스트
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	//댓글 수 카운트
	public void updateReplyCnt(@Param("bno")int bno,@Param("amount")int amount);
}
