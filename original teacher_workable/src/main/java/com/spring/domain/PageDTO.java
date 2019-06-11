package com.spring.domain;

import org.springframework.web.util.UriComponents;
import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	private int startPage;
	private int endPage;
	private boolean prev;
	private boolean next;
	
	//화면 하단의 보여줄 페이지 수	
	private int total;	
	private Criteria cri;

	public PageDTO(Criteria cri,int total) {
		super();
		this.total = total;
		this.cri = cri;
		
		
		//추가
		this.endPage=(int)(Math.ceil(cri.getPageNum()/10.0))*10;
		this.startPage=this.endPage - 9;
		
		int realEnd = (int)(Math.ceil((total/1.0) / cri.getAmount()));
		if(realEnd<this.endPage) {
			this.endPage=realEnd;
		}
		this.prev = this.startPage>1;
		this.next = this.endPage < realEnd;
	}
	
	//URI 수정
	public String makeQuery(int page) {
		UriComponents uriCom=UriComponentsBuilder.newInstance()
				.queryParam("page", page)
				.queryParam("perPageNum", cri.getPageNum())
				.build();
		return uriCom.toUriString();		
	}



	



	
	//search 부분 추가
	/*public String makeSearch(int page) {
		UriComponents uriCom=UriComponentsBuilder.newInstance()
				.queryParam("page", page)
				.queryParam("perPageNum", cri.getPerPageNum())
				.queryParam("searchType", ((SearchCriteria)cri).getType())
				.queryParam("keyword", ((SearchCriteria)cri).getKeyword())
				.build();
		return uriCom.toUriString();		
	}	*/
}
