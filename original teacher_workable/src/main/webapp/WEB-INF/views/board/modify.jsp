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
                           Board Modify Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" method="post" role="form">
                				<div class="form-group">
                					<label>Bno</label>
                					<input class="form-control" name="bno" readonly="readonly" value="${vo.bno}">                				
                				</div> 
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title" value="${vo.title}">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content">${vo.content}</textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer" readonly="readonly" value="${vo.writer}">                				
                				</div>                				
                				<button type="submit" data-oper='modify' class="btn btn-default">Modify</button>              			
                				<button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>              			
                				<button type="submit" data-oper='list' class="btn btn-info">List</button>   
                				<!-- 수정할 때 현재 페이지 번호와 글 목록 갯수 보내야 하는데 read,modify가 컨트롤러를 같이 처리하기 때문에
                				안보내도 됨 -->
                				<%-- <input type="hidden" value="${cri.pageNum}" name="pageNum">
								<input type="hidden" value="${cri.amount}" name="amount">     --%>       			
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
            					<div class="form-group uploadDiv">
            						<input type="file" name="uploadFile" multiple>
            					</div>            				
            					<div class="uploadResult">
            						<ul></ul>
            					</div>
            				</div>
            		</div>
            	</div>            
            </div>            
              
            <%-- remove와 list를 위한 폼--%>
            <form name="form1" method="post">    
            	<input type="hidden" value="${vo.bno}" name="bno">  
            	<input type="hidden" value="${cri.pageNum}" name="pageNum">
				<input type="hidden" value="${cri.amount}" name="amount">		     					
				<input type="hidden" value="${cri.keyword}" name="keyword">
				<input type="hidden" value="${cri.type}" name="type"> 				
            </form>    
<script>
  	$(function(){
  		var formObj=$("form[name='form1']");
  		
  		$("button").click(function(e){
  			//submit이기 때문에 가는 것 막고
  			e.preventDefault();
  			
  			var oper=$(this).data("oper");
  			
  			if(oper==='remove'){            				
				formObj.attr("action","/board/remove");    					   						         				         				
  			}else if(oper==='list'){            				
  				formObj.attr("action","/board/list")
	  				 .attr("method","get");
  				//폼 태그 안의 내용 중 bno만 삭제하고 폼 보내기
  				formObj.find("input[name='bno']").remove();
  			}else if(oper==='modify'){
  				//modify인 경우는 본인 폼 보내기
  				formObj=$("form[role='form']");
  				
  				//첨부파일 목록 가져가기
  				var str="";
   			 	$(".uploadResult ul li").each(function(i,obj){
       				var data=$(obj);
       			    
       				str+="<input type='hidden' name='attachList["+i+"].fileName'";
       				str+=" value='"+data.data('filename')+"'>";
       				str+="<input type='hidden' name='attachList["+i+"].uuid'";
       				str+=" value='"+data.data('uuid')+"'>";
       				str+="<input type='hidden' name='attachList["+i+"].uploadPath'";
       				str+=" value='"+data.data('path')+"'>";
       				str+="<input type='hidden' name='attachList["+i+"].fileType'";
       				str+=" value='"+data.data('type')+"'>";    				
       			});  //each 종료                			
   				formObj.append(str).submit(); 				
  			}            			
  			formObj.submit();
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
			$(data).each(function(i,obj){
				if (!obj.fileType) {
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);				
					
					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
					str+="<div>";
					str+="<span>"+obj.fileName+"</span> ";					
					str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+fileCallPath+"' data-type='file'>";
					str+="<i class='fa fa-times'></i></button><br>";
					str+="<a href='/download?fileName="+fileCallPath+"'>";
					str+="<img src='/resources/img/attach.png'></a>";					
					str+="</div></li>";				
				} else {
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					var originPath=obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;					
					originPath = originPath.replace(new RegExp(/\\/g),"/");
					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
					str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
					str+="<div>";
					str+="<span>"+obj.fileName+"</span> ";	
					str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+fileCallPath+"' data-type='file'>";
					str+="<i class='fa fa-times'></i></button><br>";
					str+="<a href=\"javascript:showImage(\'"+originPath+"\')\">";					
					str+="<img src='/display?fileName="+fileCallPath+"'></a>";					
					str+="</div></li>";							
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
		
		function checkExtension(fileName,fileSize){
			//파일 업로드가 가능한 파일인지 확인하는 코드 작성
			//파일 업로드 불가능
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; //5MB
			if(fileSize>maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		//$("#uploadBtn").click(function(){ 를 아래로 변경
		$("input[type='file']").change(function(){
							
			var formData = new FormData();
			//여러개의 파일이 올라오면 배열로 받게 됨
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			
			for(var i=0;i<files.length;i++){
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile",files[i]);
			}
			
			//위 작업이 다 끝난 후 ajax 호출
			$.ajax({
				url:'/uploadAjax',
				processData : false,  //무조건 필요
				contentType : false,   //무조건 필요
				data: formData,
				type:'post',
				dataType:'json',
				success:function(result){
					console.log(result);
					showUploadedFile(result);
					//$(".uploadDiv").html(cloneObj.html());
				},
				/* error:function(request,status,error){
			        alert("code:"+request.status+"\n"+"message:"
			        		+request.responseText+"\n"+"error:"+error);
			    }	 */								
			});									
		}); //uploadBtn
		
		
		// 수정에서 x는 게시물 수정버튼이 눌러졌을 때 db에 반영해야 함
		// 첨부물만 삭제하고 수정버튼을 안 누르고 나갈 수도 있기 때문임
		$(".uploadResult").on("click","button",function(){
						 
			 if(confirm("정말로 파일을 삭제하시겠습니까?")){
					var targetLi=$(this).closest("li");
					targetLi.remove();
				}
		 });
	
		
		function showUploadedFile(uploadResultArr){
			var str = "";
			var uploadResult = $(".uploadResult ul");
						
			$(uploadResultArr).each(
				function(i, obj) {							
					if (!obj.fileType) {
						var fileCallPath=encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);				
						
						str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
						str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
						str+="<div>";
						str+="<span>"+obj.fileName+"</span> ";					
						str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+fileCallPath+"' data-type='file'>";
						str+="<i class='fa fa-times'></i></button><br>";
						str+="<a href='/download?fileName="+fileCallPath+"'>";
						str+="<img src='/resources/img/attach.png'></a>";					
						str+="</div></li>";				
					} else {
						var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						var originPath=obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;					
						originPath = originPath.replace(new RegExp(/\\/g),"/");
						str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'";
						str+=" data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'>";
						str+="<div>";
						str+="<span>"+obj.fileName+"</span> ";	
						str+="<button type='button' class='btn btn-warning btn-circle' data-file='"+fileCallPath+"' data-type='file'>";
						str+="<i class='fa fa-times'></i></button><br>";
						str+="<a href=\"javascript:showImage(\'"+originPath+"\')\">";					
						str+="<img src='/display?fileName="+fileCallPath+"'></a>";					
						str+="</div></li>";							
					}
				}); 
				uploadResult.append(str);
			}
	});	           		     		

	function showImage(fileCallPath){
		  
		  $(".bigPictureWrapper").css("display","flex").show();
		  
		  $(".bigPicture")
		  .html("<img src='/display?fileName="+fileCallPath+"'>")
		  .animate({width:'100%', height: '100%'}, 1000);
	}//무조건 밖으로 빼기 $(function 안에 넣지 말기)
	
</script>  
<%@include file="../includes/footer.jsp" %>  


   