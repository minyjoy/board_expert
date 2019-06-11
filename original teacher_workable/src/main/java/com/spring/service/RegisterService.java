package com.spring.service;

import com.spring.domain.AuthInfo;
import com.spring.domain.LoginVO;
import com.spring.domain.ModifyVO;
import com.spring.domain.RegisterVO;

public interface RegisterService {
	public RegisterVO selectById(String userid);
	public int registMember(RegisterVO vo);
	public AuthInfo selectMember(LoginVO vo);
	public int deleteMember (String userid);
	public int updateMember(ModifyVO vo);
	
	
}
