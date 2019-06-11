<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Portfolio</title>

<link rel="stylesheet" href="/resources/css/style.css">
</head>
<body>
	<div class="login-box">
		<h1>Login</h1>
		<form action="/login" method="post" class="form-signin">
		<div class="textbox">
			<input type="text" placeholder="Username" name="username" id = "username" class = "userid" required autofocus>
		</div>

		<div class="textbox">
			<input type="password" placeholder="Password" name="password" id="password" value="" class = "password" required>
		</div>
		  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
		<button class="btn sum" type="submit">Sign in</button>
		</form>
		<div class="" style="width: 300px; border: 0px solid white;">
			<!-- position_a -->
			<div class="">
				<!-- find_info -->
				<a id="idinquiry" class="finds" href="/findid">아이디
					찾기</a> <span class="bar" aria-hidden="true">|</span> <a 
					class="finds" id="pwinquiry" href="/findPwd"> 비밀번호 찾기</a> <span
					class="bar" aria-hidden="true">|</span> <a 
					id="join" class="finds" href="/regist/step1">회원가입</a>
			</div>
		</div>
		
	</div>
	<script src="/resources/js/jquery-3.3.1.js"></script>   
	<script src="/resources/js/index.js"></script>
<script>

</script>
</body>
</html>