package com.spring.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.domain.AuthInfo;
import com.spring.domain.LoginVO;
import com.spring.domain.ModifyVO;
import com.spring.domain.RegisterVO;
import com.spring.mapper.RegisterMapper;

@Service("regist")
public class RegisterServiceImpl implements RegisterService {
	
	@Autowired
	private RegisterMapper mapper;
		
	@Override
	public RegisterVO selectById(String userid) {
		return mapper.selectById(userid);
	}

	@Override
	public int registMember(RegisterVO vo) {
		return mapper.registMember(vo);
	}
	
	@Override
	public AuthInfo selectMember(LoginVO vo) {
		return mapper.selectMember(vo);
	}

	@Override
	public int deleteMember(String userid) {
		return mapper.deleteMember(userid);
	}

	@Override
	public int updateMember(ModifyVO vo) {
		return mapper.updateMember(vo);
	}
	
	
}
