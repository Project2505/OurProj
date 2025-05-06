--=============================================
--	Создание базы данных
--=============================================

create database SquadUp


--=============================================
--	Создание сущностей
--=============================================


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
	ProjectID bigint not null,
	TeamSize int not null default false,
	TeamFullness int not null,
	TeamCreatedAt timestamp default now(),

	constraint fk_teamProject foreign key (ProjectID)
		references Projects(ProjectID) -- связь команды с проектом
		on update cascade
);

-- таблица досок задач
create table IssueBoards
(
	IssueBoardID serial primary key,
	ProjectID bigint not null,
	UserID bigint not null,
	IssueBoardName text not null,
	IssueBoardAvatar text,

	constraint fk_IssueBoardsProj foreign key (ProjectID)
		references Project(ProjectID) -- связь доски задач с проектом
		on update cascade
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
	IssueExecutor bigint,

	constraint fk_issueIssueBoard foreign key (IssueBoardID)
		references IssueBoard(IssueBoardID) -- связь заданий с их досками
		on update cascade
);

-- таблица комментариев в задачах
create table IssuesComments
(
	IssueCommentID serial primary key,
	IssueCommentSender bigint not null,
	IssueID bigint not null,
	IssueCommentText text not null,
	IssueCommentVideo text,
	IssueCommentPhoto text,
	IssueCommentCreatedAt timestamp default now(),
	IssueCommentIsDeleted boolean default false,

	constraint fk_issueCommentsIssues foreign key (IssueID)
		references Issues(IssueID) -- связь комментариев к задаче с задачей
		on update cascade,

	constraint fk_issueCommentUser foreign key (IssueCommentSender)
		references Users(UserID) -- связь отправителя сообщения (юзера) и самого сообщения
		on update cascade,
);

-- таблица ответов на комментарий под задачей
create table CommentRecieves
(
	CommentRecieveID serial primary key,
	CommentParent bigint not null,
	CommentChild bihint not null,

	constraint fk_commentRecieve primary key (CommentParent)
		references IssuesComments(IssueCommentID) -- связь сообщения родителя с сообщением
		on update cascade,
	
	constraint fk_commentRecieve primary key (CommentParent)
		references IssuesComments(IssueCommentID) -- связь дочернего сообщения с самим сообщением
		on update cascade,
);

-- таблица чата для HR и наёмника :>
create table ChatHR
(
	ChatHRid serial primary key,
	ChatHRname text,
	ChatHRpeople bihint not null,
	ChatPeople bihint not null,

	constraint fk_hr_user foreign key (HRuserID) 
		references Users(UserID) --  связь чата с HR (юзером)
		on update cascade,
    
	constraint fk_candidate_user foreign key (CandidateUserID) 
		references Users(UserID) -- связь чата с претендентом (юзером)
		on update cascade
);

-- таблица личных чатов
create table PersonalChats
(
	PersonslChatID serial primary key,
	PersonalChatName text not null,
);

-- таблица групповых чатов
create table GroupChats (
    group_chat_id serial primary key,
    group_chat_name text not null,
    created_by_user_id bigint not null,  -- создатель чата
    created_at timestamp default now(),
    group_avatar text,                -- аватарка чата
    is_active boolean default true,    -- флаг активности чата
    
    constraint fk_creator_user foreign key (created_by_user_id) 
        references users(user_id)
        on update cascade
);

-- таблица участников группового чата
create table GroupChatParticipants (
    participant_id serial primary key,
    group_chat_id bigint not null,
    user_id bigint not null,
    joined_at timestamp default now(),
    last_seen_at timestamp,            -- когда пользователь последний раз был в чате
    
    constraint fk_group_chat foreign key (group_chat_id) 
        references groupchats(group_chat_id)
        on delete cascade,
        
    constraint fk_user foreign key (user_id) 
        references users(user_id)
        on delete cascade,
        
    constraint unique_group_user_pair unique (group_chat_id, user_id)
);

-- обновление таблицы сообщений для поддержки групповых чатов
alter table messages add column group_chat_id bigint;

-- таблица сообщений для чатов
create table Messages
(
	MessageID serial primary key,
	PersonalChatID bigint,
	ChatHRid bigint,
	GroupChatID bigin,
	MessageSender big int not null,
	MessageText text,
	MessagePhoto text,
	MessageVideo text,
	MessageSendAt timestamp default now(),
	MessageGetAt timestamp default now(),
	
	constraint fk_messagePersonalChat foreign key (PersonalChatID) 
		references PersonalChats(PersonalChatID) -- связь сообщения с личным чатом
		on update cascade,

	constraint fk_messageChatHR foreign key (ChatHRid) 
		references Users(UserID) -- связь сообщения с чатом для наёма
		on update cascade,

	constraint fk_group_chat 
    	foreign key (group_chat_id) references groupchats(group_chat_id)
		on update cascade,

	constraint fk_messageMessageSender foreign key (MessageSender) 
		references Users(UserID) --  связь сообщения с отправителем (пользователем)
		on update cascade,
);

-- таблица ответов на сообщения
create table MessageRecieves
(
	MessageRecieveID serial primary key,
	MessageParent bigint not null,
	MessageChild bihint not null
);


--=============================================
--	Создание таблиц связок
--=============================================


-- таблица-связка навыков с пользователями (многие-ко-многим)
create table UserSkills
(
	UserSkillID serial primary key,
	UserID bigint not null,
	SkillID bigint not null,

	constraint fk_userSkill foreign key (UserID)
		references Users(UserID)
		on update cascade,

	constraint fk_skillUser foreign key (SkillID)
		references Skill(SkillID)
		on update cascade,

	constraint unique_userSkill unique(UserID, SkillID)
);

--  таблица-связка досок задач с пользователями (многие-ко-многим)
create table UserIssueBoards
(
	IssueBoardUser serial primary key,
	UserID bigint not null,
	IssueBoardID bigint not null,

	constraint fk_userIssueBoard foreign key (UserID)
		references Users(UserID)
		on update cascade,

	constraint fk_issueBoardUser foreign key (SkillID)
		references IssueBoards(IssueBoardID)
		on update cascade,

	constraint unique_userIssueBoard unique(UserID, IssueBoardID) 
);

create table UserPersonalChat
(
	UserPersonalChatID serial primary key
	UserID bigint not null,
	PersonslChatID bigint not null,

	constraint fk_userPersonalChat foreign key (UserID)
		references Users(UserID)
		on update cascade,

	constraint fk_iPersonalChatUser foreign key (SkillID)
		references PersonalChats(UserPersonalChatID)
		on update cascade,

	constraint unique_userPersonalChat unique(UserID, UserPersonalChatID) 
);




















