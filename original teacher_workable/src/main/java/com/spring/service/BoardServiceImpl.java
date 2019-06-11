package com.spring.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.mapper.BoardAttachMapper;
import com.spring.mapper.BoardMapper;

@Service
public class BoardServiceImpl implements BoardService {	
	@Autowired 
	private BoardMapper mapper;
	@Autowired
	private BoardAttachMapper attachMapper;

	@Override
	@Transactional
	public void register(BoardVO vo) throws Exception {
		//mapper.insert(vo);		
		mapper.insertSelectKey(vo);	
		
		if(vo.getAttachList()==null || vo.getAttachList().size()<=0) {
			return;
		}
		vo.getAttachList().forEach(attach->{
			attach.setBno(vo.getBno());
			attachMapper.insert(attach);
		});
	}	
	@Override
	public BoardVO get(int bno) throws Exception {
		return mapper.read(bno);
	}
	@Override
	@Transactional
	public boolean modify(BoardVO vo) throws Exception {	
		
		//전체적으로 첨부물이 다시 넘어오므로 기존 첨부물 삭제
		attachMapper.deleteAll(vo.getBno());
		
		boolean modifyResult=mapper.update(vo)==1;
		//첨부내역 다시 삽입
		if(modifyResult && vo.getAttachList().size()>0) {
			for(BoardAttachVO attach:vo.getAttachList()) {
				attach.setBno(vo.getBno());
				attachMapper.insert(attach);
			}
		}
		
		return modifyResult;		
	}
	@Override
	@Transactional
	public boolean remove(int bno)throws Exception  {
		attachMapper.deleteAll(bno);
		return mapper.delete(bno)==1;	
	}
	/*@Override
	public List<BoardVO> getList() throws Exception {		
		return mapper.getList();
	}*/
	/*@Override
	public List<BoardVO> getList(Criteria cri) throws Exception {		
		return mapper.getList(cri);
	}*/
	@Override
	public int getTotal(Criteria cri) throws Exception {		
		return mapper.getTotalCount(cri);
	}
	@Override
	public List<BoardVO> getListWithPaging(Criteria cri) throws Exception {		
		return mapper.getListWithPaging(cri);	
	}
	@Override
	public List<BoardAttachVO> getAttachList(int bno) {
		return attachMapper.findByBno(bno);
	}	
}


