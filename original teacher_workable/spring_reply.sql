create table spring_reply(
	rno number(10, 0) constraint pk_reply primary key, -- 댓글 번호(시퀀스 사용)
	bno number(10, 0) not null,   -- 원본글 번호
	reply varchar2(1000) not null,  -- 댓글 내용
	replyer varchar2(50) not null,  -- 댓글작성자
	replyDate date default sysdate,  -- 댓글 날짜
	updateDate date default sysdate,   -- 댓글 수정날짜
	constraint fk_reply_board foreign key(bno) references spring_board(bno) 
);

create sequence seq_reply;


select * from SPRING_REPLY where bno=28695;

-- 기존 테이블에 컬럼 추가
alter table spring_board add(replycnt number default 0);

-- 기존 테이블에 replyCnt 값 변경
update SPRING_BOARD set replycnt=(select count(rno) 
			from spring_reply where SPRING_REPLY.bno=spring_board.bno);
			
			
--member2 			
create table member2(
    userid nvarchar2(100) not null unique,
    password nvarchar2(100) not null,
    username nvarchar2(100) not null,
    gender nvarchar2(10) not null,
    email nvarchar2(1000) not null,
    updateDate date,
    userDate date
);

select * from member2;
drop table member2; 

commit;

--spring member
select * from spring_member;
create table spring_member(
    userid nvarchar2(100) not null,
    username nvarchar2(100) not null,
    enabled nvarchar2(100) not null,
    updatedate date,
    regdate date,
    auth nvarchar2(100) not null
);

--auth
create table spring_member_auth(
   userid varchar2(50) not null,
   auth varchar2(50) not null,
   constraint fk_member_auth foreign key(userid) references spring_member(userid)
);


--spring member
create table spring_member(
   userid varchar2(50) not null primary key,
   userpw varchar2(100) not null,
   username varchar2(100) not null,
   regdate date default sysdate,
   updatedate date default sysdate,
   enabled char(1) default '1'
);


drop table spring_member_auth;

drop table spring_member;
commit;			

