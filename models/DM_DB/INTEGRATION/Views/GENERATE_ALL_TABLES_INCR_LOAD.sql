with qrys as (
    select 1 as ord, 'case' source, case_type source_type, sql_text from generate_case_table_incr_load
    union
    select 2 as ord, 'fixture' source, fixture_type source_type, sql_text from generate_fixture_table_incr_load
    union
    --below will recreate location table entirely from location_raw, speial need for bha location redesign projet
    select 3 as ord, 'location' source, null source_type, sql_text from generate_location_tables
    --below will do merge changes from location_raw
    --select 3 as ord, 'location' source, null source_type, sql_text from generate_location_table_incr_load
    union
    select 4 as ord, 'web-user' source, null source_type, sql_text from generate_web_user_table_incr_load
    union
    select 5 as ord, 'action_times' source, null source_type, sql_text from generate_action_time_table_incr_load
    union 
    select 6 as ord, 'case' source, case_type source_type, sql_text from generate_case_table_delete_updates where vw_type = 'STG'
    union
    select 7 as ord, source, source_type, sql_text from count_dm_cases
    union
    select 8 as ord, source, source_type, sql_text from count_dm_fixtures
    union
    select 9 as ord, source, source_type, sql_text from count_dm_locations
    union
    select 10 as ord, source, source_type, sql_text from count_dm_web_users
    union
    select 11 as ord, source, source_type, sql_text from count_dm_action_times
),
final as (
select source, source_type, sql_text from qrys order by ord asc
)

select 
	SOURCE,
	SOURCE_TYPE,
	SQL_TEXT
from final