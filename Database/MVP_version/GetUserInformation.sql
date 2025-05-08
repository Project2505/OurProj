--=================================================
--	функция для получения данных для личного 
--	кабинета пользователей
--
-- Пример вызова:
--		select * from GetUserInformation(1);
--
-- Изменения:
--
--=================================================

create /*alter*/ function GetUserInformation(in userParam int)
returns table 
(
    user_id int,
    user_name text,
    user_surname text,
    user_middlename text,
    user_avatar text,
    user_bio text,
    project_name text
) 
Language plpgsql
as $$
	begin
	Return Query
		select 
		us.UserID,
		us.UserName,
		us.Usersurname,
		us.UserMiddleName,
		us.UserAvatar,
		us.UserBio,
		proj.ProjectName
		from Users us
		join UserTeams tmus on us.UserID = tmus.UserID
		join Teams tm on tmus.TeamID = tm.TeamID
		join Projects proj on tm.ProjectID = proj.ProjectID
		where us.UserID = userPerem;
	end;
$$;

