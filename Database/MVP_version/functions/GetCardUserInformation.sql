--=================================================
--	функция для получения данных для карточек 
--	пользователей
--
-- Пример вызова:
--		select * from GetCardUserInformation(1);
--
-- Изменения:
--
--=================================================

create function GetCardUserInformation()
returns table
(
	user_id int,
    user_name text,
    user_avatar text,
	user_specialization text,
    user_skills text
)
Language plpgsql
as $$
	begin
		Return Query
		select 
		us.UserID,		
		us.UserName,
		us.UserAvatar,
		us.UserSpecialization,
		string_agg(skill.SkillName, ', ' order by SkillName desc) as UserSkills
		from users us	
		join UserSkills userskill on us.UserID = userskill.UserID
		join Skills skill on userskill.SkillID = skill.SkillID
		group by us.UserID, us.UserName, us.UserAvatar, us.UserSpecialization;
	end;
$$;


select * from GetCardUserInformation();