package com.spring.controller;

import javax.inject.Inject;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.spring.domain.Criteria;
import com.spring.domain.ReplyPageDTO;
import com.spring.domain.ReplyVO;
import com.spring.service.ReplyService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/replies")
public class ReplyController {
	
	@Inject
	private ReplyService service;
	
	//댓글을 json 타입으로 넣을 것이고 댓글의 처리 결과가 정상적인지 문자열로 결과 알려주기
	@PostMapping(value="/new",consumes="application/json",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {
		//@RequestBody 를 써서 사용자로부터 넘어오는 데이터가 json 일때 가져올 수 있음
		log.info("댓글 삽입...............");
	
		//http상태코드와 데이터를 보내기 위해 ResponseEntity 사용
		return service.register(vo)==1?new ResponseEntity<>("SUCCESS",HttpStatus.OK):
							new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR) ;
	}
	
	
	//업데이트
	//수정 데이터는 json 형태로 넘어오고 댓글의 글번호는 파라미터로 넘어옴
	@RequestMapping(path="/{rno}",method= {RequestMethod.PATCH,RequestMethod.PUT}
			,consumes="application/json",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> update(@PathVariable("rno")int rno,
			@RequestBody ReplyVO vo){
		
		log.info("댓글 수정 ....");
		
		//rno를 세팅
		vo.setRno(rno);
			
		return service.modify(vo)==1?new ResponseEntity<>("SUCCESS",HttpStatus.OK):
				new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	//삭제
	@DeleteMapping(value="/{rno}",produces= {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> delete(@PathVariable("rno")int rno){
		
		log.info("댓글 삭제 ...."+rno);
		
		return service.remove(rno)==1?new ResponseEntity<>("SUCCESS",HttpStatus.OK):
			new ResponseEntity<>(HttpStatus.BAD_REQUEST);
	}
	//댓글 페이지 처리
	@GetMapping(value="/pages/{bno}/{page}",produces= {MediaType.APPLICATION_JSON_UTF8_VALUE,
									MediaType.APPLICATION_XML_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("bno") int bno,
			@PathVariable("page")int page){
		
		log.info("getList...");	
				
		//페이지 & 한 페이지당 댓글 수
		Criteria cri=new Criteria(page,10);			
				
		log.info(""+cri);

		return new ResponseEntity<>(service.getList(cri, bno),HttpStatus.OK);
	}
	
	//게시글 하나 가져오기
	@GetMapping("/{rno}")
	public ResponseEntity<ReplyVO> get(@PathVariable("rno")int rno){		
		log.info("댓글 조회");
		return new ResponseEntity<>(service.get(rno),HttpStatus.OK);			
	}
	
}
