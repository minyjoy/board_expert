package com.spring.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Criteria {
	private int pageNum;  //페이지 번호
	private int amount;   //한 페이지당 몇 개의 데이터를 보여줄 것인가?	
	
	private String type;  //검색조건
	private String keyword; //검색어
	
	public Criteria() {
		this(1,10);
	}	
	
	public Criteria(int pageNum, int amount) {
		super();
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	//검색조건을 배열로 만들어 처리 : 검색조건이 T, W, C 이므로 배열 처리 
	public String[] getTypeArr() {
		return type==null ? new String[] {} : type.split("");
	}
}



/*private int perPageNum;
private String type;
private String keyword;	*/