create database SquadUp

-- таблица пользователей
create table Users
(
	UserID serial primary key,
	UserName text not null,
	Usersurname text not null,
	UserMiddleName text,
	UserAlias text unique,
	UserAge int not null,
	UserAvatar text,
	UserBio text,
	UserCountry text not null,
	UserTown text not null,
	UserCreatedAt timestamp default now(),
	UserIsDeleted boolean default false
);

-- таблица-справочник навыков (закрытый справочник)
create table Skills
(
	SkillID serial primary key,
	SkillName text not null unique
);

-- таблица-справыочник статусов членов команды (открытый)
create table Statuses
(
	StatusID serial primary key,
	StatusName text
);

-- таблица проектов (по сути, компаний/стартапов)
create table Projects
(
	ProjectID serial primary key,
	ProjectName text not null,
	ProjectBio text,
	ProjectCountry text,
	ProjectTown text,
	ProjectFoundedDate date,
	ProjectLogo text,
	ProjectPhone text,
	ProjectEmail text,
	ProjectCreatedAt timestamp default now(),
	ProjectIsDeleted boolean default false
);

-- таблица команд
create table Teams
(
	TeamID serial primary key,
	TeamUsers bigint,
	TeamProject bigint not null,
	TeamSize int not null default false,
	TeamFullness int not null,
	TeamCreatedAt timestamp default now()
);

-- таблица досок задач
create table IssueBoards
(
	IssueBoardID serial primary key,
	ProjectID bigint not null,
	UserID bigint not null,
	IssueBoardName text not null,
	IssueBoardAvatar text
);

-- таблица заданий
create table Issues
(
	IssueID serial primary key,
	IssueName text not null,
	IssueBoardID bigint
	IssueDescription text,
	IssuePhotos text,
	IssueVideo text
	IssueAvtor bigint not null,
	IssueExecutor bihint
);

-- таблица комментариев в задачах
create table IssuesComments
(
	IssueCommentID serial primary key,
	IssueCommentSender bigint not null,
	IssueCommentText text not null,
	IssueCommentVideo text,
	IssueCommentPhoto text,
	IssueCommentIsDeleted boolean default false
);

-- таблица ответов на комментарий под задачей
create table CommentRecieves
(
	CommentRecieveID serial primary key,
	CommentParent bigint not null,
	CommentChild bihint not null
);

-- таблица чата для HR и наёмника :>
create table ChatHR
(
	ChatHRid serial primary key,
	ChatHRname text,
	ChatHRpeople bihint not null,
	ChatPeople bihint not null,
);

-- таблица личных чатов
create table PersonalChats
(
	PersonslChatID serial primary key,
	UserID bigint not null					-- ПОМЕНЯТЬ НА ТАБЛИЦУ СВЯЗКУ
	PersonalChatName text not null,
);

-- таблица сообщений для чатов
create table Messages
(
	MessageID serial primary key,
	PersonalChatID bigint,
	ChatHRid bigint,
	GroupChatID bigin,
	MessageText text,
	MessagePhoto text,
	MessageVideo text,
	MessageSendAt timestamp default now(),
	MessageGetAt timestamp default now()
);

-- таблица ответов на сообщения
create table MessageRecieves
(
	MessageRecieveID serial primary key,
	MessageParent bigint not null,
	MessageChild bihint not null
);








