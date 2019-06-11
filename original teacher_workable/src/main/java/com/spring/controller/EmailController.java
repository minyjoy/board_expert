package com.spring.controller;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.domain.EmailVO;
import com.spring.service.EmailService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class EmailController {
	
	@Autowired
	private EmailService service;
	
	@GetMapping("/findid")
	public String EmailSend() {
		log.info("findid호출");
		return "find/findid";
	}
	
	@PostMapping("/findid")
	public String EmailIdSend(EmailVO vo) {
		log.info("email 아이디 전송 테스트...");
       EmailVO resultVO = service.getidforEmail(vo);
       resultVO.setChoice(0);
       sendEmail(resultVO);
		return "redirect:/";
	}
	
	@GetMapping("/findPwd")
	public String EmailPwSend() {
		log.info("findid호출");
		return "find/findpwd";
	}
	
	
	@PostMapping("/findPwd")
	public String EmailPwSend(EmailVO vo) {
		log.info("email 비밀번호 전송 테스트...");
        EmailVO resultVO = service.getpwforEmail(vo);
        resultVO.setChoice(1);
        sendEmail(resultVO);
		return "redirect:/";
	}

	
	public void sendEmail(EmailVO vo) {
		String choiceR = "";
		if(vo.getChoice() == 0) {
			choiceR = "아이디";
		}else {
			choiceR = "비밀번호";
		}
		String host = "smtp.naver.com";
		final String user = "minyjoy";
		final String password = "dpshrdl23";

		String to = vo.getUseremail();

		Properties pro = new Properties();
		pro.put("mail.smtp.host", host);
		pro.put("mail.smtp.auth", "true");
		pro.put("mail.transport.protocol", "smtp");

		Session session = Session.getDefaultInstance(pro, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, password);
			}
		});
           
		try {
			MimeMessage message = new MimeMessage(session);
			if(vo.getUserid() != null) {
				message.setSubject(choiceR+" 찾기 결과");				
				message.setText("<h1>"+vo.getUseremail()+"님의 "+choiceR+"는 "+vo.getUserid()+"입니다.<h1>");
			}else
	        if(vo.getUserpassword() != null) {
	        	message.setSubject(choiceR+" 찾기 결과");				
	        	message.setText("<h1>"+vo.getUseremail()+"님의 "+choiceR+"는 "+vo.getUserpassword()+"입니다.<h1>");            	
	        	
	        }
			message.setFrom(new InternetAddress(user));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));

			Transport.send(message);
			System.out.println("메일 전송 완료~");
		} catch (MessagingException e) {
			e.printStackTrace();
			
		}
		log.info(choiceR+" 보내기를 성공헀습니다");
	}
}
