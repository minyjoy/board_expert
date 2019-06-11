package com.spring.mapper;

import java.util.List;

import com.spring.domain.BoardAttachVO;

public interface BoardAttachMapper {
	public int insert(BoardAttachVO vo);
	public int delete(int uuid);
	public List<BoardAttachVO> findByBno(int bno);
	public void deleteAll(int bno);
	
	//Quartz
	public List<BoardAttachVO> getOldFiles();
}
