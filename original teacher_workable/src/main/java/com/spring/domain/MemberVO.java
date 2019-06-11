package com.spring.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class MemberVO {
 private String userid;
 private String password;
 private String name;
 private Date regdate;
 private String email;
 private String gender;
 private Date updateDate;
 private Boolean enabled;
 private Date userDate;
 
 private List<AuthVO> authList;
}
