--=============================================
--	Создание базы данных
--=============================================

-- create database SquadUp

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
	Userspecialization text,
	UserPhone text,
	UserEmail text,
	UserCreatedAt timestamp default now(),
	UserIsDeleted boolean default false,
	UserPassword text not null
);

-- таблица-справочник навыков (закрытый справочник)
create table Skills
(
	SkillID serial primary key,
	SkillName text not null unique
	Category text not null
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
	TeamSize int not null default 1, -- 1 т.к. создатель команды также её член
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
	IssueBoardResponsible bigint not null,

	constraint fk_IssueBoardsProj foreign key (ProjectID)
		references Projects(ProjectID) -- связь доски задач с проектом
		on update cascade,
		
	constraint fk_IssueBoardsResponsible foreign key (IssueBoardResponsible)
		references Users(UserID) -- связь доски задач с ответственным
		on update cascade
);

-- таблица заданий
create table Issues
(
	IssueID serial primary key,
	IssueName text not null,
	IssueBoardID bigint,
	IssueDescription text,
	IssuePhotos text,
	IssueVideo text,
	IssueAvtor bigint not null,
	IssueExecutor bigint,

	constraint fk_issueIssueBoard foreign key (IssueBoardID)
		references IssueBoards(IssueBoardID) -- связь заданий с их досками
		on update cascade,

	add constraint fk_issue_executor_user foreign key (IssueExecutor)
    	references Users(UserID)
    	on update cascade
);

-- Таблица связей задач 
create table IssueRelations
(
    IssueRelationID serial primary key,
    ParentIssueID bigint not null,  -- ID родительской задачи
    ChildIssueID bigint not null,   -- ID дочерней задачи
    RelationType text,              -- Тип связи (например, "блокирует", "дублирует", "связана")
    CreatedAt timestamp default now(),

    constraint fk_parent_issue foreign key (ParentIssueID)
        references Issues(IssueID)
        on delete cascade,
        
    constraint fk_child_issue foreign key (ChildIssueID)
        references Issues(IssueID)
        on delete cascade,
        
    constraint unique_issue_relation unique (ParentIssueID, ChildIssueID)
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
		on update cascade
);

-- таблица ответов на комментарий под задачей
create table CommentRecieves
(
	CommentRecieveID serial primary key,
	CommentParent bigint not null,
	CommentChild bigint not null,

	constraint fk_commentRecieve_parent foreign key (CommentParent)
		references IssuesComments(IssueCommentID) -- связь сообщения родителя с сообщением
		on update cascade,
	
	constraint fk_commentRecieve_child foreign key (CommentChild)
		references IssuesComments(IssueCommentID) -- связь дочернего сообщения с самим сообщением
		on update cascade
);

-- таблица чата для HR и наёмника :>
create table ChatHR
(
	ChatHRid serial primary key,
	ChatHRname text,
	ChatHRpeople bigint not null,
	ChatPeople bigint not null,

	constraint fk_hr_user foreign key (ChatHRpeople) 
		references Users(UserID) --  связь чата с HR (юзером)
		on update cascade,
    
	constraint fk_candidate_user foreign key (ChatPeople) 
		references Users(UserID) -- связь чата с претендентом (юзером)
		on update cascade
);

-- таблица личных чатов
create table PersonalChats
(
    PersonalChatID serial primary key,
    PersonalChatName text not null
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
        references users(UserID)
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
        references users(UserID)
        on delete cascade,
        
    constraint unique_group_user_pair unique (group_chat_id, user_id)
);

-- таблица сообщений для чатов
create table Messages
(
	MessageID serial primary key,
	PersonalChatID bigint,
	ChatHRid bigint,
	GroupChatID bigint,
	MessageSender bigint not null,
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

	constraint fk_group_chat foreign key (GroupChatID) 
		references groupchats(group_chat_id)
		on update cascade,

	constraint fk_messageMessageSender foreign key (MessageSender) 
		references Users(UserID) --  связь сообщения с отправителем (пользователем)
		on update cascade
);

-- таблица ответов на сообщения
create table MessageRecieves
(
	MessageRecieveID serial primary key,
	MessageParent bigint not null,
	MessageChild bigint not null
);

-- таблица истории изменений задачи
create table HistoryIssue
(
    HistoryID serial primary key,
    IssueID bigint not null,
    ChangedByUserID bigint not null,
    ChangeDate timestamp default now(),
    ChangeType text not null,
    FieldChanged text,
    OldValue text,
    NewValue text,
    ChangeComment text,
    
    constraint fk_history_issue foreign key (IssueID)
        references Issues(IssueID)
        on update cascade,
        
    constraint fk_history_user foreign key (ChangedByUserID)
        references Users(UserID)
        on update cascade
);

-- таблица для сохранения избранных пользователей
create table Favourites
(
	FavouriteID serial primary key,
	UserID bigint not null,
	SavedUserID bigint not null
);

create table Resume
(
	ResumeID serial primary key,
	UserID bigint not null,
	SkillID bigint,
	ResumeBio text,
	ResumeCreatedAt timestamp default now(),
	ResumeIsDeleted boolean default false,
	ResumePhoto text,
	EducationLevel text,
	DesiredPosition text not null,
	ExperienceLevel text,
	DesiredSalary numeric, 
	ResumeStatus text,
	ResumeUpdatedAt timestamp,
	ResumeCity text,
	ResumeSpecialization text not null,

	 constraint fk_resume_user foreign key (UserID)
        references Users(UserID)
        on update cascade
);

create table Vacancies
(
	VacancyID serial primary key,
	ProjectID bigint,
	SkillID bigint,
	VacancyName text not null,
	VacancyBio text,
	VacancyResponsibilities text, -- обязанности
	VacancyRequirements text, -- требования
	VacancyMinExperience int, -- минимальный опыт в годах
	VacancyEmploymentType text, -- тип занятости (полный/подработка и т.д.)
	VacancySalaryFrom numeric, -- зп от
	VacancySalaryTo numeric, -- зп до
	VacancyCurrecncy text, -- Валюта зп
	VacancyTypeSalary text, -- зп или доля компании(акции)
	VacancyCompanyShare numeric, -- доля акций компании в %
	VacancyIsActive boolean default true,
	VacancyResponses int,
	CreatedAt timestamp default now(),
	ClosedAt timestamp,

	constraint fk_VacanciesProject foreign key (projectID)
		references Projects(ProjectID)
		on update cascade,
	
	constraint fk_fk_VacanciesSkills foreign key (SkillID)
		references Skills(SkillID)
		on update cascade
);

--=============================================
--	Создание таблиц связок
--=============================================

--  таблица-связка досок задач с пользователями (многие-ко-многим)
create table UserIssueBoards
(
	IssueBoardUser serial primary key,
	UserID bigint not null,
	IssueBoardID bigint not null,

	constraint fk_userIssueBoard foreign key (UserID)
		references Users(UserID)
		on update cascade,

	constraint fk_issueBoardUser foreign key (IssueBoardID)
		references IssueBoards(IssueBoardID)
		on update cascade,

	constraint unique_userIssueBoard unique(UserID, IssueBoardID) 
);

-- таблица-связка персональных чатов с пользователями
create table UserPersonalChat
(
    UserPersonalChatID serial primary key,
    UserID bigint not null,
    PersonalChatID bigint not null,

    constraint fk_userPersonalChat foreign key (UserID)
        references Users(UserID)
        on update cascade,

    constraint fk_personalChatUser foreign key (PersonalChatID)
        references PersonalChats(PersonalChatID)
        on update cascade,

    constraint unique_user_personal_chat unique(UserID, PersonalChatID) 
);

-- таблица-связка пользователей с командами
create table UserTeams
(
	UserTeamsID serial primary key,
	UserID bigint not null,
	TeamID bigint not null,

	constraint fk_userTeams_user foreign key (UserID)
        references Users(UserID)
        on update cascade,

    constraint fk_personalteams_team foreign key (TeamID)
        references Teams(TeamID)
        on update cascade,
	
	constraint unique_user_team unique(UserID, TeamID)
);


create table UsersFavourites
(
	UsersFavouriteID serial primary key,
	UserID bigint not null,
	FavouriteID bigint not null,

	constraint fk_userfavourites_user foreign key (UserID)
        references Users(UserID)
        on update cascade,

    constraint fk_UsersFavourites_FavouriteID foreign key (FavouriteID)
        references Favourites(FavouriteID)
        on update cascade,
	
	constraint unique_user_favourites unique(UserID, FavouriteID)
);

create table ResumeSkills (
    ResumeSkillID serial primary key,
    ResumeID bigint not null,
    SkillID bigint not null,
    
    constraint fk_resumeSkills_resume foreign key (ResumeID)
        references Resume(ResumeID)
        on delete cascade,
    
    constraint fk_resumeSkills_skill foreign key (SkillID)
        references Skills(SkillID)
        on delete cascade,
    
    constraint unique_resume_skill unique (ResumeID, SkillID)
);

-- таблица-связка откликов
create table VacansiesResponsers
(
	ResponseID serial primary key,
	UserID bigint not null,
	VacancyID bigint not null,
	ResumeID bigint not null,

	constraint fk_response_user foreign key (UserID)
        references Users(UserID)
        on delete cascade,
        
    constraint fk_response_vacancy foreign key (VacancyID)
        references Vacancies(VacancyID)
        on delete cascade,
        
    constraint fk_response_resume foreign key (ResumeID)
        references Resume(ResumeID)
        on delete set null,
        
    constraint unique_user_vacancy_pair unique (UserID, VacancyID)  -- Один пользователь → одна заявка на вакансию
);


--=============================================
--	Создание индексов
--=============================================

-- Индексы для таблицы Users
create index idx_users_alias on Users(UserAlias);
create index idx_users_country_town on Users(UserCountry, UserTown);
create index idx_users_created_at on Users(UserCreatedAt);

-- Индексы для таблицы Projects
create index idx_projects_name on Projects(ProjectName);
create index idx_projects_location on Projects(ProjectCountry, ProjectTown);
create index idx_projects_created_at on Projects(ProjectCreatedAt);

-- Индексы для таблицы Teams
create index idx_teams_project on Teams(ProjectID);
create index idx_teams_fullness on Teams(TeamFullness);

-- Индексы для таблицы Issues
create index idx_issues_board on Issues(IssueBoardID);
create index idx_issues_author on Issues(IssueAvtor);
create index idx_issues_executor on Issues(IssueExecutor);
create index idx_issues_name on Issues(IssueName);

-- Индексы для таблицы IssuesComments
create index idx_issue_comments_issue on IssuesComments(IssueID);
create index idx_issue_comments_sender on IssuesComments(IssueCommentSender);
create index idx_issue_comments_created on IssuesComments(IssueCommentCreatedAt);

-- Индексы для таблицы CommentRecieves
create index idx_comment_parent on CommentRecieves(CommentParent);
create index idx_comment_child on CommentRecieves(CommentChild);

-- Индексы для таблицы Messages
create index idx_messages_sender on Messages(MessageSender);
create index idx_messages_send_date on Messages(MessageSendAt);
create index idx_messages_personal_chat on Messages(PersonalChatID);
create index idx_messages_hr_chat on Messages(ChatHRid);
create index idx_messages_group_chat on Messages(GroupChatID);

-- Индексы для таблицы MessageRecieves
create index idx_message_parent on MessageRecieves(MessageParent);
create index idx_message_child on MessageRecieves(MessageChild);

-- Индексы для таблицы HistoryIssue
create index idx_history_issue on HistoryIssue(IssueID);
create index idx_history_user on HistoryIssue(ChangedByUserID);
create index idx_history_date on HistoryIssue(ChangeDate);
create index idx_history_type on HistoryIssue(ChangeType);

-- Индексы для таблицы UserIssueBoards
create index idx_user_issue_boards_user on UserIssueBoards(UserID);
create index idx_user_issue_boards_board on UserIssueBoards(IssueBoardID);

-- Индексы для таблицы UserPersonalChat
create index idx_user_personal_chat_user on UserPersonalChat(UserID);
create index idx_user_personal_chat_chat on UserPersonalChat(PersonalChatID);

-- Индексы для таблицы GroupChatParticipants
create index idx_group_participants_user on GroupChatParticipants(user_id);
create index idx_group_participants_chat on GroupChatParticipants(group_chat_id);
create index idx_group_participants_last_seen on GroupChatParticipants(last_seen_at);

-- Индексы для таблицы IssueRelations
create index idx_issue_relations_parent on IssueRelations(ParentIssueID);
create index idx_issue_relations_child on IssueRelations(ChildIssueID);
create index idx_issue_relations_type on IssueRelations(RelationType);

-- Индексы для таблицы VacancyResponses
create index idx_vacancy_responses_user on VacancyResponses(UserID);
create index idx_vacancy_responses_vacancy on VacancyResponses(VacancyID);