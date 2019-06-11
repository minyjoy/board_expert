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