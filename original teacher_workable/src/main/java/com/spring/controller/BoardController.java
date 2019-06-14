package com.spring.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.BoardAttachVO;
import com.spring.domain.BoardVO;
import com.spring.domain.Criteria;
import com.spring.domain.LoginVO;
import com.spring.domain.PageDTO;
import com.spring.service.BoardService;

import lombok.extern.slf4j.Slf4j;

/**
 * Handles requests for the application home page.
 */
@Controller
@Slf4j
@RequestMapping("/board/*")
public class BoardController {
		
	@Inject
	private BoardService service;
	
	@Autowired
	BCryptPasswordEncoder passEncoder;

	
	@RequestMapping(value = "/register", method = RequestMethod.GET)
	public void registGET() {
		log.info("게시글 등록 폼 요청.....");
	}
	
	@PostMapping("/register")	
	public String registPOST(BoardVO vo,RedirectAttributes rttr) throws Exception {
		log.info("게시글 등록 요청.....");
		
		if(vo.getAttachList()!=null) {
			vo.getAttachList().forEach(attach -> log.info(attach+""));
		}
		
		service.register(vo);
		//만일 등록 성공 메시지를 모달로 띄울때 - 조금 전 등록된 글 번호를 가져오기
		rttr.addFlashAttribute("result", vo.getBno());		
		return "redirect:list";
	}
	
	//@GetMapping({"/read","/modify"})
	@RequestMapping(value = {"/read","/modify"}, method = RequestMethod.GET)
	public void read(int bno,Model model,@ModelAttribute("cri") Criteria cri) throws Exception {
		log.info("get or modify");		
		log.info("페이지 번호 : " + cri.getPageNum());
		BoardVO vo=service.get(bno);
		model.addAttribute("vo", vo);
		//@ModelAttribute를 써서 view 페이지까지 자동으로 model.addAttribute 한 효과를 줌
	}	
	
	@PostMapping("/modify")
	public String modify(BoardVO vo,@ModelAttribute("cri")Criteria cri,RedirectAttributes rttr, LoginVO vo1) 
						throws Exception {
		log.info("게시글 수정 요청....."+cri.getKeyword());
		
		if(service.modify(vo)) {		
			rttr.addFlashAttribute("result", "success");
		}
		
//		vo.get
//		String inputModify = passEncoder.encode(inputModify);
		
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());		
		rttr.addAttribute("type", cri.getType());		
		rttr.addAttribute("keyword", cri.getKeyword());		
				
		return "redirect:list";
	}
	
	@PostMapping("/remove")
	public String remove(int bno,Criteria cri,RedirectAttributes rttr) throws Exception {
		log.info("게시글 삭제 요청.....");
		
		//해당 bno 에 있는 첨부물 정보 알아내기
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			deleteFiles(attachList);
			rttr.addFlashAttribute("result", "success");
		}
		
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());	
		rttr.addAttribute("type", cri.getType());		
		rttr.addAttribute("keyword", cri.getKeyword());		
		
		return "redirect:list";
	}
	
	//페이지 나누기 적용 후
	@RequestMapping(value = "/list", method = RequestMethod.POST)
	public void list(@ModelAttribute("cri")Criteria cri,Model model) throws Exception {
		log.info("게시글 목록 보여주기.....");
		//List<BoardVO> list=service.getList(cri);	
		List<BoardVO> list=service.getListWithPaging(cri);
		model.addAttribute("list",list);
		//임의의 토탈 갯수를 넣어서 확인
		model.addAttribute("pageMaker", new PageDTO(cri,service.getTotal(cri)));
	}	
	
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list2(@ModelAttribute("cri")Criteria cri,String userid,Model model) throws Exception {
		log.info("게시글 목록 보여주기.....");
		if(userid != null) {
		model.addAttribute("userid",userid);	
		}else {
		
		}
		//List<BoardVO> list=service.getList(cri);	
		List<BoardVO> list=service.getListWithPaging(cri);
		model.addAttribute("list",list);
		//임의의 토탈 갯수를 넣어서 확인
		model.addAttribute("pageMaker", new PageDTO(cri,service.getTotal(cri)));
	}	
	
	
	//첨부파일 목록 가져오기
	@RequestMapping(value = "/getAttachList", method = RequestMethod.GET)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(int bno){
		log.info("첨부 목록 가져오기....");
		
		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
	}
		
	//썸네일/일반파일 삭제하는 메소드
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList==null||attachList.size()==0) {
			return;
		}
		
		for(BoardAttachVO vo:attachList) {						
			try { 
				Path file = Paths.get("d:\\upload\\"+vo.getUploadPath()+"\\"+
						vo.getUuid()+"_"+vo.getFileName());
				
				log.info("파일명 : "+file.getFileName());
				
				//일반파일, 이미지 파일 폴더에서 삭제  
				Files.deleteIfExists(file);
				
				//image 인 경우 썸네일 삭제
				if(Files.probeContentType(file).startsWith("image")) {
					log.info(Files.probeContentType(file));  // image/jpeg
					Path thumbNail = Paths.get("d:\\upload\\"+vo.getUploadPath()+"\\s_"+
						vo.getUuid()+"_"+vo.getFileName());
					Files.delete(thumbNail);
				}
			} catch (IOException e) {				
				e.printStackTrace();
			}			
		}//for
	}
	
	/* 페이지 나누기 전*/
	/*@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list(Model model) throws Exception {
		log.info("게시글 목록 보여주기.....");
		List<BoardVO> list=service.getList();	
		model.addAttribute("list",list);		
	}*/
	
	//@GetMapping({"/read","/modify"})
	/*@RequestMapping(value = {"/read","/modify"}, method = RequestMethod.GET)
	public void read(int bno,Model model) throws Exception {
		log.info("get or modify");				
		BoardVO vo=service.get(bno);
		model.addAttribute("vo", vo);
		//@ModelAttribute를 써서 view 페이지까지 자동으로 model.addAttribute 한 효과를 줌
	}
	@PostMapping("/modify")
	public String modify(BoardVO vo,RedirectAttributes rttr) throws Exception {
		log.info("게시글 수정 요청.....");
		if(service.modify(vo)) {		
			rttr.addFlashAttribute("result", "success");
		}	
		
		return "redirect:list";
	}
	@PostMapping("/remove")
	public String remove(int bno,RedirectAttributes rttr) throws Exception {
		log.info("게시글 삭제 요청.....");
		
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}			
		return "redirect:list";
	}*/	
}


