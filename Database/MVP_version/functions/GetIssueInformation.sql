--=================================================
--	функция для получения данных о задании
--
-- Пример вызова:
--		select * from GetIssueInformation(1);
--
-- Изменения:
--
--=================================================

create function GetIssueInformation(issueParam bigint)
returns table
(
	issue_id bigint,
	issue_name text,
	issue_boardid bigint,
	issue_description text,
	issue_photos text,
	issue_video text,
	issue_avtor bigint,
	issue_executor bigint,
	issue_board_name text,
	issue_comments text,
	issue_comment_text text,
	issue_comment_video text,
	issue_comment_photo text,
	issue_comment_createdAt timestamp
)
Language plpgsql
as $$
	begin
		return Query
		select
		iss.IssueID,
		iss.IssueName,
		iss.IssueBoardID,
		iss.IssueDescription,
		iss.IssuePhotos,
		iss.IssueVideo,
		iss.IssueAvtor,
		iss.IssueExecutor,
		issbrds.IssueBoardName,
		isscommnts.IssueCommentText,
		isscommnts.IssueCommentVideo,
		isscommnts.IssueCommentPhoto,
		isscommnts.IssueCommentCreatedAt

		from Issues iss
		left join IssueBoards issbrds on iss.IssueBoardID = issbrds.IssueBoardID
		left join IssuesComments isscommnts on iss.IssueBoardID = isscommnts.IssueBoardID
		where iss.IssueID = issueParam
		order by iss.IssueID, iss.IssueName
	end;
$$;


		