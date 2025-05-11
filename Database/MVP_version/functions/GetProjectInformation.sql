--======================================================================================
-- Автор:
--		Богданов Д.М.
--
-- Описание:
--		функция получения данных информации 
--		пользователей для личного кабинета
--
-- Дата создания:
--		08.05.2025	
--
-- Пример вызова:
--		select * from GetProjectInformation(1);
--
-- Изменения:
--======================================================================================

create function GetProjectInformation
(
	projectParam int
)
returns table 
(
	ProjectID int,
    ProjectName text,
    ProjectBio text,
    ProjectCountry text,
    ProjectTown text,
    ProjectFoundedDate date,
    ProjectLogo text,
    ProjectPhone text,
    ProjectEmail text,
    UserNames text
)
language plpgsql
as $$
	begin
	return Query
		select
		pr.ProjectID,
		pr.ProjectName,
		pr.ProjectBio,
		pr.ProjectCountry,
		pr.ProjectTown,
		pr.ProjectFoundedDate,
		pr.ProjectLogo,
		pr.ProjectPhone,
		pr.ProjectEmail,
		string_agg(us.UserName, ', ' order by us.UserName desc) as UserNames
		from Projects pr
		join Teams tm on pr.ProjectID = tm.ProjectID
		join UserTeams ustm on tm.TeamID = ustm.TeamID
		join Users us on ustm.UserID = us.UserID
		where pr.ProjectID = projectParam
		group by pr.ProjectID, pr.ProjectName, pr.ProjectBio, pr.ProjectCountry, pr.ProjectTown,
		pr.ProjectFoundedDate, pr.ProjectLogo, pr.ProjectPhone, pr.ProjectEmail;
	end;
$$;
		
		