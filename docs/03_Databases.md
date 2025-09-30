# Databases — PostgreSQL

## Connection
- **Host (LAN):** 192.168.29.50
- **Port:** 5432
- **DB:** homelab
- **Admin:** homelab_admin
- **Password:** in `stacks/postgres/.env`
- **Tailscale:** `<tailscale-ip>:5432`

### Sample connection strings
- CLI:
PGPASSWORD="<pass>" psql -h 192.168.29.50 -U homelab_admin -d homelab
- JDBC:
- Node (pg):
```js
new Client({ host:'192.168.29.50', port:5432, user:'homelab_admin', password:'<pass>', database:'homelab' })

### Sanity Check (ran)
create schema if not exists sanity;
create table if not exists sanity.ping (
  id serial primary key,
  note text,
  created_at timestamptz default now()
);
insert into sanity.ping (note) values ('hello from homelab');
select * from sanity.ping order by id desc limit 1;

### App Role (least-privilege)
create role app_user login password '<set-strong-app-pass>';
grant connect on database homelab to app_user;
grant usage on schema public to app_user;
alter default privileges in schema public grant select, insert, update, delete on tables to app_user;
alter default privileges in schema public grant usage, select, update on sequences to app_user;

