--=================================================
--	функция для получения данных для карточек 
--	пользователей из резюме
--
-- Пример вызова:
--		select * from GetCardUserInformation(1);
--
-- Изменения:
--
--=================================================

create function GetUserCardInformation()
returns table
(
	user_id int,
    user_name text,
    user_avatar text,
    user_skills text,
	user_expirience_level text,
	user_desired_salary numeric,
	user_resume_bio text
)
Language plpgsql
as $$
	begin
		Return Query
		select
		us.UserID,
		us.UserName,
		res.ResumePhoto,
		string_agg(skl.SkillName, ', ' order by SkillName desc) as UserSkills,
		res.ExperienceLevel,
		res.DesiredSalary,
		res.ResumeBio
		from Users us
		join Resume res on us.UserID = res.UserID
		join Skills skl on res.SkillID = skl.SkillID
		where res.ResumeIsDeleted = false
		group by us.UserID, res.ResumePhoto, res.ExperienceLevel, res.DesiredSalary, res.ResumeBio;
	end;
$$;
		
select * from GetUserCardInformation();




		