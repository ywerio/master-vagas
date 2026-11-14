# Supabase migration history

Project reference: `dqfxqczrmrwztwjvcuci`

The connected Supabase project reports these applied migrations:

| Version | Name |
|---|---|
| 20261111184747 | initial_recruitment_platform_schema |
| 20261111184816 | recruiter_applicant_access |
| 20261111185128 | tighten_security_and_index_relations |
| 20261111185201 | protect_recruitment_relationships |
| 20261114021728 | master_vagas_recruitment_foundation |
| 20261114021753 | master_vagas_security_hardening |

The original SQL migration files were not present in the GitHub repository. The current database definition was exported into `schema_snapshot.sql` as a recovery reference. It is **not** a replayable migration chain and must not be applied to the existing project. For a new Supabase project, review the snapshot and split it into ordered migrations after validating all RLS policies, functions, triggers, and privileges.

No Edge Functions were found in the connected project at export time. Supabase Auth provider settings, email templates, redirect URLs, secrets, and any external service credentials are managed in the Supabase dashboard and are not included in Git.
