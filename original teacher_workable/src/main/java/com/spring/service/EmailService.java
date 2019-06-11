package com.spring.service;

import com.spring.domain.EmailVO;

public interface EmailService {
   public EmailVO getidforEmail(EmailVO vo);
   public EmailVO getpwforEmail(EmailVO vo);
}
