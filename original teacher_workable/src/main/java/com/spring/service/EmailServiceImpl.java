package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.EmailVO;
import com.spring.mapper.EmailMapper;

@Service
public class EmailServiceImpl implements EmailService{

	@Autowired
	private EmailMapper mapper;
	
	@Override
	public EmailVO getidforEmail(EmailVO vo) {
		
		return mapper.getidforEmail(vo);
	}

	@Override
	public EmailVO getpwforEmail(EmailVO vo) {
		return mapper.getpwforEmail(vo);
	}

}
