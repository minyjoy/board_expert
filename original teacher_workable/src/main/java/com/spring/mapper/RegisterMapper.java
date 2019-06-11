package com.spring.mapper;

import com.spring.domain.AuthInfo;
import com.spring.domain.LoginVO;
import com.spring.domain.ModifyVO;
import com.spring.domain.RegisterVO;

public interface RegisterMapper {
	// 중복아이디 검사
	public RegisterVO selectById(String userid);

	// 회원가입
	public int registMember(RegisterVO vo);

	// 로그인
	public AuthInfo selectMember(LoginVO vo);

	// 삭제
	public int deleteMember(String userid);

	// 비밀번호 변경
	public int updateMember(ModifyVO vo);
}
