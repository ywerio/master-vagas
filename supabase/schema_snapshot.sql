-- MASTER VAGAS — schema snapshot exported from the live Supabase project.
-- Archival/recovery reference only. Review before applying to another database.
-- Do NOT run this against the already-provisioned production project.
-- Auth users and Supabase-managed schemas are intentionally not recreated.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE SCHEMA IF NOT EXISTS private;

-- Tables
CREATE TABLE public.appeals (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  occurrence_id uuid NOT NULL,
  appellant_id uuid NOT NULL,
  reason text NOT NULL,
  evidence_note text,
  status text DEFAULT 'pending'::text NOT NULL,
  reviewed_by uuid,
  reviewed_at timestamp with time zone,
  decision_note text,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.application_notes (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  application_id uuid NOT NULL,
  author_id uuid NOT NULL,
  note text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.applications (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  job_id uuid NOT NULL,
  candidate_id uuid NOT NULL,
  cover_letter text,
  status text DEFAULT 'received'::text NOT NULL,
  employer_feedback text,
  applied_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  cpf_share_consent_at timestamp with time zone,
  candidate_terms_accepted_at timestamp with time zone\n);

CREATE TABLE public.attendance_records (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  interview_id uuid NOT NULL,
  recorded_by uuid NOT NULL,
  actor_type text NOT NULL,
  attendance_status text NOT NULL,
  checkin_method text,
  evidence_note text,
  recorded_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.audit_logs (\n  id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
  actor_id uuid,
  entity_type text NOT NULL,
  entity_id text,
  action text NOT NULL,
  details jsonb DEFAULT '{}'::jsonb NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.candidate_private_data (\n  user_id uuid NOT NULL,
  cpf text,
  cpf_updated_at timestamp with time zone,
  updated_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.companies (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  owner_id uuid NOT NULL,
  name text NOT NULL,
  slug text,
  description text,
  website text,
  industry text,
  size text,
  logo_url text,
  city text,
  state text,
  is_verified boolean DEFAULT false NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  verification_status text DEFAULT 'pending'::text NOT NULL,
  verification_submitted_at timestamp with time zone,
  verified_at timestamp with time zone,
  verification_notes text\n);

CREATE TABLE public.company_members (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  company_id uuid NOT NULL,
  user_id uuid NOT NULL,
  member_role text DEFAULT 'recruiter'::text NOT NULL,
  status text DEFAULT 'invited'::text NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.company_subscriptions (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  company_id uuid NOT NULL,
  plan_id text NOT NULL,
  status text DEFAULT 'trial'::text NOT NULL,
  started_at timestamp with time zone DEFAULT now() NOT NULL,
  ends_at timestamp with time zone,
  external_customer_id text,
  external_subscription_id text,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.interview_confirmations (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  interview_id uuid NOT NULL,
  actor_id uuid NOT NULL,
  actor_type text NOT NULL,
  action text NOT NULL,
  note text,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.interview_invitations (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  application_id uuid NOT NULL,
  job_id uuid NOT NULL,
  company_id uuid NOT NULL,
  candidate_id uuid NOT NULL,
  created_by uuid NOT NULL,
  starts_at timestamp with time zone NOT NULL,
  ends_at timestamp with time zone,
  timezone text DEFAULT 'America/Fortaleza'::text NOT NULL,
  interview_mode text NOT NULL,
  address text,
  meeting_url text,
  instructions text,
  status text DEFAULT 'pending'::text NOT NULL,
  candidate_responded_at timestamp with time zone,
  cancelled_at timestamp with time zone,
  cancellation_reason text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.jobs (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  company_id uuid NOT NULL,
  created_by uuid NOT NULL,
  title text NOT NULL,
  description text NOT NULL,
  responsibilities text,
  requirements text,
  benefits text,
  employment_type text DEFAULT 'CLT'::text NOT NULL,
  workplace_type text DEFAULT 'Presencial'::text NOT NULL,
  area text,
  city text,
  state text,
  salary_min numeric(12,2),
  salary_max numeric(12,2),
  salary_visible boolean DEFAULT false NOT NULL,
  status text DEFAULT 'draft'::text NOT NULL,
  expires_at date,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  moderation_status text DEFAULT 'pending'::text NOT NULL,
  moderation_reason text,
  reviewed_at timestamp with time zone\n);

CREATE TABLE public.notifications (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  notification_type text NOT NULL,
  title text NOT NULL,
  body text NOT NULL,
  action_url text,
  read_at timestamp with time zone,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.occurrences (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  interview_id uuid NOT NULL,
  reported_by uuid NOT NULL,
  subject_user_id uuid NOT NULL,
  subject_type text NOT NULL,
  occurrence_type text NOT NULL,
  description text,
  status text DEFAULT 'awaiting_response'::text NOT NULL,
  response_deadline timestamp with time zone,
  reviewed_by uuid,
  reviewed_at timestamp with time zone,
  decision_note text,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.plans (\n  id text NOT NULL,
  name text NOT NULL,
  description text,
  monthly_price numeric(10,2) DEFAULT 0 NOT NULL,
  job_limit integer,
  active boolean DEFAULT true NOT NULL\n);

CREATE TABLE public.profiles (\n  id uuid NOT NULL,
  role text DEFAULT 'candidate'::text NOT NULL,
  full_name text DEFAULT ''::text NOT NULL,
  phone text,
  city text,
  state text,
  headline text,
  bio text,
  skills text[] DEFAULT '{}'::text[] NOT NULL,
  experience_years numeric(4,1),
  education text,
  resume_path text,
  avatar_url text,
  created_at timestamp with time zone DEFAULT now() NOT NULL,
  updated_at timestamp with time zone DEFAULT now() NOT NULL,
  cpf_share_ready boolean DEFAULT false NOT NULL\n);

CREATE TABLE public.reputation_events (\n  id uuid DEFAULT gen_random_uuid() NOT NULL,
  user_id uuid NOT NULL,
  company_id uuid,
  occurrence_id uuid,
  event_type text NOT NULL,
  severity integer DEFAULT 0 NOT NULL,
  starts_at timestamp with time zone,
  ends_at timestamp with time zone,
  is_active boolean DEFAULT true NOT NULL,
  created_by uuid,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

CREATE TABLE public.saved_jobs (\n  candidate_id uuid NOT NULL,
  job_id uuid NOT NULL,
  created_at timestamp with time zone DEFAULT now() NOT NULL\n);

-- Primary keys, unique constraints, checks and foreign keys
ALTER TABLE public.appeals ADD CONSTRAINT appeals_appellant_id_fkey FOREIGN KEY (appellant_id) REFERENCES profiles(id);
ALTER TABLE public.appeals ADD CONSTRAINT appeals_occurrence_id_fkey FOREIGN KEY (occurrence_id) REFERENCES occurrences(id) ON DELETE CASCADE;
ALTER TABLE public.appeals ADD CONSTRAINT appeals_pkey PRIMARY KEY (id);
ALTER TABLE public.appeals ADD CONSTRAINT appeals_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES profiles(id);
ALTER TABLE public.appeals ADD CONSTRAINT appeals_status_check CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'rejected'::text]));
ALTER TABLE public.application_notes ADD CONSTRAINT application_notes_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;
ALTER TABLE public.application_notes ADD CONSTRAINT application_notes_author_id_fkey FOREIGN KEY (author_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.application_notes ADD CONSTRAINT application_notes_pkey PRIMARY KEY (id);
ALTER TABLE public.applications ADD CONSTRAINT applications_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.applications ADD CONSTRAINT applications_job_id_candidate_id_key UNIQUE (job_id, candidate_id);
ALTER TABLE public.applications ADD CONSTRAINT applications_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE;
ALTER TABLE public.applications ADD CONSTRAINT applications_pkey PRIMARY KEY (id);
ALTER TABLE public.applications ADD CONSTRAINT applications_status_check CHECK (status = ANY (ARRAY['received'::text, 'screening'::text, 'interview'::text, 'offer'::text, 'hired'::text, 'rejected'::text, 'withdrawn'::text]));
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_actor_type_check CHECK (actor_type = ANY (ARRAY['candidate'::text, 'company'::text, 'admin'::text]));
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_attendance_status_check CHECK (attendance_status = ANY (ARRAY['present'::text, 'absent'::text, 'late'::text, 'rescheduled'::text, 'not_confirmed'::text]));
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_checkin_method_check CHECK (checkin_method = ANY (ARRAY['qr'::text, 'code'::text, 'manual'::text, 'online_confirmation'::text]));
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_interview_id_fkey FOREIGN KEY (interview_id) REFERENCES interview_invitations(id) ON DELETE CASCADE;
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_pkey PRIMARY KEY (id);
ALTER TABLE public.attendance_records ADD CONSTRAINT attendance_records_recorded_by_fkey FOREIGN KEY (recorded_by) REFERENCES profiles(id);
ALTER TABLE public.audit_logs ADD CONSTRAINT audit_logs_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES profiles(id);
ALTER TABLE public.audit_logs ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (id);
ALTER TABLE public.candidate_private_data ADD CONSTRAINT candidate_private_data_pkey PRIMARY KEY (user_id);
ALTER TABLE public.candidate_private_data ADD CONSTRAINT candidate_private_data_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.companies ADD CONSTRAINT companies_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.companies ADD CONSTRAINT companies_pkey PRIMARY KEY (id);
ALTER TABLE public.companies ADD CONSTRAINT companies_slug_key UNIQUE (slug);
ALTER TABLE public.companies ADD CONSTRAINT companies_verification_status_check CHECK (verification_status = ANY (ARRAY['pending'::text, 'in_review'::text, 'verified'::text, 'rejected'::text, 'suspended'::text]));
ALTER TABLE public.company_members ADD CONSTRAINT company_members_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
ALTER TABLE public.company_members ADD CONSTRAINT company_members_company_id_user_id_key UNIQUE (company_id, user_id);
ALTER TABLE public.company_members ADD CONSTRAINT company_members_member_role_check CHECK (member_role = ANY (ARRAY['owner'::text, 'admin'::text, 'recruiter'::text, 'viewer'::text]));
ALTER TABLE public.company_members ADD CONSTRAINT company_members_pkey PRIMARY KEY (id);
ALTER TABLE public.company_members ADD CONSTRAINT company_members_status_check CHECK (status = ANY (ARRAY['invited'::text, 'active'::text, 'suspended'::text]));
ALTER TABLE public.company_members ADD CONSTRAINT company_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.company_subscriptions ADD CONSTRAINT company_subscriptions_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
ALTER TABLE public.company_subscriptions ADD CONSTRAINT company_subscriptions_pkey PRIMARY KEY (id);
ALTER TABLE public.company_subscriptions ADD CONSTRAINT company_subscriptions_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES plans(id);
ALTER TABLE public.company_subscriptions ADD CONSTRAINT company_subscriptions_status_check CHECK (status = ANY (ARRAY['trial'::text, 'active'::text, 'past_due'::text, 'cancelled'::text, 'expired'::text]));
ALTER TABLE public.interview_confirmations ADD CONSTRAINT interview_confirmations_action_check CHECK (action = ANY (ARRAY['accepted'::text, 'declined'::text, 'attendance_confirmed'::text, 'cancelled'::text]));
ALTER TABLE public.interview_confirmations ADD CONSTRAINT interview_confirmations_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES profiles(id);
ALTER TABLE public.interview_confirmations ADD CONSTRAINT interview_confirmations_actor_type_check CHECK (actor_type = ANY (ARRAY['candidate'::text, 'company'::text]));
ALTER TABLE public.interview_confirmations ADD CONSTRAINT interview_confirmations_interview_id_fkey FOREIGN KEY (interview_id) REFERENCES interview_invitations(id) ON DELETE CASCADE;
ALTER TABLE public.interview_confirmations ADD CONSTRAINT interview_confirmations_pkey PRIMARY KEY (id);
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_application_id_fkey FOREIGN KEY (application_id) REFERENCES applications(id) ON DELETE CASCADE;
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_check CHECK (ends_at IS NULL OR ends_at > starts_at);
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_check1 CHECK (interview_mode = 'in_person'::text AND COALESCE(address, ''::text) <> ''::text OR interview_mode = 'online'::text AND COALESCE(meeting_url, ''::text) <> ''::text OR interview_mode = 'phone'::text);
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_created_by_fkey FOREIGN KEY (created_by) REFERENCES profiles(id);
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_interview_mode_check CHECK (interview_mode = ANY (ARRAY['in_person'::text, 'online'::text, 'phone'::text]));
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE;
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_pkey PRIMARY KEY (id);
ALTER TABLE public.interview_invitations ADD CONSTRAINT interview_invitations_status_check CHECK (status = ANY (ARRAY['pending'::text, 'accepted'::text, 'declined'::text, 'cancelled'::text, 'completed'::text, 'no_show_pending_review'::text]));
ALTER TABLE public.jobs ADD CONSTRAINT jobs_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
ALTER TABLE public.jobs ADD CONSTRAINT jobs_created_by_fkey FOREIGN KEY (created_by) REFERENCES profiles(id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_employment_type_check CHECK (employment_type = ANY (ARRAY['CLT'::text, 'PJ'::text, 'Estágio'::text, 'Temporário'::text, 'Aprendiz'::text, 'Freelancer'::text]));
ALTER TABLE public.jobs ADD CONSTRAINT jobs_moderation_status_check CHECK (moderation_status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text, 'needs_review'::text]));
ALTER TABLE public.jobs ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
ALTER TABLE public.jobs ADD CONSTRAINT jobs_status_check CHECK (status = ANY (ARRAY['draft'::text, 'published'::text, 'paused'::text, 'closed'::text]));
ALTER TABLE public.jobs ADD CONSTRAINT jobs_workplace_type_check CHECK (workplace_type = ANY (ARRAY['Presencial'::text, 'Híbrido'::text, 'Remoto'::text]));
ALTER TABLE public.notifications ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
ALTER TABLE public.notifications ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_interview_id_fkey FOREIGN KEY (interview_id) REFERENCES interview_invitations(id) ON DELETE CASCADE;
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_occurrence_type_check CHECK (occurrence_type = ANY (ARRAY['no_show'::text, 'late_cancellation'::text, 'false_job'::text, 'employer_no_show'::text, 'misconduct'::text, 'other'::text]));
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_pkey PRIMARY KEY (id);
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_reported_by_fkey FOREIGN KEY (reported_by) REFERENCES profiles(id);
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_reviewed_by_fkey FOREIGN KEY (reviewed_by) REFERENCES profiles(id);
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_status_check CHECK (status = ANY (ARRAY['awaiting_response'::text, 'under_review'::text, 'justified'::text, 'confirmed'::text, 'dismissed'::text]));
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_subject_type_check CHECK (subject_type = ANY (ARRAY['candidate'::text, 'company'::text]));
ALTER TABLE public.occurrences ADD CONSTRAINT occurrences_subject_user_id_fkey FOREIGN KEY (subject_user_id) REFERENCES profiles(id);
ALTER TABLE public.plans ADD CONSTRAINT plans_pkey PRIMARY KEY (id);
ALTER TABLE public.profiles ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;
ALTER TABLE public.profiles ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);
ALTER TABLE public.profiles ADD CONSTRAINT profiles_role_check CHECK (role = ANY (ARRAY['candidate'::text, 'employer'::text, 'admin'::text]));
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_company_id_fkey FOREIGN KEY (company_id) REFERENCES companies(id) ON DELETE CASCADE;
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_created_by_fkey FOREIGN KEY (created_by) REFERENCES profiles(id);
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_event_type_check CHECK (event_type = ANY (ARRAY['positive_attendance'::text, 'warning'::text, 'temporary_restriction'::text, 'account_suspension'::text, 'employer_reliability_issue'::text, 'cleared'::text]));
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_occurrence_id_fkey FOREIGN KEY (occurrence_id) REFERENCES occurrences(id) ON DELETE SET NULL;
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_pkey PRIMARY KEY (id);
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_severity_check CHECK (severity >= 0 AND severity <= 3);
ALTER TABLE public.reputation_events ADD CONSTRAINT reputation_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.saved_jobs ADD CONSTRAINT saved_jobs_candidate_id_fkey FOREIGN KEY (candidate_id) REFERENCES profiles(id) ON DELETE CASCADE;
ALTER TABLE public.saved_jobs ADD CONSTRAINT saved_jobs_job_id_fkey FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE;
ALTER TABLE public.saved_jobs ADD CONSTRAINT saved_jobs_pkey PRIMARY KEY (candidate_id, job_id);

-- Additional indexes (constraint-backed indexes are excluded)
CREATE INDEX application_notes_application_idx ON public.application_notes USING btree (application_id);
CREATE INDEX application_notes_author_idx ON public.application_notes USING btree (author_id);
CREATE INDEX applications_candidate_idx ON public.applications USING btree (candidate_id, applied_at DESC);
CREATE INDEX applications_job_idx ON public.applications USING btree (job_id, status);
CREATE INDEX companies_owner_idx ON public.companies USING btree (owner_id);
CREATE INDEX company_subscriptions_company_idx ON public.company_subscriptions USING btree (company_id);
CREATE INDEX company_subscriptions_plan_idx ON public.company_subscriptions USING btree (plan_id);
CREATE INDEX idx_companies_verification_status ON public.companies USING btree (verification_status);
CREATE INDEX idx_interviews_application ON public.interview_invitations USING btree (application_id);
CREATE INDEX idx_interviews_candidate_start ON public.interview_invitations USING btree (candidate_id, starts_at);
CREATE INDEX idx_interviews_company_start ON public.interview_invitations USING btree (company_id, starts_at);
CREATE INDEX idx_jobs_moderation_status ON public.jobs USING btree (moderation_status);
CREATE INDEX idx_notifications_user_unread ON public.notifications USING btree (user_id, created_at DESC) WHERE (read_at IS NULL);
CREATE INDEX idx_occurrences_subject_status ON public.occurrences USING btree (subject_user_id, status);
CREATE INDEX idx_reputation_user_active ON public.reputation_events USING btree (user_id, is_active, ends_at);
CREATE INDEX jobs_city_state_idx ON public.jobs USING btree (city, state);
CREATE INDEX jobs_company_idx ON public.jobs USING btree (company_id);
CREATE INDEX jobs_created_by_idx ON public.jobs USING btree (created_by);
CREATE INDEX jobs_public_search_idx ON public.jobs USING btree (status, created_at DESC);
CREATE INDEX saved_jobs_job_idx ON public.saved_jobs USING btree (job_id);

-- Database functions
CREATE OR REPLACE FUNCTION private.guard_application_cpf_consent()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if new.cpf_share_consent_at is distinct from old.cpf_share_consent_at
     and auth.uid() is not null
     and auth.uid() <> old.candidate_id
     and not private.is_admin() then
    raise exception 'Somente o candidato pode autorizar o compartilhamento do CPF.';
  end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.guard_candidate_interview_response()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if auth.uid() = old.candidate_id and not private.is_admin() then
    if new.application_id is distinct from old.application_id
      or new.job_id is distinct from old.job_id
      or new.company_id is distinct from old.company_id
      or new.candidate_id is distinct from old.candidate_id
      or new.created_by is distinct from old.created_by
      or new.starts_at is distinct from old.starts_at
      or new.ends_at is distinct from old.ends_at
      or new.timezone is distinct from old.timezone
      or new.interview_mode is distinct from old.interview_mode
      or new.address is distinct from old.address
      or new.meeting_url is distinct from old.meeting_url
      or new.instructions is distinct from old.instructions
      or new.cancelled_at is distinct from old.cancelled_at
      or new.cancellation_reason is distinct from old.cancellation_reason then
      raise exception 'O candidato pode responder ao convite, mas não alterar os dados agendados pela empresa.';
    end if;
    if new.status not in ('accepted','declined') then
      raise exception 'Resposta de convite inválida.';
    end if;
  end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.guard_company_verification()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if auth.uid() is not null and not private.is_admin() then
    if new.is_verified is distinct from old.is_verified
       or new.verification_status is distinct from old.verification_status
       or new.verified_at is distinct from old.verified_at then
      raise exception 'Somente a administração pode alterar a verificação da empresa.';
    end if;
  end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.guard_job_moderation()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if (
    new.moderation_status is distinct from old.moderation_status
    or new.moderation_reason is distinct from old.moderation_reason
    or new.reviewed_at is distinct from old.reviewed_at
  ) and auth.uid() is not null and not private.is_admin() then
    raise exception 'Somente a administração ou serviço autorizado pode alterar a moderação da vaga.';
  end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.guard_profile_role()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
begin
  if new.role is distinct from old.role
     and auth.uid() is not null
     and not private.is_admin() then
    raise exception 'Somente a administração pode alterar o tipo de conta.';
  end if;
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.handle_new_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO ''
AS $function$
begin
  insert into public.profiles(id, role, full_name)
  values (
    new.id,
    case when new.raw_user_meta_data->>'account_type' = 'employer' then 'employer' else 'candidate' end,
    coalesce(new.raw_user_meta_data->>'full_name','')
  );
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION private.is_admin()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1 from public.profiles p
    where p.id = (select auth.uid()) and p.role = 'admin'
  );
$function$


CREATE OR REPLACE FUNCTION private.is_company_member(target_company_id uuid)
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  select exists (
    select 1 from public.companies c
    where c.id = target_company_id and c.owner_id = auth.uid()
  ) or exists (
    select 1 from public.company_members m
    where m.company_id = target_company_id
      and m.user_id = auth.uid()
      and m.status = 'active'
      and m.member_role in ('owner','admin','recruiter','viewer')
  );
$function$


CREATE OR REPLACE FUNCTION public.prevent_profile_role_change()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if new.role is distinct from old.role and not private.is_admin() then
    raise exception 'Perfil de acesso não pode ser alterado pelo próprio usuário';
  end if;
  new.updated_at = now();
  return new;
end;
$function$


CREATE OR REPLACE FUNCTION public.protect_application_identity()
 RETURNS trigger
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$
begin
  if new.job_id is distinct from old.job_id or new.candidate_id is distinct from old.candidate_id then
    raise exception 'A vaga e o candidato da candidatura não podem ser alterados';
  end if;
  new.updated_at = now();
  return new;
end;
$function$


-- Triggers
CREATE TRIGGER guard_application_cpf_consent BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION private.guard_application_cpf_consent();
CREATE TRIGGER guard_candidate_interview_response BEFORE UPDATE ON interview_invitations FOR EACH ROW EXECUTE FUNCTION private.guard_candidate_interview_response();
CREATE TRIGGER guard_company_verification BEFORE UPDATE ON companies FOR EACH ROW EXECUTE FUNCTION private.guard_company_verification();
CREATE TRIGGER guard_job_moderation BEFORE UPDATE ON jobs FOR EACH ROW EXECUTE FUNCTION private.guard_job_moderation();
CREATE TRIGGER guard_profile_role BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION private.guard_profile_role();
CREATE TRIGGER protect_application_identity BEFORE UPDATE ON applications FOR EACH ROW EXECUTE FUNCTION protect_application_identity();
CREATE TRIGGER protect_profile_role BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION prevent_profile_role_change();

-- Row Level Security
ALTER TABLE public.appeals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.application_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.applications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.attendance_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.candidate_private_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.company_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.company_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_confirmations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.interview_invitations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.occurrences ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reputation_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_jobs ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY appeals_admin_update ON public.appeals FOR UPDATE TO authenticated USING (private.is_admin()) WITH CHECK (private.is_admin());
CREATE POLICY appeals_insert ON public.appeals FOR INSERT TO authenticated WITH CHECK (((appellant_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM occurrences o
  WHERE ((o.id = appeals.occurrence_id) AND (o.subject_user_id = auth.uid()))))));
CREATE POLICY appeals_read ON public.appeals FOR SELECT TO authenticated USING (((appellant_id = auth.uid()) OR private.is_admin()));
CREATE POLICY application_notes_employer_insert ON public.application_notes FOR INSERT TO authenticated WITH CHECK (((author_id = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM ((applications a
     JOIN jobs j ON ((j.id = a.job_id)))
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((a.id = application_notes.application_id) AND (c.owner_id = ( SELECT auth.uid() AS uid)))))));
CREATE POLICY application_notes_employer_read ON public.application_notes FOR SELECT TO authenticated USING (((author_id = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
   FROM ((applications a
     JOIN jobs j ON ((j.id = a.job_id)))
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((a.id = application_notes.application_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))) OR private.is_admin()));
CREATE POLICY applications_candidate_insert ON public.applications FOR INSERT TO authenticated WITH CHECK (((candidate_id = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM jobs j
  WHERE ((j.id = applications.job_id) AND (j.status = 'published'::text))))));
CREATE POLICY applications_candidate_read ON public.applications FOR SELECT TO authenticated USING (((candidate_id = ( SELECT auth.uid() AS uid)) OR (EXISTS ( SELECT 1
   FROM (jobs j
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((j.id = applications.job_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))) OR private.is_admin()));
CREATE POLICY applications_employer_update ON public.applications FOR UPDATE TO authenticated USING (((EXISTS ( SELECT 1
   FROM (jobs j
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((j.id = applications.job_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))) OR private.is_admin())) WITH CHECK (((EXISTS ( SELECT 1
   FROM (jobs j
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((j.id = applications.job_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))) OR private.is_admin()));
CREATE POLICY attendance_records_insert ON public.attendance_records FOR INSERT TO authenticated WITH CHECK (((recorded_by = auth.uid()) AND (EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = attendance_records.interview_id) AND (((attendance_records.actor_type = 'candidate'::text) AND (i.candidate_id = auth.uid())) OR ((attendance_records.actor_type = 'company'::text) AND private.is_company_member(i.company_id)) OR ((attendance_records.actor_type = 'admin'::text) AND private.is_admin())))))));
CREATE POLICY attendance_records_read ON public.attendance_records FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = attendance_records.interview_id) AND ((i.candidate_id = auth.uid()) OR private.is_company_member(i.company_id) OR private.is_admin())))));
CREATE POLICY audit_logs_admin_read ON public.audit_logs FOR SELECT TO authenticated USING (private.is_admin());
CREATE POLICY candidate_private_data_delete ON public.candidate_private_data FOR DELETE TO authenticated USING (((user_id = auth.uid()) OR private.is_admin()));
CREATE POLICY candidate_private_data_insert ON public.candidate_private_data FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));
CREATE POLICY candidate_private_data_select ON public.candidate_private_data FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR private.is_admin() OR (EXISTS ( SELECT 1
   FROM (applications a
     JOIN jobs j ON ((j.id = a.job_id)))
  WHERE ((a.candidate_id = candidate_private_data.user_id) AND (a.cpf_share_consent_at IS NOT NULL) AND (j.company_id IN ( SELECT c.id
           FROM companies c
          WHERE private.is_company_member(c.id))))))));
CREATE POLICY candidate_private_data_update ON public.candidate_private_data FOR UPDATE TO authenticated USING (((user_id = auth.uid()) OR private.is_admin())) WITH CHECK (((user_id = auth.uid()) OR private.is_admin()));
CREATE POLICY companies_owner_delete ON public.companies FOR DELETE TO authenticated USING (((owner_id = ( SELECT auth.uid() AS uid)) OR private.is_admin()));
CREATE POLICY companies_owner_insert ON public.companies FOR INSERT TO authenticated WITH CHECK (((owner_id = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM profiles p
  WHERE ((p.id = ( SELECT auth.uid() AS uid)) AND (p.role = 'employer'::text))))));
CREATE POLICY companies_owner_update ON public.companies FOR UPDATE TO authenticated USING (((owner_id = ( SELECT auth.uid() AS uid)) OR private.is_admin())) WITH CHECK (((owner_id = ( SELECT auth.uid() AS uid)) OR private.is_admin()));
CREATE POLICY companies_public_read ON public.companies FOR SELECT TO anon, authenticated USING (((is_verified = true) OR (owner_id = auth.uid()) OR private.is_admin()));
CREATE POLICY company_members_manage ON public.company_members FOR ALL TO authenticated USING (((EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = company_members.company_id) AND (c.owner_id = auth.uid())))) OR private.is_admin())) WITH CHECK (((EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = company_members.company_id) AND (c.owner_id = auth.uid())))) OR private.is_admin()));
CREATE POLICY company_members_read ON public.company_members FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR private.is_admin() OR private.is_company_member(company_id)));
CREATE POLICY interview_confirmations_insert ON public.interview_confirmations FOR INSERT TO authenticated WITH CHECK (((actor_id = auth.uid()) AND (EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = interview_confirmations.interview_id) AND (((interview_confirmations.actor_type = 'candidate'::text) AND (i.candidate_id = auth.uid())) OR ((interview_confirmations.actor_type = 'company'::text) AND private.is_company_member(i.company_id))))))));
CREATE POLICY interview_confirmations_read ON public.interview_confirmations FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = interview_confirmations.interview_id) AND ((i.candidate_id = auth.uid()) OR private.is_company_member(i.company_id) OR private.is_admin())))));
CREATE POLICY interview_invitations_candidate_update ON public.interview_invitations FOR UPDATE TO authenticated USING ((candidate_id = auth.uid())) WITH CHECK ((candidate_id = auth.uid()));
CREATE POLICY interview_invitations_company_insert ON public.interview_invitations FOR INSERT TO authenticated WITH CHECK ((private.is_company_member(company_id) AND (EXISTS ( SELECT 1
   FROM applications a
  WHERE ((a.id = interview_invitations.application_id) AND (a.job_id = a.job_id) AND (a.candidate_id = a.candidate_id))))));
CREATE POLICY interview_invitations_company_update ON public.interview_invitations FOR UPDATE TO authenticated USING ((private.is_company_member(company_id) OR private.is_admin())) WITH CHECK ((private.is_company_member(company_id) OR private.is_admin()));
CREATE POLICY interview_invitations_read ON public.interview_invitations FOR SELECT TO authenticated USING (((candidate_id = auth.uid()) OR private.is_company_member(company_id) OR private.is_admin()));
CREATE POLICY jobs_employer_delete ON public.jobs FOR DELETE TO authenticated USING (((created_by = ( SELECT auth.uid() AS uid)) OR private.is_admin()));
CREATE POLICY jobs_employer_insert ON public.jobs FOR INSERT TO authenticated WITH CHECK (((created_by = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = jobs.company_id) AND (c.owner_id = ( SELECT auth.uid() AS uid)))))));
CREATE POLICY jobs_employer_update ON public.jobs FOR UPDATE TO authenticated USING (((created_by = ( SELECT auth.uid() AS uid)) OR private.is_admin())) WITH CHECK ((private.is_admin() OR ((created_by = ( SELECT auth.uid() AS uid)) AND (EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = jobs.company_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))))));
CREATE POLICY jobs_public_published_read ON public.jobs FOR SELECT TO anon, authenticated USING ((((status = 'published'::text) AND (moderation_status = 'approved'::text) AND (EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = jobs.company_id) AND (c.is_verified = true))))) OR (created_by = auth.uid()) OR private.is_admin()));
CREATE POLICY notifications_read ON public.notifications FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR private.is_admin()));
CREATE POLICY notifications_update ON public.notifications FOR UPDATE TO authenticated USING ((user_id = auth.uid())) WITH CHECK ((user_id = auth.uid()));
CREATE POLICY occurrences_admin_update ON public.occurrences FOR UPDATE TO authenticated USING (private.is_admin()) WITH CHECK (private.is_admin());
CREATE POLICY occurrences_insert ON public.occurrences FOR INSERT TO authenticated WITH CHECK (((reported_by = auth.uid()) AND (EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = occurrences.interview_id) AND (((occurrences.subject_type = 'candidate'::text) AND (i.candidate_id = occurrences.subject_user_id) AND private.is_company_member(i.company_id)) OR ((occurrences.subject_type = 'company'::text) AND (occurrences.subject_user_id = i.created_by) AND (i.candidate_id = auth.uid()))))))));
CREATE POLICY occurrences_read ON public.occurrences FOR SELECT TO authenticated USING (((reported_by = auth.uid()) OR (subject_user_id = auth.uid()) OR private.is_admin() OR (EXISTS ( SELECT 1
   FROM interview_invitations i
  WHERE ((i.id = occurrences.interview_id) AND private.is_company_member(i.company_id))))));
CREATE POLICY plans_public_read ON public.plans FOR SELECT TO anon, authenticated USING ((active = true));
CREATE POLICY profiles_insert_self ON public.profiles FOR INSERT TO authenticated WITH CHECK (((id = ( SELECT auth.uid() AS uid)) AND (role = ANY (ARRAY['candidate'::text, 'employer'::text]))));
CREATE POLICY profiles_read_authorized ON public.profiles FOR SELECT TO authenticated USING (((id = ( SELECT auth.uid() AS uid)) OR private.is_admin() OR (EXISTS ( SELECT 1
   FROM ((applications a
     JOIN jobs j ON ((j.id = a.job_id)))
     JOIN companies c ON ((c.id = j.company_id)))
  WHERE ((a.candidate_id = profiles.id) AND (c.owner_id = ( SELECT auth.uid() AS uid)))))));
CREATE POLICY profiles_update_self_or_admin ON public.profiles FOR UPDATE TO authenticated USING (((id = ( SELECT auth.uid() AS uid)) OR private.is_admin())) WITH CHECK (((id = ( SELECT auth.uid() AS uid)) OR private.is_admin()));
CREATE POLICY reputation_events_admin_manage ON public.reputation_events FOR ALL TO authenticated USING (private.is_admin()) WITH CHECK (private.is_admin());
CREATE POLICY reputation_events_read ON public.reputation_events FOR SELECT TO authenticated USING (((user_id = auth.uid()) OR private.is_admin()));
CREATE POLICY saved_jobs_delete_self ON public.saved_jobs FOR DELETE TO authenticated USING ((candidate_id = ( SELECT auth.uid() AS uid)));
CREATE POLICY saved_jobs_insert_self ON public.saved_jobs FOR INSERT TO authenticated WITH CHECK ((candidate_id = ( SELECT auth.uid() AS uid)));
CREATE POLICY saved_jobs_self ON public.saved_jobs FOR SELECT TO authenticated USING ((candidate_id = ( SELECT auth.uid() AS uid)));
CREATE POLICY subscriptions_owner_read ON public.company_subscriptions FOR SELECT TO authenticated USING (((EXISTS ( SELECT 1
   FROM companies c
  WHERE ((c.id = company_subscriptions.company_id) AND (c.owner_id = ( SELECT auth.uid() AS uid))))) OR private.is_admin()));

-- Table grants for API roles
GRANT DELETE ON TABLE public.appeals TO anon;
GRANT DELETE ON TABLE public.appeals TO authenticated;
GRANT DELETE ON TABLE public.appeals TO service_role;
GRANT DELETE ON TABLE public.application_notes TO anon;
GRANT DELETE ON TABLE public.application_notes TO authenticated;
GRANT DELETE ON TABLE public.application_notes TO service_role;
GRANT DELETE ON TABLE public.applications TO anon;
GRANT DELETE ON TABLE public.applications TO authenticated;
GRANT DELETE ON TABLE public.applications TO service_role;
GRANT DELETE ON TABLE public.attendance_records TO anon;
GRANT DELETE ON TABLE public.attendance_records TO authenticated;
GRANT DELETE ON TABLE public.attendance_records TO service_role;
GRANT DELETE ON TABLE public.audit_logs TO anon;
GRANT DELETE ON TABLE public.audit_logs TO authenticated;
GRANT DELETE ON TABLE public.audit_logs TO service_role;
GRANT DELETE ON TABLE public.candidate_private_data TO anon;
GRANT DELETE ON TABLE public.candidate_private_data TO authenticated;
GRANT DELETE ON TABLE public.candidate_private_data TO service_role;
GRANT DELETE ON TABLE public.companies TO anon;
GRANT DELETE ON TABLE public.companies TO authenticated;
GRANT DELETE ON TABLE public.companies TO service_role;
GRANT DELETE ON TABLE public.company_members TO anon;
GRANT DELETE ON TABLE public.company_members TO authenticated;
GRANT DELETE ON TABLE public.company_members TO service_role;
GRANT DELETE ON TABLE public.company_subscriptions TO anon;
GRANT DELETE ON TABLE public.company_subscriptions TO authenticated;
GRANT DELETE ON TABLE public.company_subscriptions TO service_role;
GRANT DELETE ON TABLE public.interview_confirmations TO anon;
GRANT DELETE ON TABLE public.interview_confirmations TO authenticated;
GRANT DELETE ON TABLE public.interview_confirmations TO service_role;
GRANT DELETE ON TABLE public.interview_invitations TO anon;
GRANT DELETE ON TABLE public.interview_invitations TO authenticated;
GRANT DELETE ON TABLE public.interview_invitations TO service_role;
GRANT DELETE ON TABLE public.jobs TO anon;
GRANT DELETE ON TABLE public.jobs TO authenticated;
GRANT DELETE ON TABLE public.jobs TO service_role;
GRANT DELETE ON TABLE public.notifications TO anon;
GRANT DELETE ON TABLE public.notifications TO authenticated;
GRANT DELETE ON TABLE public.notifications TO service_role;
GRANT DELETE ON TABLE public.occurrences TO anon;
GRANT DELETE ON TABLE public.occurrences TO authenticated;
GRANT DELETE ON TABLE public.occurrences TO service_role;
GRANT DELETE ON TABLE public.plans TO anon;
GRANT DELETE ON TABLE public.plans TO authenticated;
GRANT DELETE ON TABLE public.plans TO service_role;
GRANT DELETE ON TABLE public.profiles TO anon;
GRANT DELETE ON TABLE public.profiles TO authenticated;
GRANT DELETE ON TABLE public.profiles TO service_role;
GRANT DELETE ON TABLE public.reputation_events TO anon;
GRANT DELETE ON TABLE public.reputation_events TO authenticated;
GRANT DELETE ON TABLE public.reputation_events TO service_role;
GRANT DELETE ON TABLE public.saved_jobs TO anon;
GRANT DELETE ON TABLE public.saved_jobs TO authenticated;
GRANT DELETE ON TABLE public.saved_jobs TO service_role;
GRANT INSERT ON TABLE public.appeals TO anon;
GRANT INSERT ON TABLE public.appeals TO authenticated;
GRANT INSERT ON TABLE public.appeals TO service_role;
GRANT INSERT ON TABLE public.application_notes TO anon;
GRANT INSERT ON TABLE public.application_notes TO authenticated;
GRANT INSERT ON TABLE public.application_notes TO service_role;
GRANT INSERT ON TABLE public.applications TO anon;
GRANT INSERT ON TABLE public.applications TO authenticated;
GRANT INSERT ON TABLE public.applications TO service_role;
GRANT INSERT ON TABLE public.attendance_records TO anon;
GRANT INSERT ON TABLE public.attendance_records TO authenticated;
GRANT INSERT ON TABLE public.attendance_records TO service_role;
GRANT INSERT ON TABLE public.audit_logs TO anon;
GRANT INSERT ON TABLE public.audit_logs TO authenticated;
GRANT INSERT ON TABLE public.audit_logs TO service_role;
GRANT INSERT ON TABLE public.candidate_private_data TO anon;
GRANT INSERT ON TABLE public.candidate_private_data TO authenticated;
GRANT INSERT ON TABLE public.candidate_private_data TO service_role;
GRANT INSERT ON TABLE public.companies TO anon;
GRANT INSERT ON TABLE public.companies TO authenticated;
GRANT INSERT ON TABLE public.companies TO service_role;
GRANT INSERT ON TABLE public.company_members TO anon;
GRANT INSERT ON TABLE public.company_members TO authenticated;
GRANT INSERT ON TABLE public.company_members TO service_role;
GRANT INSERT ON TABLE public.company_subscriptions TO anon;
GRANT INSERT ON TABLE public.company_subscriptions TO authenticated;
GRANT INSERT ON TABLE public.company_subscriptions TO service_role;
GRANT INSERT ON TABLE public.interview_confirmations TO anon;
GRANT INSERT ON TABLE public.interview_confirmations TO authenticated;
GRANT INSERT ON TABLE public.interview_confirmations TO service_role;
GRANT INSERT ON TABLE public.interview_invitations TO anon;
GRANT INSERT ON TABLE public.interview_invitations TO authenticated;
GRANT INSERT ON TABLE public.interview_invitations TO service_role;
GRANT INSERT ON TABLE public.jobs TO anon;
GRANT INSERT ON TABLE public.jobs TO authenticated;
GRANT INSERT ON TABLE public.jobs TO service_role;
GRANT INSERT ON TABLE public.notifications TO anon;
GRANT INSERT ON TABLE public.notifications TO authenticated;
GRANT INSERT ON TABLE public.notifications TO service_role;
GRANT INSERT ON TABLE public.occurrences TO anon;
GRANT INSERT ON TABLE public.occurrences TO authenticated;
GRANT INSERT ON TABLE public.occurrences TO service_role;
GRANT INSERT ON TABLE public.plans TO anon;
GRANT INSERT ON TABLE public.plans TO authenticated;
GRANT INSERT ON TABLE public.plans TO service_role;
GRANT INSERT ON TABLE public.profiles TO anon;
GRANT INSERT ON TABLE public.profiles TO authenticated;
GRANT INSERT ON TABLE public.profiles TO service_role;
GRANT INSERT ON TABLE public.reputation_events TO anon;
GRANT INSERT ON TABLE public.reputation_events TO authenticated;
GRANT INSERT ON TABLE public.reputation_events TO service_role;
GRANT INSERT ON TABLE public.saved_jobs TO anon;
GRANT INSERT ON TABLE public.saved_jobs TO authenticated;
GRANT INSERT ON TABLE public.saved_jobs TO service_role;
GRANT REFERENCES ON TABLE public.appeals TO anon;
GRANT REFERENCES ON TABLE public.appeals TO authenticated;
GRANT REFERENCES ON TABLE public.appeals TO service_role;
GRANT REFERENCES ON TABLE public.application_notes TO anon;
GRANT REFERENCES ON TABLE public.application_notes TO authenticated;
GRANT REFERENCES ON TABLE public.application_notes TO service_role;
GRANT REFERENCES ON TABLE public.applications TO anon;
GRANT REFERENCES ON TABLE public.applications TO authenticated;
GRANT REFERENCES ON TABLE public.applications TO service_role;
GRANT REFERENCES ON TABLE public.attendance_records TO anon;
GRANT REFERENCES ON TABLE public.attendance_records TO authenticated;
GRANT REFERENCES ON TABLE public.attendance_records TO service_role;
GRANT REFERENCES ON TABLE public.audit_logs TO anon;
GRANT REFERENCES ON TABLE public.audit_logs TO authenticated;
GRANT REFERENCES ON TABLE public.audit_logs TO service_role;
GRANT REFERENCES ON TABLE public.candidate_private_data TO anon;
GRANT REFERENCES ON TABLE public.candidate_private_data TO authenticated;
GRANT REFERENCES ON TABLE public.candidate_private_data TO service_role;
GRANT REFERENCES ON TABLE public.companies TO anon;
GRANT REFERENCES ON TABLE public.companies TO authenticated;
GRANT REFERENCES ON TABLE public.companies TO service_role;
GRANT REFERENCES ON TABLE public.company_members TO anon;
GRANT REFERENCES ON TABLE public.company_members TO authenticated;
GRANT REFERENCES ON TABLE public.company_members TO service_role;
GRANT REFERENCES ON TABLE public.company_subscriptions TO anon;
GRANT REFERENCES ON TABLE public.company_subscriptions TO authenticated;
GRANT REFERENCES ON TABLE public.company_subscriptions TO service_role;
GRANT REFERENCES ON TABLE public.interview_confirmations TO anon;
GRANT REFERENCES ON TABLE public.interview_confirmations TO authenticated;
GRANT REFERENCES ON TABLE public.interview_confirmations TO service_role;
GRANT REFERENCES ON TABLE public.interview_invitations TO anon;
GRANT REFERENCES ON TABLE public.interview_invitations TO authenticated;
GRANT REFERENCES ON TABLE public.interview_invitations TO service_role;
GRANT REFERENCES ON TABLE public.jobs TO anon;
GRANT REFERENCES ON TABLE public.jobs TO authenticated;
GRANT REFERENCES ON TABLE public.jobs TO service_role;
GRANT REFERENCES ON TABLE public.notifications TO anon;
GRANT REFERENCES ON TABLE public.notifications TO authenticated;
GRANT REFERENCES ON TABLE public.notifications TO service_role;
GRANT REFERENCES ON TABLE public.occurrences TO anon;
GRANT REFERENCES ON TABLE public.occurrences TO authenticated;
GRANT REFERENCES ON TABLE public.occurrences TO service_role;
GRANT REFERENCES ON TABLE public.plans TO anon;
GRANT REFERENCES ON TABLE public.plans TO authenticated;
GRANT REFERENCES ON TABLE public.plans TO service_role;
GRANT REFERENCES ON TABLE public.profiles TO anon;
GRANT REFERENCES ON TABLE public.profiles TO authenticated;
GRANT REFERENCES ON TABLE public.profiles TO service_role;
GRANT REFERENCES ON TABLE public.reputation_events TO anon;
GRANT REFERENCES ON TABLE public.reputation_events TO authenticated;
GRANT REFERENCES ON TABLE public.reputation_events TO service_role;
GRANT REFERENCES ON TABLE public.saved_jobs TO anon;
GRANT REFERENCES ON TABLE public.saved_jobs TO authenticated;
GRANT REFERENCES ON TABLE public.saved_jobs TO service_role;
GRANT SELECT ON TABLE public.appeals TO anon;
GRANT SELECT ON TABLE public.appeals TO authenticated;
GRANT SELECT ON TABLE public.appeals TO service_role;
GRANT SELECT ON TABLE public.application_notes TO anon;
GRANT SELECT ON TABLE public.application_notes TO authenticated;
GRANT SELECT ON TABLE public.application_notes TO service_role;
GRANT SELECT ON TABLE public.applications TO anon;
GRANT SELECT ON TABLE public.applications TO authenticated;
GRANT SELECT ON TABLE public.applications TO service_role;
GRANT SELECT ON TABLE public.attendance_records TO anon;
GRANT SELECT ON TABLE public.attendance_records TO authenticated;
GRANT SELECT ON TABLE public.attendance_records TO service_role;
GRANT SELECT ON TABLE public.audit_logs TO anon;
GRANT SELECT ON TABLE public.audit_logs TO authenticated;
GRANT SELECT ON TABLE public.audit_logs TO service_role;
GRANT SELECT ON TABLE public.candidate_private_data TO anon;
GRANT SELECT ON TABLE public.candidate_private_data TO authenticated;
GRANT SELECT ON TABLE public.candidate_private_data TO service_role;
GRANT SELECT ON TABLE public.companies TO anon;
GRANT SELECT ON TABLE public.companies TO authenticated;
GRANT SELECT ON TABLE public.companies TO service_role;
GRANT SELECT ON TABLE public.company_members TO anon;
GRANT SELECT ON TABLE public.company_members TO authenticated;
GRANT SELECT ON TABLE public.company_members TO service_role;
GRANT SELECT ON TABLE public.company_subscriptions TO anon;
GRANT SELECT ON TABLE public.company_subscriptions TO authenticated;
GRANT SELECT ON TABLE public.company_subscriptions TO service_role;
GRANT SELECT ON TABLE public.interview_confirmations TO anon;
GRANT SELECT ON TABLE public.interview_confirmations TO authenticated;
GRANT SELECT ON TABLE public.interview_confirmations TO service_role;
GRANT SELECT ON TABLE public.interview_invitations TO anon;
GRANT SELECT ON TABLE public.interview_invitations TO authenticated;
GRANT SELECT ON TABLE public.interview_invitations TO service_role;
GRANT SELECT ON TABLE public.jobs TO anon;
GRANT SELECT ON TABLE public.jobs TO authenticated;
GRANT SELECT ON TABLE public.jobs TO service_role;
GRANT SELECT ON TABLE public.notifications TO anon;
GRANT SELECT ON TABLE public.notifications TO authenticated;
GRANT SELECT ON TABLE public.notifications TO service_role;
GRANT SELECT ON TABLE public.occurrences TO anon;
GRANT SELECT ON TABLE public.occurrences TO authenticated;
GRANT SELECT ON TABLE public.occurrences TO service_role;
GRANT SELECT ON TABLE public.plans TO anon;
GRANT SELECT ON TABLE public.plans TO authenticated;
GRANT SELECT ON TABLE public.plans TO service_role;
GRANT SELECT ON TABLE public.profiles TO anon;
GRANT SELECT ON TABLE public.profiles TO authenticated;
GRANT SELECT ON TABLE public.profiles TO service_role;
GRANT SELECT ON TABLE public.reputation_events TO anon;
GRANT SELECT ON TABLE public.reputation_events TO authenticated;
GRANT SELECT ON TABLE public.reputation_events TO service_role;
GRANT SELECT ON TABLE public.saved_jobs TO anon;
GRANT SELECT ON TABLE public.saved_jobs TO authenticated;
GRANT SELECT ON TABLE public.saved_jobs TO service_role;
GRANT TRIGGER ON TABLE public.appeals TO anon;
GRANT TRIGGER ON TABLE public.appeals TO authenticated;
GRANT TRIGGER ON TABLE public.appeals TO service_role;
GRANT TRIGGER ON TABLE public.application_notes TO anon;
GRANT TRIGGER ON TABLE public.application_notes TO authenticated;
GRANT TRIGGER ON TABLE public.application_notes TO service_role;
GRANT TRIGGER ON TABLE public.applications TO anon;
GRANT TRIGGER ON TABLE public.applications TO authenticated;
GRANT TRIGGER ON TABLE public.applications TO service_role;
GRANT TRIGGER ON TABLE public.attendance_records TO anon;
GRANT TRIGGER ON TABLE public.attendance_records TO authenticated;
GRANT TRIGGER ON TABLE public.attendance_records TO service_role;
GRANT TRIGGER ON TABLE public.audit_logs TO anon;
GRANT TRIGGER ON TABLE public.audit_logs TO authenticated;
GRANT TRIGGER ON TABLE public.audit_logs TO service_role;
GRANT TRIGGER ON TABLE public.candidate_private_data TO anon;
GRANT TRIGGER ON TABLE public.candidate_private_data TO authenticated;
GRANT TRIGGER ON TABLE public.candidate_private_data TO service_role;
GRANT TRIGGER ON TABLE public.companies TO anon;
GRANT TRIGGER ON TABLE public.companies TO authenticated;
GRANT TRIGGER ON TABLE public.companies TO service_role;
GRANT TRIGGER ON TABLE public.company_members TO anon;
GRANT TRIGGER ON TABLE public.company_members TO authenticated;
GRANT TRIGGER ON TABLE public.company_members TO service_role;
GRANT TRIGGER ON TABLE public.company_subscriptions TO anon;
GRANT TRIGGER ON TABLE public.company_subscriptions TO authenticated;
GRANT TRIGGER ON TABLE public.company_subscriptions TO service_role;
GRANT TRIGGER ON TABLE public.interview_confirmations TO anon;
GRANT TRIGGER ON TABLE public.interview_confirmations TO authenticated;
GRANT TRIGGER ON TABLE public.interview_confirmations TO service_role;
GRANT TRIGGER ON TABLE public.interview_invitations TO anon;
GRANT TRIGGER ON TABLE public.interview_invitations TO authenticated;
GRANT TRIGGER ON TABLE public.interview_invitations TO service_role;
GRANT TRIGGER ON TABLE public.jobs TO anon;
GRANT TRIGGER ON TABLE public.jobs TO authenticated;
GRANT TRIGGER ON TABLE public.jobs TO service_role;
GRANT TRIGGER ON TABLE public.notifications TO anon;
GRANT TRIGGER ON TABLE public.notifications TO authenticated;
GRANT TRIGGER ON TABLE public.notifications TO service_role;
GRANT TRIGGER ON TABLE public.occurrences TO anon;
GRANT TRIGGER ON TABLE public.occurrences TO authenticated;
GRANT TRIGGER ON TABLE public.occurrences TO service_role;
GRANT TRIGGER ON TABLE public.plans TO anon;
GRANT TRIGGER ON TABLE public.plans TO authenticated;
GRANT TRIGGER ON TABLE public.plans TO service_role;
GRANT TRIGGER ON TABLE public.profiles TO anon;
GRANT TRIGGER ON TABLE public.profiles TO authenticated;
GRANT TRIGGER ON TABLE public.profiles TO service_role;
GRANT TRIGGER ON TABLE public.reputation_events TO anon;
GRANT TRIGGER ON TABLE public.reputation_events TO authenticated;
GRANT TRIGGER ON TABLE public.reputation_events TO service_role;
GRANT TRIGGER ON TABLE public.saved_jobs TO anon;
GRANT TRIGGER ON TABLE public.saved_jobs TO authenticated;
GRANT TRIGGER ON TABLE public.saved_jobs TO service_role;
GRANT TRUNCATE ON TABLE public.appeals TO anon;
GRANT TRUNCATE ON TABLE public.appeals TO authenticated;
GRANT TRUNCATE ON TABLE public.appeals TO service_role;
GRANT TRUNCATE ON TABLE public.application_notes TO anon;
GRANT TRUNCATE ON TABLE public.application_notes TO authenticated;
GRANT TRUNCATE ON TABLE public.application_notes TO service_role;
GRANT TRUNCATE ON TABLE public.applications TO anon;
GRANT TRUNCATE ON TABLE public.applications TO authenticated;
GRANT TRUNCATE ON TABLE public.applications TO service_role;
GRANT TRUNCATE ON TABLE public.attendance_records TO anon;
GRANT TRUNCATE ON TABLE public.attendance_records TO authenticated;
GRANT TRUNCATE ON TABLE public.attendance_records TO service_role;
GRANT TRUNCATE ON TABLE public.audit_logs TO anon;
GRANT TRUNCATE ON TABLE public.audit_logs TO authenticated;
GRANT TRUNCATE ON TABLE public.audit_logs TO service_role;
GRANT TRUNCATE ON TABLE public.candidate_private_data TO anon;
GRANT TRUNCATE ON TABLE public.candidate_private_data TO authenticated;
GRANT TRUNCATE ON TABLE public.candidate_private_data TO service_role;
GRANT TRUNCATE ON TABLE public.companies TO anon;
GRANT TRUNCATE ON TABLE public.companies TO authenticated;
GRANT TRUNCATE ON TABLE public.companies TO service_role;
GRANT TRUNCATE ON TABLE public.company_members TO anon;
GRANT TRUNCATE ON TABLE public.company_members TO authenticated;
GRANT TRUNCATE ON TABLE public.company_members TO service_role;
GRANT TRUNCATE ON TABLE public.company_subscriptions TO anon;
GRANT TRUNCATE ON TABLE public.company_subscriptions TO authenticated;
GRANT TRUNCATE ON TABLE public.company_subscriptions TO service_role;
GRANT TRUNCATE ON TABLE public.interview_confirmations TO anon;
GRANT TRUNCATE ON TABLE public.interview_confirmations TO authenticated;
GRANT TRUNCATE ON TABLE public.interview_confirmations TO service_role;
GRANT TRUNCATE ON TABLE public.interview_invitations TO anon;
GRANT TRUNCATE ON TABLE public.interview_invitations TO authenticated;
GRANT TRUNCATE ON TABLE public.interview_invitations TO service_role;
GRANT TRUNCATE ON TABLE public.jobs TO anon;
GRANT TRUNCATE ON TABLE public.jobs TO authenticated;
GRANT TRUNCATE ON TABLE public.jobs TO service_role;
GRANT TRUNCATE ON TABLE public.notifications TO anon;
GRANT TRUNCATE ON TABLE public.notifications TO authenticated;
GRANT TRUNCATE ON TABLE public.notifications TO service_role;
GRANT TRUNCATE ON TABLE public.occurrences TO anon;
GRANT TRUNCATE ON TABLE public.occurrences TO authenticated;
GRANT TRUNCATE ON TABLE public.occurrences TO service_role;
GRANT TRUNCATE ON TABLE public.plans TO anon;
GRANT TRUNCATE ON TABLE public.plans TO authenticated;
GRANT TRUNCATE ON TABLE public.plans TO service_role;
GRANT TRUNCATE ON TABLE public.profiles TO anon;
GRANT TRUNCATE ON TABLE public.profiles TO authenticated;
GRANT TRUNCATE ON TABLE public.profiles TO service_role;
GRANT TRUNCATE ON TABLE public.reputation_events TO anon;
GRANT TRUNCATE ON TABLE public.reputation_events TO authenticated;
GRANT TRUNCATE ON TABLE public.reputation_events TO service_role;
GRANT TRUNCATE ON TABLE public.saved_jobs TO anon;
GRANT TRUNCATE ON TABLE public.saved_jobs TO authenticated;
GRANT TRUNCATE ON TABLE public.saved_jobs TO service_role;
GRANT UPDATE ON TABLE public.appeals TO anon;
GRANT UPDATE ON TABLE public.appeals TO authenticated;
GRANT UPDATE ON TABLE public.appeals TO service_role;
GRANT UPDATE ON TABLE public.application_notes TO anon;
GRANT UPDATE ON TABLE public.application_notes TO authenticated;
GRANT UPDATE ON TABLE public.application_notes TO service_role;
GRANT UPDATE ON TABLE public.applications TO anon;
GRANT UPDATE ON TABLE public.applications TO authenticated;
GRANT UPDATE ON TABLE public.applications TO service_role;
GRANT UPDATE ON TABLE public.attendance_records TO anon;
GRANT UPDATE ON TABLE public.attendance_records TO authenticated;
GRANT UPDATE ON TABLE public.attendance_records TO service_role;
GRANT UPDATE ON TABLE public.audit_logs TO anon;
GRANT UPDATE ON TABLE public.audit_logs TO authenticated;
GRANT UPDATE ON TABLE public.audit_logs TO service_role;
GRANT UPDATE ON TABLE public.candidate_private_data TO anon;
GRANT UPDATE ON TABLE public.candidate_private_data TO authenticated;
GRANT UPDATE ON TABLE public.candidate_private_data TO service_role;
GRANT UPDATE ON TABLE public.companies TO anon;
GRANT UPDATE ON TABLE public.companies TO authenticated;
GRANT UPDATE ON TABLE public.companies TO service_role;
GRANT UPDATE ON TABLE public.company_members TO anon;
GRANT UPDATE ON TABLE public.company_members TO authenticated;
GRANT UPDATE ON TABLE public.company_members TO service_role;
GRANT UPDATE ON TABLE public.company_subscriptions TO anon;
GRANT UPDATE ON TABLE public.company_subscriptions TO authenticated;
GRANT UPDATE ON TABLE public.company_subscriptions TO service_role;
GRANT UPDATE ON TABLE public.interview_confirmations TO anon;
GRANT UPDATE ON TABLE public.interview_confirmations TO authenticated;
GRANT UPDATE ON TABLE public.interview_confirmations TO service_role;
GRANT UPDATE ON TABLE public.interview_invitations TO anon;
GRANT UPDATE ON TABLE public.interview_invitations TO authenticated;
GRANT UPDATE ON TABLE public.interview_invitations TO service_role;
GRANT UPDATE ON TABLE public.jobs TO anon;
GRANT UPDATE ON TABLE public.jobs TO authenticated;
GRANT UPDATE ON TABLE public.jobs TO service_role;
GRANT UPDATE ON TABLE public.notifications TO anon;
GRANT UPDATE ON TABLE public.notifications TO authenticated;
GRANT UPDATE ON TABLE public.notifications TO service_role;
GRANT UPDATE ON TABLE public.occurrences TO anon;
GRANT UPDATE ON TABLE public.occurrences TO authenticated;
GRANT UPDATE ON TABLE public.occurrences TO service_role;
GRANT UPDATE ON TABLE public.plans TO anon;
GRANT UPDATE ON TABLE public.plans TO authenticated;
GRANT UPDATE ON TABLE public.plans TO service_role;
GRANT UPDATE ON TABLE public.profiles TO anon;
GRANT UPDATE ON TABLE public.profiles TO authenticated;
GRANT UPDATE ON TABLE public.profiles TO service_role;
GRANT UPDATE ON TABLE public.reputation_events TO anon;
GRANT UPDATE ON TABLE public.reputation_events TO authenticated;
GRANT UPDATE ON TABLE public.reputation_events TO service_role;
GRANT UPDATE ON TABLE public.saved_jobs TO anon;
GRANT UPDATE ON TABLE public.saved_jobs TO authenticated;
GRANT UPDATE ON TABLE public.saved_jobs TO service_role;

-- Reference plan records
INSERT INTO public.plans (id,name,description,monthly_price,job_limit,active) VALUES ('essencial','Essencial','Para pequenas empresas em crescimento','0.00','5','t') ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name,description=EXCLUDED.description,monthly_price=EXCLUDED.monthly_price,job_limit=EXCLUDED.job_limit,active=EXCLUDED.active;
INSERT INTO public.plans (id,name,description,monthly_price,job_limit,active) VALUES ('free','Gratuito','Para começar a contratar','0.00','1','t') ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name,description=EXCLUDED.description,monthly_price=EXCLUDED.monthly_price,job_limit=EXCLUDED.job_limit,active=EXCLUDED.active;
INSERT INTO public.plans (id,name,description,monthly_price,job_limit,active) VALUES ('premium','Premium','Para operações de recrutamento intensivo','0.00',NULL,'t') ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name,description=EXCLUDED.description,monthly_price=EXCLUDED.monthly_price,job_limit=EXCLUDED.job_limit,active=EXCLUDED.active;
INSERT INTO public.plans (id,name,description,monthly_price,job_limit,active) VALUES ('profissional','Profissional','Para equipes com contratações recorrentes','0.00','20','t') ON CONFLICT (id) DO UPDATE SET name=EXCLUDED.name,description=EXCLUDED.description,monthly_price=EXCLUDED.monthly_price,job_limit=EXCLUDED.job_limit,active=EXCLUDED.active;
