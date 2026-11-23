-- 이미 만든 pay_records 표와 같은 모양입니다.
-- 체크리스트 표는 건드리지 않습니다.
-- 같은 점포, 날짜, 근무자, 시작, 종료면 앱이 그 줄을 덮어씁니다.

create table if not exists public.pay_records (
  id bigint generated always as identity primary key,
  work_date date not null,
  store_code text,
  store_name text,
  worker_name text not null,
  shift_type text,
  start_time text,
  end_time text,
  work_hours numeric,
  late_hours numeric default 0,
  short_hours numeric default 0,
  extra_hours numeric default 0,
  break_hours numeric default 0,
  pay_type text,
  total_hours numeric,
  created_at timestamptz default now()
);

alter table public.pay_records enable row level security;

drop policy if exists "pay_records_anon_select" on public.pay_records;
drop policy if exists "pay_records_anon_insert" on public.pay_records;
drop policy if exists "pay_records_anon_update" on public.pay_records;

create policy "pay_records_anon_select" on public.pay_records for select to anon using (true);
create policy "pay_records_anon_insert" on public.pay_records for insert to anon with check (true);
create policy "pay_records_anon_update" on public.pay_records for update to anon using (true) with check (true);
