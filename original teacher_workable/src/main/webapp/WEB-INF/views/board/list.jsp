<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Spring Board</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Board List Page
                            <button id='regBtn' type='button' class='btn btn-xs pull-right'>Register New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                        <th>번 호</th>
                                        <th>제 목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <c:forEach var="vo" items="${list}">
                                   	<tr>
                                        <td>${vo.bno}</td>
                                        <td><a class='move' href="<c:out value='${vo.bno}'/>">${vo.title}<strong>[${vo.replycnt}]</strong></a></td>
                                        <td>${vo.writer}</td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${vo.regdate}"/></td>
                                        <td><fmt:formatDate pattern="yyyy-MM-dd" value="${vo.updatedate}"/></td>
                                    </tr>
                                </c:forEach>
                            </table> 
                            <div class="row"> <!-- start search -->
                            	<div class="col-md-12">
                            	  <div class="col-md-8">
                            		<form id="searchForm" action="" method="get">
                            			<select name="type">
                            				<option value="" <c:out value="${empty cri.type?'selected':''}"/>>---</option>	
                            				<option value="T" <c:out value="${cri.type eq 'T'?'selected':''}"/>>제목</option>	
                            				<option value="C" <c:out value="${cri.type eq 'C'?'selected':''}"/>>내용</option>	
                            				<option value="W" <c:out value="${cri.type eq 'W'?'selected':''}"/>>작성자</option>	
                            				<option value="TC" <c:out value="${cri.type eq 'TC'?'selected':''}"/>>제목  or 내용</option>	
                            				<option value="TW" <c:out value="${cri.type eq 'TW'?'selected':''}"/>>제목  or 작성자</option>                           			
                            				<option value="TCW" <c:out value="${cri.type eq 'TCW'?'selected':''}"/>>제목  or 내용  or 작성자</option>	
                            			</select>
                            			<input type="text" name="keyword" value="${cri.keyword}">
                            			<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
								  		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
                            			<button class="btn btn-default">Search</button>
                            	   	</form>
                            	   </div>
                            	   <div class="col-md-2 col-md-offset-2">
                            	   	<select class="form-control" id="amount">						
										<option value="10" <c:out value="${cri.amount eq 10?'selected':''}"/>>10</option>				
										<option value="20" <c:out value="${cri.amount eq 20?'selected':''}"/>>20</option>
										<option value="30" <c:out value="${cri.amount eq 30?'selected':''}"/>>30</option>
										<option value="40" <c:out value="${cri.amount eq 40?'selected':''}"/>>40</option>
										<%-- 
										  컨트롤러에서 @ModelAttribute("cri") 를 앞에 붙였으면 해도 됨
										<option value="10" <c:out value="${pageMaker.cri.perPageNum eq 10?'selected':''}"/>>10</option>				
										<option value="20" <c:out value="${pageMaker.cri.perPageNum eq 20?'selected':''}"/>>20</option>
										<option value="30" <c:out value="${pageMaker.cri.perPageNum eq 30?'selected':''}"/>>30</option>
										<option value="40" <c:out value="${pageMaker.cri.perPageNum eq 40?'selected':''}"/>>40</option> --%>
								  	</select>	
								  </div>								  
                             	 </div>                             	 
                      		 </div><!-- end search -->
                      		<!-- start Pagination -->
                            <div class="text-center">
                            	<ul class="pagination justify-content-center">
                            		<c:if test="${pageMaker.prev}">
                            			<li class="paginate_button previous">
                            				<a href="${pageMaker.startPage-1}">Previous</a>
                            			</li>
                            		</c:if>
                            		<c:forEach var="idx" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">                            			
                            			<li class="paginate_button ${pageMaker.cri.pageNum==idx?'active':''}">
                            				<a href="${idx}">${idx}</a>
                            			</li>
                            		</c:forEach>
                            		<c:if test="${pageMaker.next}">
                            			<li class="paginate_button next">
                            				<a href="${pageMaker.endPage+1}">Next</a>
                            			</li>
                            		</c:if>
                            	</ul>
                            </div><!-- end Pagination -->                          
                           </div><!-- end panel-body -->
                        </div><!-- end panel -->
                    </div>                   
                   </div> <!-- /.row -->
             <%-- 1234 하단의 페이지번호를 클릭하면 보낼 데이터 폼 구성 --%>
			<form id='actionForm' action="/board/list" method="get">
				<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}" />
				<input type="hidden" name="amount" value="${pageMaker.cri.amount}" />
				<input type="hidden" name="type" value="${pageMaker.cri.type}">
				<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
			</form>	              
               <!-- Modal 추가 -->
            <div class="modal" tabindex="-1" role="dialog" id="myModal">
			  <div class="modal-dialog" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title">게시글 등록</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div class="modal-body">
			        <p>처리가 완료되었습니다.</p>
			      </div>
			      <div class="modal-footer">
			        <button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>			        
			      </div>
			    </div>
			  </div>
			</div><!-- 모달 -->							
<script>
	$(function(){
		var result='${result}';					
		checkModal(result);
		//체크 모달 호출 뒤에 data, title, url 값을  세팅					
		history.replaceState({}, null, null);
		
		function checkModal(result){					
			if(result==='' || history.state)
			//if(result==='')
				return;
			if(parseInt(result)>0){
				$(".modal-body").html("게시글 "+parseInt(result) + "번이 등록되었습니다.");
			}
			$("#myModal").modal("show"); 						
		}
		
		$("#regBtn").click(function(){
			location.href="/board/register";
		});
		
		$(".form-control").change(function(){
			//사용자가 선택한 페이지당 개수 가져오기
			var amount=$(this).val();
			//폼 가져오기
			var actionForm=$("#actionForm");
			
			//폼에 사용자가 선택한 페이지 값 다시 세팅
			actionForm.find("[name='amount']").val(amount);
			//폼 보내기
			actionForm.submit();
		});
		
		// 하단의 페이지 나누기 번호 클릭시
		var actionForm=$("#actionForm");
		$(".paginate_button a").on("click",function(e){
			e.preventDefault();						
			//actionForm안의 pageNum 값은 사용자가 누르는 번호의 값으로 세팅되어야 하기 때문에
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		// 타이틀을 누르면 내용보기로 들어갈 때 현재 페이지 번호와 페이지당 출력물 갯수 가져가도록 하기
		$(".move").on("click",function(e){
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action","/board/read");
			actionForm.submit();
		});
		
		
		$(".btn-default").click(function(){
			var searchForm=$("#searchForm");
			if(!searchForm.find("option:selected").val()){
				alert("검색 종류를 선택하세요");							
				return false; //return false; 무조건
			}
			
			if(!searchForm.find("input[name='keyword']").val()){
				alert("검색어를 선택하세요");
				searchForm.find("input[name='keyword']").focus();
				return false;
			}
			//버튼을 누르면 무조건 첫 검색이기 때문에 페이지는 1로 세팅
			searchForm.find("input[name='pageNum']").val("1");
			//e.preventDefault(); //<button> 가버림			
			searchForm.submit();
		});					
	});				
</script>			
<%@include file="../includes/footer.jsp" %>    