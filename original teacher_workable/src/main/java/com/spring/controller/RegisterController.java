package com.spring.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.RegisterVO;
import com.spring.service.RegisterService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/regist/*")
public class RegisterController {
	// regist로 들어오는것 전부처리
	@Inject
	private RegisterService service;

	// http:localhost:8090/step1
	@GetMapping("/step1")
	public void step1() {
		log.info("step1호출...");
	}

	@PostMapping("/step2")
	public String step2(@RequestParam(value = "agree", defaultValue = "false") boolean agree, RedirectAttributes rttr) {
		log.info("회원 가입 폼 요청...");
		// 약관동의 여부 체크하기
		// 약관동의 안했다면 stpe1페이지로 돌려보내고
		// 동의를 했다면 step2 페이지가 보여지도록 코드 작성
		if (!agree) {
			rttr.addFlashAttribute("check", false);
			return "redirect:step1"; // redirect step1 포워드 -> /regist/step1
		}
		return "/regist/step2";
	}

	// http://localhost:8083/regist/step3
	// step2.jsp에서 넘어오는 데이터 모두 가져오기 -> step2에서 가져올것 보기
	// 가져온 데이터 로그로 확인

	@PostMapping("/step3")
	public String step3(@ModelAttribute("vo")RegisterVO regVO) {
		log.info("회원가입요청...");
		log.info("결과값: " + regVO.toString());

		// password와 confirm_password가 같으면
		// step3.jsp로 이동
		// step3.jsp에서는 홍길동님 회원가입을 축하합니다...

		if (regVO.confirmation()) {
			// 회원가입
			int result = service.registMember(regVO);
			if (result > 0)
				return "redirect:/regist/step3"; // 인덱스로 이동(redirect방식)
		} else {
			return "/regist/step2"; // 사용자가 입력할 값을 다시 보여줄수 있다.
			// return"redirect:step2"; //처음상태로 페이지 보여주기 get방식에 대한 Mapping필요.
		}
		// 비밀번호가 다르면 step2.jsp로 이동
		return "/regist/step3";

	}

	// 직접 주소를 입력하여 중간단계부터 들어오는 것 제한
	@RequestMapping(value = { "/step2", "/step3" }, method = RequestMethod.GET)
	// @GetMapping(value= {"/step2","/step3"})
	public String handleStep2_3Get() {
		return "redirect:/";
	}
	
	//중복아이디 검사 
	// http://localhost:8083/regist/checkId
	//userid / post방식 
	@ResponseBody            
	//responsebody : 응답용 
	@PostMapping("/checkId")
	public String checkId(String userid) {
		log.info("userid run test" + userid);
		RegisterVO dupId = service.selectById(userid);
		//dupId가 널이 아니면이미 사용중인 아이디
		if(dupId!=null) {
			return "false";
		}
		return "true";
		//널이면 사용할 수 있는 아이디 
	}
	
}
