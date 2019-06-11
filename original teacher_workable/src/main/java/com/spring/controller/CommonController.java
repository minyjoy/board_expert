package com.spring.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.domain.AuthInfo;
import com.spring.domain.LoginVO;
import com.spring.domain.MemberVO;
import com.spring.service.RegisterService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CommonController {

	@Inject
	private RegisterService service;

	@GetMapping("/signin")
	public void goSignIn() {
		log.info("SignIn 호출");
	}

	@GetMapping("/")
	public String index() {
		log.info("index 호출");
		return "index";
	}

	@GetMapping("/logout")
	public void logout() {
		log.info("logOut 호출");

	}

	@PostMapping("/logout")
	public void logoutPost() {
		log.info("logout 요청");
	}

	@PostMapping("/login")
	public String login(LoginVO vo, RedirectAttributes rttr) {
		log.info("login 호출");
		log.info("결과값:" + vo.toString());
			
		AuthInfo result = service.selectMember(vo);
			
		if (result != null) {
			rttr.addFlashAttribute("userid", result.getUserid());
			return "redirect:/board/list";
		}
		return "redirect:/signin";
	}
	

}
