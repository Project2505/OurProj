--======================================================================================
-- Автор:
--		Богданов Д.М.
--
-- Описание:
--		функция получения данных для карточек 
--		пользователей из резюме
--
-- Дата создания:
--		09.05.2025	
--
-- Пример вызова:
--		select * from GetUserCardInformation('Python,C++', 'Programmer,DevSecOps');
--
-- Изменения:
--		10.05.2025 Добавлены фильтры p_CategoryFiltr, p_SpecializationFiltr
--======================================================================================

create function GetUserCardInformation
(
	p_CategoryFiltr text, -- фильтр для поиска по категориям навыков
	p_SpecializationFiltr text -- фильтр для поиска по специализации, указанного в резюме
)
returns table
(
	user_id int,
    user_name text,
    user_avatar text,
    user_skills text,
	user_expirience_level text,
	user_desired_salary numeric,
	user_resume_bio text,
	user_specialization text
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
		res.ResumeBio,
		res.ResumeSpecialization
		from Users us
		join Resume res on us.UserID = res.UserID
		join Skills skl on res.SkillID = skl.SkillID
		where res.ResumeIsDeleted = false
		and (
			p_CategoryFiltr is null or 
			skl.SkillName = any(string_to_array(p_CategoryFiltr, ','))
		)
		and (
			p_SpecializationFiltr is null or
			res.ResumeSpecialization = any(string_to_array(p_SpecializationFiltr, ','))
		)
		group by us.UserID, res.ResumePhoto, res.ExperienceLevel, res.DesiredSalary, res.ResumeBio, res.ResumeSpecialization;
	end;
$$;

select * from GetUserCardInformation('Python,C++', 'Programmer,DevSecOps');




		