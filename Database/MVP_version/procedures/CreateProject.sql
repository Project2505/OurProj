--======================================================================================
-- Автор:
--		Богданов Д.М.
--
-- Описание:
--		процедура для создания проекта (стартапа/фирмы)
--		в системе SquadUp
--
-- Дата создания:
--		11.05.2025	
--
-- Пример вызова:
-- 		CALL CreateProject
--		(
--     		'Мой новый проект',
--     		'Описание моего нового проекта',
--     		'Россия',
--     		'Москва',
--     		'2023-01-01',
--     		'logo.png',
--     		'+79991234567',
--     		'project@example.com',
--     		NULL,
--     		NULL
-- 		);
--
-- Изменения:
--======================================================================================

create procedure CreateProject
(
	p_projectname text,
	p_projectbio text,
	p_projectcountry text,
	p_projecttown text,
	p_projectfoundeddate date,
	p_projectlogo text,
	p_projectphone text,
	p_projectemail text,
	p_projectcreatedat timestamp,
	p_projectisdeleted boolean
)
language plpgsql
as $$
	begin
	begin
		if p_projectname is null then
			raise exception 'Ваш проект должен иметь название!';
		end if;

		if p_projectcreatedat is null then
			p_projectcreatedat := now();
		end if;

		if p_projectisdeleted is null then
			p_projectisdeleted := false;
		end if;
		
		insert into Projects
		(
			ProjectID,
			ProjectName,
			ProjectBio,
			ProjectCountry,
			ProjectTown,
			ProjectFoundedDate,
			ProjectLogo,
			ProjectPhone,
			ProjectEmail,
			ProjectCreatedAt,
			ProjectIsDeleted
		)
		Values
		(
			p_projectname,
			p_projectbio,
			p_projectcountry,
			p_projecttown,
			p_projectfoundeddate,
			p_projectlogo,
			p_projectphone,
			p_projectemail,
			p_projectcreatedat,
			p_projectisdeleted
		);

		exception
			when others then
			raise exception 'Ошибка создания проекта: %', sqlerrm;
	end;
end;
$$;
		