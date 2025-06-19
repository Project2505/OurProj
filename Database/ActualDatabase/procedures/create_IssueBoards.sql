--=================================================
-- Автор: Богданов Д.М.
-- Описание:
--      Процедура для создания доски задач
--
-- Пример вызова:
--  CALL create_IssueBoards(
--      1,                          -- p_projectid (ID проекта)
--      123,                        -- p_userid (ID пользователя)
--      'Бэклог разработки',        -- p_issueboardname (Название доски)
--      'https://example.com/boards/backlog.png', -- p_issueboardavatar (Аватар доски)
--      456                         -- p_issueboardresponsible (ID ответственного)
--  );
--=================================================

create procedure create_IssueBoards
(
	p_projectid bigint,
	p_userid bigint,
	p_issueboardname text,
	p_issueboardavatar text,
	p_issueboardresponsible bigint,
)
language plpgsql
as $$
begin
	if p_projectid is null or p_projectid = '' then
        raise exception 'доска не может быть не привязана ни к одному проекту';
    end if;

	if p_userid is null or p_userid = '' then
		raise exception '';
	end if;

	if p_issueboardname is null or p_issueboardname = '' then
		raise exception 'доскадолжна иметь название';
	end if;

	if p_issueboardresponsible is null or p_issueboardresponsible = '' then
		raise exception 'На доске должен быть ответственный'
	end if;

	insert into IssueBoards
	(
		ProjectID bigint,
		UserID bigint,
		IssueBoardName,
		IssueBoardAvatar,
		IssueBoardResponsible
	)
	values
	(
		p_projectid,
		p_userid,
		p_issueboardname,
		p_issueboardavatar,
		p_issueboardresponsible
	);
	commit;
end;
$$;

	




	
	