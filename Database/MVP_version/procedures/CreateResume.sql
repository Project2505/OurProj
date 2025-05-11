--======================================================================================
-- Автор:
--		Богданов Д.М.
--
-- Описание:
--		процедура для создания резюме пользователя
--		в системе SquadUp
--
-- Дата создания:
--		10.05.2025	
--
-- Пример вызова:
-- 		CALL CreateResume(
--     		p_userid := 42,
--     		p_skillid := 5,
--     		p_resumebio := 'Опытный разработчик с 5+ годами опыта',
--     		p_resumecreatedat := NULL,
--     		p_resumeisdeleted := FALSE,
--     		p_resumephoto := 'photos/user42.jpg',
--     		p_educationlevel := 'Высшее',
--     		p_desiredposition := 'Team Lead',
--     		p_experiencelevel := '5+ лет',
--     		p_desiredsalary := 250000,
--     		p_resumestatus := 'Активно ищу работу',
--     		p_resumeupdatedat := NULL,
--     		p_resumecity := 'Москва',
--     		p_resumespecialization := 'Управление IT-проектами'
-- 		);
--
-- Изменения:
--======================================================================================

create procedure CreateResume
(
	p_userid bigint,
	p_skillid bigint,
	p_resumebio text,
	p_resumecreatedat timestamp,
	p_resumeisdeleted boolean,
	p_resumephoto text,
	p_educationlevel text,
	p_desiredposition text,
	p_experiencelevel text,
	p_desiredsalary numeric, 
	p_resumestatus text,
	p_resumeupdatedat timestamp,
	p_resumecity text,
	p_resumespecialization text
)
language plpgsql
as $$
	begin
	begin
		if p_userid is null or p_desiredposition is null or p_resumespecialization is null then
			raise exception 'Обязательные поля не могут быть пустыми';
			
		end if;
		if p_resumecreatedat is null then
			p_resumecreatedat := now();
		end if;

		if p_resumeupdatedat is null then
			p_resumeupdatedat := now();
		end if;

		if p_resumeisdeleted is null then
			p_resumeisdeleted := false;
		end if;

		insert into Resume
		(
			ResumeID,
			UserID,
			SkillID,
			ResumeBio,
			ResumeCreatedAt,
			ResumeIsDeleted,
			ResumePhoto,
			EducationLevel,
			DesiredPosition,
			ExperienceLevel,
			DesiredSalary, 
			ResumeStatus,
			ResumeUpdatedAt,
			ResumeCity,
			ResumeSpecialization
		)
		values
		(
			p_userid,
			p_skillid,
			p_resumebio,
			p_resumecreatedat,
			p_resumeisdeleted,
			p_resumephoto,
			p_educationlevel,
			p_desiredposition,
			p_experiencelevel,
			p_desiredsalary, 
			p_resumestatus,
			p_resumeupdatedat,
			p_resumecity,
			p_resumespecialization
		);
		
		exception
			when others then
				raise exception 'Ошибка создания резюме: %', sqlerrm;
	end;
	end;
$$;

	