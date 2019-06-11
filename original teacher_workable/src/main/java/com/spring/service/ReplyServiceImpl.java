package com.spring.service;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;
import com.spring.mapper.BoardMapper;
import com.spring.mapper.ReplyMapper;


@Service
public class ReplyServiceImpl implements ReplyService {

	@Inject
	private ReplyMapper mapper;
	@Inject
	private BoardMapper boardMapper;

	@Transactional
	@Override
	public int register(ReplyVO vo){
		boardMapper.updateReplyCnt(vo.getBno(), 1);
		return mapper.insert(vo);
	}
	
	@Transactional
	@Override
	public int remove(int rno){		
		//rno를 이용해 bno를 알아내기 위해
		ReplyVO vo=mapper.read(rno);
		
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}

	@Override
	public ReplyVO get(int rno){
		return mapper.read(rno);
	}
	@Override
	public int modify(ReplyVO vo){
		return mapper.update(vo);
	}

	@Override
	public ReplyPageDTO getList(Criteria cri, int bno){		
		return new ReplyPageDTO(mapper.getCountByBno(bno),
				mapper.getListwithPaging(cri, bno));
	}
}
