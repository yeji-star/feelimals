# dbdiagram.io 버전

DROP DATABASE IF EXISTS `feelimals`;
CREATE DATABASE `feelimals`;
USE `feelimals`;

# 사용자
CREATE TABLE `member` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `loginId` VARCHAR(100) NOT NULL,
  `loginPw` VARCHAR(100) NOT NULL,
  `nickname` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  charaId INT(10) UNSIGNED NOT NULL COMMENT '자신이 정한 동물 캐릭터 (디폴트는 토끼)',
   # `memberImage` VARCHAR(255),
  `delStatus` TINYINT(1) NOT NULL DEFAULT 0,
  `delDate` DATETIME
);

# 동물 캐릭터
CREATE TABLE `chara` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `name` VARCHAR(50) NOT NULL,
  `content` CHAR(50) NOT NULL,
  `image` CHAR(100)
);

# 감정 태그
CREATE TABLE `emoTag` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `label` CHAR(20) UNIQUE NOT NULL,
  `icon` CHAR(20) NOT NULL,
  `color` CHAR(10) NOT NULL
);

#캐릭터 감정
CREATE TABLE `charaEmo` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `charaId` INT(10) UNSIGNED NOT NULL,
  `emoTagId` INT(10) UNSIGNED NOT NULL,
  `emoType` VARCHAR(50) NOT NULL,
  `image` VARCHAR(100) NOT NULL
);

SHOW CREATE TABLE charaEmo;

# 채팅과 일기 통합
CREATE TABLE `chatDiary` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `memberId` INT(10) UNSIGNED NOT NULL,
  `sessionId` INT(10) UNSIGNED NULL,
  `body` TEXT NOT NULL,
  `isUser` BOOLEAN DEFAULT TRUE COMMENT 'true면 사용자, false면 AI',
  `thisChat` BOOLEAN DEFAULT FALSE COMMENT 'true면 채팅, false면 일기',
  `emoTagId` INT(10) UNSIGNED NOT NULL,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `delStatus` TINYINT(1) NOT NULL DEFAULT 0,
  `delDate` DATETIME
);

SELECT * FROM aiReply;
SELECT chatdiaryId, COUNT(*) FROM aiReply GROUP BY chatdiaryId HAVING COUNT(*) > 1;
SELECT * FROM chatSession;
SELECT * FROM chatDiary;

# ai와 말을 주고받는 하나의 대화 세션
CREATE TABLE `chatSession` (
`id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
`memberId` INT(10) UNSIGNED NOT NULL,
`title` CHAR(100) DEFAULT NULL,
regDate DATETIME NOT NULL,
updateDate DATETIME NOT NULL,
delStatus TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0이면 삭제 안됨, 1이면 삭제됨',
delDate DATETIME
);
SELECT * FROM chatSession;

# 이후 추가할 다이어리 감정 점수
CREATE TABLE `diaryEmo` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `chatdiaryId` INT(10) UNSIGNED NOT NULL,
  `emoTagId` INT(10) UNSIGNED NOT NULL,
  `score` FLOAT NOT NULL,
  `source` CHAR(50) NOT NULL,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `delStatus` TINYINT(1) NOT NULL,
  `delDate` DATETIME
);

# ai 답변
CREATE TABLE `aiReply` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `chatDiaryId` INT(10) UNSIGNED NOT NULL,
  `reply` TEXT NOT NULL,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `model` CHAR(50) NOT NULL,
  `delStatus` TINYINT(1) NOT NULL DEFAULT 0,
  `delDate` DATETIME
);

SELECT * FROM aiReply;

# 설정
CREATE TABLE `settings` (
  `id` INT(10) UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `memberId` INT(10) UNSIGNED NOT NULL,
  `charaId` INT(10) UNSIGNED NOT NULL,
  `updateDate` DATETIME NOT NULL
);

ALTER TABLE `charaEmo` ADD FOREIGN KEY (`charaId`) REFERENCES `chara` (`id`);

ALTER TABLE `settings` ADD FOREIGN KEY (`memberId`) REFERENCES `member` (`id`);

ALTER TABLE `chatDiary` ADD FOREIGN KEY (`memberId`) REFERENCES `member` (`id`);

ALTER TABLE `chatDiary` ADD FOREIGN KEY (`sessionId`) REFERENCES `chatSession` (`id`);

ALTER TABLE `diaryEmo` ADD FOREIGN KEY (`chatdiaryId`) REFERENCES `chatDiary` (`id`);

ALTER TABLE `diaryEmo` ADD FOREIGN KEY (`emoTagId`) REFERENCES `emoTag` (`id`);

ALTER TABLE `charaEmo` ADD FOREIGN KEY (`emoTagId`) REFERENCES `emoTag` (`id`);

ALTER TABLE `member` ADD FOREIGN KEY (`charaId`) REFERENCES `chara` (`id`);

ALTER TABLE `aiReply` ADD FOREIGN KEY (`chatdiaryId`) REFERENCES `chatDiary` (`id`);

ALTER TABLE `chatDiary` ADD FOREIGN KEY (`emoTagId`) REFERENCES `emoTag` (`id`);

ALTER TABLE `settings` ADD FOREIGN KEY (`charaId`) REFERENCES `chara` (`id`);


SHOW TABLES;

# 동물 캐릭터
INSERT INTO chara
SET regDate = NOW(),
updateDate = NOW(),
`name` = '토끼',
`content` = '토끼다',
image = '/resource/img/chara_1_5.png';

INSERT INTO chara
SET regDate = NOW(),
updateDate = NOW(),
`name` = '부엉이',
`content` = '부엉이다',
image = '/resource/img/chara_2_5.png';

INSERT INTO chara
SET regDate = NOW(),
updateDate = NOW(),
`name` = '고양이',
`content` = '고양이다',
image = '/resource/img/chara_3_5.png';

INSERT INTO chara
SET regDate = NOW(),
updateDate = NOW(),
`name` = '개',
`content` = '개다',
image = '/resource/img/chara_4_5.png';

INSERT INTO chara
SET regDate = NOW(),
updateDate = NOW(),
`name` = '곰',
`content` = '곰이다',
image = '/resource/img/chara_5_5.png';

select * from chara;

# 테스트 데이터 (유저)

insert into `member`
set regDate = now(),
	updateDate = now(),
	loginId = 'test1',
	loginPw = 'test1',
	nickname = 'test1',
	email = 'test1@gmail.com',
	charaId = 1;
	
INSERT INTO `member`
SET regDate = NOW(),
	updateDate = NOW(),
	loginId = 'test2',
	loginPw = 'test2',
	nickname = 'test2',
	email = 'test2@gmail.com',
	charaId = 1;

# 테스트 데이터 (감정 태그)

INSERT INTO emoTag
SET
  label = '기쁨',
  icon = '😊',
  color = '#FFE082';
   
INSERT INTO emoTag
SET
  label = '슬픔',
  icon = '😔',
  color = '#90CAF9'; 

INSERT INTO emoTag
SET
  label = '분노',
  icon = '😠',
  color = '#FF8A65'; 
  
INSERT INTO emoTag
SET
  label = '불안',
  icon = '😰',
  color = '#B39DDB'; 
  
  INSERT INTO emoTag
SET
  label = '분류안함',
  icon = '❓',
  color = '#E0E0E0'; 
  
select * from emoTag;  
  
# 테스트 데이터 (일기)

INSERT INTO chatDiary
SET
  memberId = 1,
  `body` = '오늘은 오랜만에 햇살이 따뜻했어.',
  thisChat = FALSE,
  emoTagId = 1,
  regDate = NOW(),
  updateDate = NOW(),
  delStatus = 0;

INSERT INTO chatDiary
SET
  memberId = 1,
  `body` = '조금 힘들었지만 잘 견뎠어.',
  thisChat = FALSE,
  emoTagId = 2,
  regDate = NOW(),
  updateDate = NOW(),
  delStatus = 0;
  
# 테스트 데이터 (세션)

insert into chatSession
set
	memberId = 1,
	title = '대화1',
	regDate = now(),
	updateDate = now();
  
SELECT LAST_INSERT_ID();  
  
# 테스트 데이터 (대화)

insert into chatDiary
set 
memberId = 1,
sessionId = 1,
`body` = '오늘 좀 힘들었어. 위로해줘.',
thisChat = true,
emoTagId = 2,
regDate = now(),
updateDate = now(),
delStatus = 0;

# 테스트 데이터 (ai응답)

insert into aiReply
set
chatDiaryId = 1,
reply = '힘들었구나.',
regDate = now(),
updateDate = now(),
model = 'gpt-3.5-turbo',
delStatus = 0;

# 캐릭터 감정 이미지
# 토끼
INSERT INTO charaEmo
SET charaId = 1,
emoTagId = 1,
emoType = '기쁨',
image = '/resource/img/chara_1_1.png';

INSERT INTO charaEmo
SET charaId = 1,
emoTagId = 2,
emoType = '슬픔',
image = '/resource/img/chara_1_2.png';

INSERT INTO charaEmo
SET charaId = 1,
emoTagId = 3,
emoType = '분노',
image = '/resource/img/chara_1_3.png';

INSERT INTO charaEmo
SET charaId = 1,
emoTagId = 4,
emoType = '불안',
image = '/resource/img/chara_1_4.png';

INSERT INTO charaEmo
SET charaId = 1,
emoTagId = 5,
emoType = '분류안함',
image = '/resource/img/chara_1_5.png';

#부엉이
INSERT INTO charaEmo
SET charaId = 2,
emoTagId = 1,
emoType = '기쁨',
image = '/resource/img/chara_2_1.png';

INSERT INTO charaEmo
SET charaId = 2,
emoTagId = 2,
emoType = '슬픔',
image = '/resource/img/chara_2_2.png';

INSERT INTO charaEmo
SET charaId = 2,
emoTagId = 3,
emoType = '분노',
image = '/resource/img/chara_2_3.png';

INSERT INTO charaEmo
SET charaId = 2,
emoTagId = 4,
emoType = '불안',
image = '/resource/img/chara_2_4.png';

INSERT INTO charaEmo
SET charaId = 2,
emoTagId = 5,
emoType = '분류안함',
image = '/resource/img/chara_2_5.png';

#고양이
INSERT INTO charaEmo
SET charaId = 3,
emoTagId = 1,
emoType = '기쁨',
image = '/resource/img/chara_3_1.png';

INSERT INTO charaEmo
SET charaId = 3,
emoTagId = 2,
emoType = '슬픔',
image = '/resource/img/chara_3_2.png';

INSERT INTO charaEmo
SET charaId = 3,
emoTagId = 3,
emoType = '분노',
image = '/resource/img/chara_3_3.png';

INSERT INTO charaEmo
SET charaId = 3,
emoTagId = 4,
emoType = '불안',
image = '/resource/img/chara_3_4.png';

INSERT INTO charaEmo
SET charaId = 3,
emoTagId = 5,
emoType = '분류안함',
image = '/resource/img/chara_3_5.png';

#개
INSERT INTO charaEmo
SET charaId = 4,
emoTagId = 1,
emoType = '기쁨',
image = '/resource/img/chara_4_1.png';

INSERT INTO charaEmo
SET charaId = 4,
emoTagId = 2,
emoType = '슬픔',
image = '/resource/img/chara_4_2.png';

INSERT INTO charaEmo
SET charaId = 4,
emoTagId = 3,
emoType = '분노',
image = '/resource/img/chara_4_3.png';

INSERT INTO charaEmo
SET charaId = 4,
emoTagId = 4,
emoType = '불안',
image = '/resource/img/chara_4_4.png';

INSERT INTO charaEmo
SET charaId = 4,
emoTagId = 5,
emoType = '분류안함',
image = '/resource/img/chara_4_5.png';

#곰
INSERT INTO charaEmo
SET charaId = 5,
emoTagId = 1,
emoType = '기쁨',
image = '/resource/img/chara_5_1.png';

INSERT INTO charaEmo
SET charaId = 5,
emoTagId = 2,
emoType = '슬픔',
image = '/resource/img/chara_5_2.png';

INSERT INTO charaEmo
SET charaId = 5,
emoTagId = 3,
emoType = '분노',
image = '/resource/img/chara_5_3.png';

INSERT INTO charaEmo
SET charaId = 5,
emoTagId = 4,
emoType = '불안',
image = '/resource/img/chara_5_4.png';

INSERT INTO charaEmo
SET charaId = 5,
emoTagId = 5,
emoType = '분류안함',
image = '/resource/img/chara_5_5.png';

SELECT * FROM aiReply WHERE chatdiaryId IN (SELECT id FROM chatDiary WHERE sessionId = 3);


select *
from `member`;

SELECT * FROM emoTag;
SELECT * FROM chatDiary;

desc `member`;

SELECT cd.id, cd.body, cd.sessionId, cd.thisChat, ar.reply
FROM chatDiary cd
LEFT JOIN aiReply ar ON ar.chatDiaryId = cd.id
WHERE cd.sessionId = 1;

select * from chatDiary
inner join chatSession
on chatDiary.sessionId = chatSession.id
inner join aiReply
on aiReply.chatDiaryId = chatDiary.id;