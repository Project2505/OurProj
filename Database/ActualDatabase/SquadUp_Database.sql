--=============================================
--	Создание базы данных
--=============================================
-- create database cactask
-- drop database cactask

--=============================================
--	Создание сущностей
--=============================================


-- таблица пользователей
create table Users
(
	UserID bigserial primary key,
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

-- таблица-справочник статусов членов команды (открытый)
create table Statuses
(
	StatusID bigserial primary key,
	StatusName text
);

-- таблица проектов (по сути, компаний/стартапов)
create table Projects
(
	ProjectID bigserial primary key,
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
	TeamID bigserial primary key,
	TeamUsers bigint,
	ProjectID bigint not null,
	TeamSize int not null default 1, -- 1 т.к. создатель команды также её член
	TeamFullness int not null,
	TeamCreatedAt timestamp default now()
);

-- таблица досок задач
create table IssueBoards
(
	IssueBoardID bigserial primary key,
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

-- тфблица-справочник типов задач
create table IssuesTypes
(
	IssueTypeID bigint primary key,
	IssueTypeName text not null
);

-- таблица заданий
create table Issues
(
	IssueID bigserial primary key,
	IssueName text not null,
	IssueBoardID bigint,
	IssueDescription text,
	IssuePhotos text,
	IssueVideo text,
	IssueAvtor bigint not null,
	IssueExecutor bigint,
	IssuePriority text, -- передается из приложения (не актуально, низкий, средний, высокий, критичный, блокер)
	IssueDeadLine timestamp,
	issueType bigint,
	IssueIsDeleted boolean default false,

	constraint fk_issueIssueBoard foreign key (IssueBoardID)
		references IssueBoards(IssueBoardID) -- связь заданий с их досками
		on update cascade,

	constraint fk_issue_executor_user foreign key (IssueExecutor)
    	references Users(UserID)
    	on update cascade,

	constraint fk_issue_issuetype foreign key (IssueType)
		references IssuesTypes(IssueTypeID)
		on update cascade
);

-- Таблица связей задач 
create table IssueRelations
(
    IssueRelationID bigserial primary key,
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
	IssueCommentID bigserial primary key,
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
	CommentRecieveID bigserial primary key,
	CommentParent bigint not null,
	CommentChild bigint not null,

	constraint fk_commentRecieve_parent foreign key (CommentParent)
		references IssuesComments(IssueCommentID) -- связь сообщения родителя с сообщением
		on update cascade
		on delete cascade,
	
	constraint fk_commentRecieve_child foreign key (CommentChild)
		references IssuesComments(IssueCommentID) -- связь дочернего сообщения с самим сообщением
		on update cascade
		on delete cascade
);

-- таблица истории изменений задачи
create table HistoryIssue
(
    HistoryID bigserial primary key,
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

--=============================================
--	Создание таблиц связок
--=============================================

-- Классическая таблица-связка досок задач с пользователями (многие-ко-многим)
create table UserIssueBoards
(
    UserID bigint not null,
    IssueBoardID bigint not null,

    constraint pk_user_issue_board primary key (UserID, IssueBoardID),
    
    constraint fk_user_issue_board_user foreign key (UserID)
        references Users(UserID)
        on update cascade
        on delete cascade,

    constraint fk_user_issue_board_board foreign key (IssueBoardID)
        references IssueBoards(IssueBoardID)
        on update cascade
        on delete cascade
);

-- Классическая таблица-связка пользователей с командами (многие-ко-многим)
create table UserTeams
(
    UserID bigint not null,
    TeamID bigint not null,

    constraint pk_user_team primary key (UserID, TeamID),
    
    constraint fk_user_team_user foreign key (UserID)
        references Users(UserID)
        on update cascade
        on delete cascade,

    constraint fk_user_team_team foreign key (TeamID)
        references Teams(TeamID)
        on update cascade
        on delete cascade
);

-- Классическая таблица-связка команд с проектами (многие-ко-многим)
create table TeamProjects
(
    TeamID bigint not null,
    ProjectID bigint not null,

    constraint pk_team_project primary key (TeamID, ProjectID),
    
    constraint fk_team_project_team foreign key (TeamID)
        references Teams(TeamID)
        on update cascade
        on delete cascade,

    constraint fk_team_project_project foreign key (ProjectID)
        references Projects(ProjectID)
        on update cascade
        on delete cascade
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

-- Индексы для таблицы HistoryIssue
create index idx_history_issue on HistoryIssue(IssueID);
create index idx_history_user on HistoryIssue(ChangedByUserID);
create index idx_history_date on HistoryIssue(ChangeDate);
create index idx_history_type on HistoryIssue(ChangeType);

-- Индексы для таблицы UserIssueBoards
create index idx_user_issue_boards_user on UserIssueBoards(UserID);
create index idx_user_issue_boards_board on UserIssueBoards(IssueBoardID);

-- Индексы для таблицы IssueRelations
create index idx_issue_relations_parent on IssueRelations(ParentIssueID);
create index idx_issue_relations_child on IssueRelations(ChildIssueID);
create index idx_issue_relations_type on IssueRelations(RelationType);