create or replace alert <% ctx.env.database %>.<% ctx.env.schema %>.alert_log_query
  schedule = '1 hour'
  if (exists (
    -- running query
    select query_id, execution_status, start_time
    from table(snowflake.information_schema.query_history(
        result_limit => 10000
    ))
    where execution_status = 'running'
    and start_time >= dateadd(second, -1 * <% ctx.env.query_seconds %> * 1000, current_timestamp())
    union
    -- completed query
    select query_id, execution_status, start_time
    from snowflake.account_usage.query_history
    where execution_time >= <% ctx.env.query_seconds %> * 1000
    and start_time >= dateadd('day', -1, current_timestamp())
    order by start_time desc
  ))
  then call system$send_email(
    '<% ctx.env.name %>_email_int',
    '<% ctx.env.email %>',
    'Email Alert: log query alert.',
    'long query (over <% ctx.env.query_seconds %>s) was detected.'
);

-- enable alert
alter alert <% ctx.env.database %>.<% ctx.env.schema %>.alert_log_query resume;
