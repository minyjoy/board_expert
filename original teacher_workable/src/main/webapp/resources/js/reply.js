/**
 * reply.jsp의 댓글 구성을 위한 스크립트
 */
var replyService=(function(){
	//private
	function add(reply,callback){
		console.log("add method 실행");
		
		//가져온 데이터를 컨트롤러 호출
		$.ajax({
			type:'post',
			url : '/replies/new',
			contentType: 'application/json;charset=utf-8',
			data: JSON.stringify(reply),
			success:function(result){				
				if(callback)
					callback(result);
			}
		});		
	}//add 종료
	function getList(param,callback){
		var bno=param.bno;
		var page=param.page || 1;
		
		console.log(bno+"bno ");
		console.log(page+" page");
		
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",
				function(data){
					console.log(data+" data");
						if(data!=null){
							if(callback)
								//callback(data);  //댓글 페이지 나누기 전
								callback(data.replyCnt,data.list);
						}
				}).fail(function(xhr,status,err){
					if(error)
						error();
				});
	} //getList종료
	function remove(rno,callback,error){
		console.log("remove 호출");
		$.ajax({
			type : 'delete',
			url : '/replies/'+rno,			
			success : function(result,status,xhr){
				if(callback)
					callback(result);
			},
			error:function(xhr,status,er){
				if(error){
					error(er);
				}
			}
		});
	}//remove종료
	
	function update(reply,callback,error){
		console.log("update 호출");
		$.ajax({
			type : 'put',
			url : '/replies/'+reply.rno,
			data : JSON.stringify(reply),
			contentType : 'application/json;charset=utf-8',
			success : function(result){
				if(callback)
					callback(result);
			},error:function(xhr,status,er){
				if(error){
					error(er);
				}
			}
		});
	}//update 종료
	
	function get(rno,callback,error){
		console.log("get 호출");
		$.get("/replies/"+rno+".json",function(result){
			if(callback){
				callback(result);
			}
		}).fail(function(xhr,status,er){
			if(error){
				error(er);
			}
		});	
	}//get 종료
	
	
	//댓글 목록을 보여줄 때 시간이 1541473709000 나오는 것 수정
	function displayTime(timeValue){
		var today=new Date();
		
		var gap=today.getTime() - timeValue;
		var dateObj = new Date(timeValue);
		var str="";
		
		if(gap<(1000 * 60 * 60 * 24)){ //댓글 단 날짜가 오늘이면 시분초
			var hh=dateObj.getHours();
			var mi=dateObj.getMinutes();
			var ss=dateObj.getSeconds();
			
			return [(hh>9?'':'0')+hh,':',(mi>9?'':'0')+mi,':',(ss>9?'':'0')+ss].join('');
		}else{ //댓글 단 날짜가 오늘이 아니면 년/월/일
			var yy=dateObj.getFullYear();
			var mm=dateObj.getMonth()+1;//월은 0부터 시작함
			var dd=dateObj.getDate();
			return [yy,'/',(mm>9?'':'0')+mm,'/',(dd>9?'':'0')+dd].join('');
		}
	}
	
	return {   //외부에서 호출되는 부분
		add:add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime:displayTime
	};
})();





