-- 급여 기록 표. 체크리스트 표는 지우지 않습니다.
create table if not exists public.pay_records (
  id uuid primary key default gen_random_uuid(),
  pay_date date not null,
  store_name text not null,
  store_code text not null default '',
  worker_name text not null default '',
  work_type text not null default '',
  start_time text not null default '',
  end_time text not null default '',
  period text not null default '',
  late_hours numeric not null default 0,
  short_hours numeric not null default 0,
  extra_hours numeric not null default 0,
  shift_name text not null default '',
  reported_at timestamptz not null default now()
);

create unique index if not exists pay_records_one_shift
  on public.pay_records (store_name, pay_date, worker_name, period);

create index if not exists pay_records_date
  on public.pay_records (pay_date, store_name);

create index if not exists checklist_items_store_shift_order
  on public.checklist_items (store_name, shift_key, item_order);

create index if not exists stores_name
  on public.stores (name);

alter table public.stores add column if not exists code text not null default '';

update public.stores s
set code = c.description
from public.checklist_items c
where c.store_name = '__i18n__'
  and c.shift_key = 'access'
  and c.title = s.name
  and coalesce(s.code, '') = '';

alter table public.pay_records enable row level security;

drop policy if exists pay_records_anon_all on public.pay_records;
create policy pay_records_anon_all
  on public.pay_records
  for all
  to anon, authenticated
  using (true)
  with check (true);

grant select, insert, update, delete on public.pay_records to anon, authenticated;
