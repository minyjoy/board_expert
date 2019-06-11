package com.spring.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyVO;

public interface ReplyMapper {
	public int insert(ReplyVO reply);
	public int delete(int bno);
	public int update(ReplyVO reply);
	public ReplyVO read(int bno);
	public List<ReplyVO> getListwithPaging(@Param("cri") Criteria cri,@Param("bno")int bno);
	public int getCountByBno(int bno);
}
