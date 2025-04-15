create or replace notification integration <% ctx.env.name %>_email_int
    type=email
    enabled=true
    allowed_recipients=('<% ctx.env.email %>');
