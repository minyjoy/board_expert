<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@include file="../includes/header.jsp" %>
            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Spring Board</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>            
            <div class="row">
                <div class="col-lg-12">
                	<div class="panel panel-default">
                        <div class="panel-heading">
                           Board Read Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" readonly="readonly" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content" readonly="readonly">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>                				             			
                				<button type="button" class="btn btn-default">Modify</button>                				    			
                				<button type="reset" class="btn btn-info">List</button>              			
                			</form>                			
                		</div>
                	</div>
                </div>
            </div>
            <!-- 첨부파일 목록 -->
            <div class='bigPictureWrapper'>
			  <div class='bigPicture'>
			  </div>
			</div>
            
            <link rel="stylesheet" href="/resources/dist/css/upload.css"/>
            
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">Files</div>
            				<div class="panel-body">
            					<div class="uploadResult">
            						<ul></ul>
            					</div>
            				</div>
            		</div>
            	</div>            
            </div>
            
            <!-- 댓글 영역 -->
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">
	            			<i class="fa fa-comments fa-fw"></i>      				
	            			Reply
	            			<button id='addReplyBtn' class='btn btn-primary btn-xs pull-right' data-toggle="modal">New Reply</button>
            			</div><!-- ./ end panel-heading  --> 
            			<div class="panel-body">
            				<ul class="chat">
            					<!--  start reply -->
            					<li class="left clearfix" data-rno='12'>
            						<div>
            							<div class="header">
	            							<strong class="primary-font">user00</strong>
	            							<small class="pull-right text-muted">2018-11-06 10:10</small>
            							</div>
            							<p>Good Job!!!</p>
            						</div>            						
            					</li>
            				</ul>            			
            			</div><!-- ./ end panel-body  --> 
            			<div class="panel-footer"> <!-- 댓글 페이지 영역 -->
            			
            			</div>
            		</div>
            	</div>
            </div>           
            
            <!-- 댓글 등록  버튼 누르면  Modal -->
            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                            <h4 class="modal-title" id="myModalLabel">Reply Modal</h4>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                            	<label>Reply</label>
                            	<input class="form-control" name="reply" value="New Reply">
                            </div>
                            <div class="form-group">
                            	<label>Replyer</label>
                            	<input class="form-control" name="replyer" value="replyer">
                            </div>
                            <div class="form-group">
                            	<label>Reply Date</label>
                            	<input class="form-control" name="replyDate" value="">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-warning" id="modalModBtn">Modify</button>
                            <button type="button" class="btn btn-danger" id="modalRemoveBtn">Remove</button>
                            <button type="button" class="btn btn-primary" id="modalRegisterBtn">Register</button>
                            <%-- 버튼 색상 중요함 교재에 있는 색상으로 하면 그냥 가버림 --%>
                            <button type="button" class="btn btn-success" id="modalCloseBtn">Close</button>                            
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->           
            <form id="operForm" action="/board/modify">
            	<input type="hidden" value="${vo.bno}" name="bno">
            	<input type="hidden" value="${cri.pageNum}" name="pageNum">  <!-- cri.pageNum 가능 -->
            	<input type="hidden" value="${cri.amount}" name="amount">
            	<input type="hidden" value="${cri.type}" name="type">
            	<input type="hidden" value="${cri.keyword}" name="keyword">
            </form> 
          
            
 <script src="/resources/js/reply.js"></script>  
 <script>
   	$(function(){
   		//현재 글 번호 가져오기
   		var bnoValue=${vo.bno};
   		
   		var replyUL=$(".chat");
   		
   		
   		//댓글 페이지 나누기 영역 가져오기    
   		var pageNum=1;
   		var replyPageFooter = $(".panel-footer");
   		
   		function showReplyPage(replyCnt){            			    			
   			
   			var endNum = Math.ceil(pageNum/10.0)*10;
   			var startNum = endNum-9;
   			var prev = startNum != 1;
   			var next = false;
   			
   			if(endNum*10 >= replyCnt){
   				endNum=Math.ceil(replyCnt/10.0);
   			}
   			if(endNum*10 < replyCnt){
   				next=true;
   			}
   			
   			var str="<ul class='pagination pull-right'>";
   			
   			if(prev){
   				str+="<li class='page-item'><a class='page-link' href='"
   				+(startNum-1)+"'>Previous</a></li>"
   			}
   			
   			for(var i=startNum;i<=endNum;i++){
   				var active = pageNum == i ? "active" : "";
   				str+="<li class='page-item "+active+" '><a class='page-link' href='"
   				+i+"'>"+i+"</a></li>";
   			}            			
   			if(next){
   				str+="<li class='page-item'><a class='page-link' href='"+
   				(endNum+1)+"'>Next</a></li>";
   			}            			
   			str+="</ul></div>";
   			
   			console.log(str);
   			
   			replyPageFooter.html(str);
   		}//reply 페이지 처리
   		
   		//지금 현재 안보이는 영역 이벤트 위임으로 처리하기
   		//페이지 번호 클릭했을 때 새로운 댓글 가져오기   		
   		replyPageFooter.on("click","li a",function(e){
   			e.preventDefault(); 			
   			
   			pageNum=$(this).attr("href");  			
   			            			
   			showList(pageNum);
   		});
   		
   		
   		
   		showList(1);
   		//댓글 페이지에 맞춰 가져오기(페이지 나누기 전)
   		/* function showList(page){
    		replyService.getList({bno:bnoValue,page:page||1},function(list){    			        				            			
    			
    			console.log("data-list : "+list.length);
    			
    			var str="";
    			if(list == null ||list.length==0){
    				replyUL.html("");	            				
    				return;
    			}
    			
    			//디자인 부분의 ul아래부분 반복시키는 영역 써주기
    			for(var i=0,len=list.length||0; i<len; i++){	            				
    				str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
    				str+="<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
    				str+="<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
    				str+="<p>"+list[i].reply+"</p></div></li>";
    			}              			
    			replyUL.html(str);    			
    		  });   //reply.getList 종료        		
		} */
   		//---- 페이지 나누기 전   showList종료		
		
   		
   		//페이지 나누기 후
   		function showList(page){
   			replyService.getList({bno:bnoValue,page:page||1},
   				function(replyCnt,list){    			        				            			
   			
	   			console.log("replyCnt : "+replyCnt);
	   			
	   			if(page==-1){
	   				pageNum=Math.ceil(replyCnt/10.0);
	   				showList(pageNum);
	   				return;
	   			}
	   			
	   			var str="";
	   			if(list == null ||list.length==0){    				          				
	   				return;
	   			}
	   			
	   			//디자인 부분의 ul아래부분 반복시키는 영역 써주기
	   			for(var i=0,len=list.length||0; i<len; i++){	            				
	   				str+="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
	   				str+="<div><div class='header'><strong class='primary-font'>"+list[i].replyer+"</strong>";
	   				str+="<small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
	   				str+="<p>"+list[i].reply+"</p></div></li>";
	   			}              			
	   			replyUL.html(str);  
	   			showReplyPage(replyCnt);
   		  });   //reply.getList 종료        		
		}  		
   		
   		//페이지 나누기 후
		
   		//댓글 작업 시작   		
   		//댓글 등록
   		/* replyService.add({bno:bnoValue,replyer:'test',reply:"댓글 테스트...."},function(result){
   			if(result){
   				alert("result : "+result);
   			}
   		});//add 종료   		
   		   		
   		replyService.remove(17,function(result){
   			if(result==='SUCCESS'){
   				alert('삭제 성공');
   			}   			
   		}); //remove 종료 */
   		
   		/* replyService.update({rno:16,reply:"댓글 수정을 합시다.22"},function(result){
   			if(result==='SUCCESS'){
   				alert('수정 성공');
   			}
		}); //update 종료 */
		
		/* replyService.get(16,function(data){
   			console.log(data);
   		}); //get 종료 */
   		
   		
		//모달 처리
   		var modal=$(".modal");
   		var modalInputReply = modal.find("input[name='reply']");
   		var modalInputReplyer = modal.find("input[name='replyer']");
   		//댓글을 쓸 때는 필요없으나 내용보기 할 때 시간 필요
   		var modalInputReplyDate = modal.find("input[name='replyDate']");
   		
   		var modalModBtn = $("#modalModBtn");
   		var modalRemoveBtn = $("#modalRemoveBtn");
   		var modalRegisterBtn = $("#modalRegisterBtn");
   		
	   	$("#modalCloseBtn").on("click", function(e){      	
	      	modal.modal("hide");	      
	    });
   		
   		
   		$("#addReplyBtn").on("click",function(){
   			modal.find("input").val("");
   			//date가 들어가 있는 div 영역 안 보이게 하고
   			modalInputReplyDate.closest("div").hide();
   			//close 버튼만 제외하고 전부 버튼 안보이게 한 후
   			modal.find("button[id!='modalCloseBtn']").hide();
   			//등록 버튼만 다시 보이게 만들기
   			modalRegisterBtn.show();   			
   			modal.modal("show");   			
   		});    		
   		
   		
   		$("#modalRegisterBtn").on("click",function(){
   			var reply = {
   				reply:modalInputReply.val(),
   				replyer : modalInputReplyer.val(),
   				bno:bnoValue
   			};
   			//댓글 등록
			replyService.add(reply,
				function(result){ //callback에 해당하는 부분
				//	if(result==='SUCCESS'){
        		//	alert("삽입성공");
        				
        			modal.find("input").val("");
        			modal.modal("hide");
        			//댓글 갱신(페이지 나누기 전)
        			//showList(1);
        			//댓글 갱신(페이지 나누기 후)
        			showList(-1);
        		//}	
			});
   		});	//댓글등록            		
   					
   		//댓글 삭제
   		$("#modalRemoveBtn").click(function(){
    		replyService.remove(modal.data("rno"),function(result){
    			alert(result);
    			modal.modal("hide");
       			//showList(1); 처음 무조건 첫 페이지 띄우기
       			showList(pageNum);
    		}); 
   		});
   		
   		//댓글 수정
   		//modalModBtn.click(function(){ => 동작 안함
   		//modalModBtn.on("click",function(){ => 이래야 동작
   		$("#modalModBtn").on("click",function(){
   			var reply={rno:modal.data("rno"),reply:modalInputReply.val()};
   			
   			replyService.update(reply,function(result){
       			alert(result);
       			
       			modal.modal("hide");
       			//showList(1);
       			showList(pageNum);
       		});
   		});//댓글 수정 종료
   		
   		$(".chat").on("click","li",function(){ //이름에 링크 걸림
   			var rno=$(this).data("rno");
   			
   			//댓글 하나 읽어오기
       		replyService.get(rno,function(data){
       			modalInputReply.val(data.reply);
       			modalInputReplyer.val(data.replyer);
       			modalInputReplyDate.val(replyService.displayTime(data.replyDate)).attr("readonly","readonly");
       			modal.data("rno",data.rno);
       			
       			modal.find("button[id!='modalCloseBtn']").hide();
       			modalModBtn.show();
       			modalRemoveBtn.show();
     			modal.modal("show");
       		});
   		});//이벤트 위임 종료
   	});
 </script>      		                 	
<script>
  	$(function(){    
  		var form=$("#operForm");
  		
  		$(".btn-default").click(function(){
  			form.submit();
  	});
	$(".btn-info").click(function(){
		form.find("input[name='bno']").remove();
		form.attr("action","/board/list")
			.attr("method","get")
			.submit();            			
	       		});
	 });
</script>  
<script>
	//읽으로 올 때 첨부물을 가져오기 위해 바로 호출되는 부분
	$(document).ready(function(){
		var bno=${vo.bno};
		
		var uploadResult=$(".uploadResult ul");
		var str="";
		$.getJSON("/board/getAttachList",{bno:bno},function(data) {			
			console.log(data);			
			$(data).each(function(i,attach){
				if(!attach.fileType){
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='";
					str += attach.fileName+"' data-type='"+attach.fileType+"'><div>";
					str += "<span>"+attach.fileName+"</span><br/>";
					str += "<a><img src='/resources/img/attach.png'></a></div></li>";					
				}else{
					var fileCallPath=encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
    				
					str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='";
					str += attach.fileName+"' data-type='"+attach.fileType+"'><div>";								
					str += "<img src='/display?fileName="+fileCallPath+"'></a>";
					str += "</div></li>";
				}			
			});	
			uploadResult.html(str);
		});
		
		// 이미지 클릭 시 화면 크게, 파일은 다운로드
		$(".uploadResult").on("click","li",function(){
			 var liObj =$(this);
			 
			 var path=encodeURIComponent(liObj.data("path")+"/"
					 +liObj.data("uuid")+"_"+liObj.data("filename"));
			 
			 if(liObj.data("type")){
				 showImage(path.replace(new RegExp(/\\/g),"/"));
			 }else{
				 self.location="/download?fileName="+path;
			 }
		});            		
		
		$(".bigPictureWrapper").on("click",function(){
			 $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
			 setTimeout(function(){
				 $(".bigPictureWrapper").hide(); //이전 소스랑 달라짐
			 },1000);					 
		});					
	});	           		     		

	function showImage(fileCallPath){
		  
		  $(".bigPictureWrapper").css("display","flex").show();
		  
		  $(".bigPicture")
		  .html("<img src='/display?fileName="+fileCallPath+"'>")
		  .animate({width:'100%', height: '100%'}, 1000);
	}//무조건 밖으로 빼기 $(function 안에 넣지 말기)
	
</script>
<%@include file="../includes/footer.jsp" %>  
