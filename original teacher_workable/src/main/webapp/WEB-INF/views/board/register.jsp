<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="/resources/dist/css/upload.css" />
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
                           Board Register Page
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                			<form action="" method="post" role="form">
                				<div class="form-group">
                					<label>Title</label>
                					<input class="form-control" name="title">                				
                				</div>  
                				<div class="form-group">
                					<label>Content</label>
                					<textarea class="form-control" rows="3" name="content"></textarea>               				
                				</div> 
                				<div class="form-group">
                					<label>Writer</label>
                					<input class="form-control" name="writer">                				
                				</div>  
                				<button type="submit" class="btn btn-default">Submit</button>              			
                				<button type="reset" class="btn btn-default">reset</button>              			
                			</form>
                		</div>
                	</div>
                </div>
            </div> 
             <!-- 파일 등록 부분 --> 
            <div class="row">
            	<div class="col-lg-12">
            		<div class="panel panel-default">
            			<div class="panel-heading">File Attach</div>
            			<div class="panel-body">
            				<div class="form-group uploadDiv">
            					<input type="file" name="uploadFile" multiple>
            				</div>
            				<div class='uploadResult'>
								<ul>
						
								</ul>
							</div>
            			</div><!-- end uploadResult -->
            		</div><!-- end panel-default -->
            	</div>
            </div> 
<script>
$(function(){				
	
	/* Register 폼의 submit 버튼을 클릭하면 전송이 이뤄지기 때문에 일단 이벤트 막기 */
	var formObj=$("form[role='form']");
	$("button[type='submit']").click(function(e){
		e.preventDefault();   //submit 버튼 가는 것 방지
		
		var str="";
		//uploadResult ul li가 가지고 있는 값 수집하기
		$(".uploadResult ul li").each(function(i,obj){
			
			var job=$(obj);	//obj.data 는 할 수 없음		
			
			str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+job.data("uuid")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+job.data("path")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+job.data("filename")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+job.data("type")+"'>";		
		});
		formObj.append(str).submit();		
	});
	
	//처음에 띄워서 보여줄 때
	/* function showUploadedFile(uploadResultArr){
		var str = "";
		var uploadResult = $(".uploadResult ul");
					
		$(uploadResultArr).each(
			function(i, obj) {							
				if (!obj.fileType) {
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);				
					
					str+="<li><div>";
					str+="<span>"+obj.fileName+"</span> ";					
					str+="<button type='button' class='btn btn-warning btn-circle btn-sm'><i class='fa fa-times'></i></button><br>";
					str+="<a href='/download?fileName="+fileCallPath+"'>";
					str+="<img src='/resources/img/attach.png'></a>";					
					str+="</div></li>";				
				} else {
					var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
					var originPath=obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;					
					originPath = originPath.replace(new RegExp(/\\/g),"/");
					str+="<li><div>";
					str+="<span>"+obj.fileName+"</span> ";	
					str+="<button type='button' class='btn btn-warning btn-circle btn-sm'><i class='fa fa-times'></i></button><br>";
					str+="<a href=\"javascript:showImage(\'"+originPath+"\')\">";					
					str+="<img src='/display?fileName="+fileCallPath+"'></a>";					
					str+="</div></li>";							
				}
			}); 
			uploadResult.append(str);
	} */
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
	
	
	// x 누르면 파일 삭제하기
	$(".uploadResult").on("click","button",function(){
		 var targetFile = $(this).data("file");
		 var type = $(this).data("type");
		 
		 var targetLi = $(this).closest("li");
		 $.ajax({
			url : '/deleteFile',
			dataType:'text',
			data:{
				fileName:targetFile,
				type:type
			},
			type:'post',
			success:function(result){
				console.log(result);
				targetLi.remove();
			}
		 });
	});
});


</script>   	    	          
<%@include file="../includes/footer.jsp" %>       