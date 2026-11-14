# Master Vagas

Plataforma de vagas e recrutamento, com áreas para candidatos e empresas.

## Estrutura

- `index.html`: aplicação web publicada, incluindo estilos e lógica do frontend.
- `vercel.json`: URLs limpas e cabeçalhos básicos de segurança.

## Desenvolvimento local

Como a versão atual é uma aplicação estática em um único arquivo, basta abrir `index.html` no navegador ou servir a pasta com um servidor HTTP local.

## Publicação

O projeto pode ser publicado na Vercel a partir da raiz deste repositório. A branch principal é `main`.

## Supabase

O frontend utiliza a URL do projeto Supabase e uma chave publicável (anon/publishable), que pode ser usada no navegador com políticas RLS corretamente configuradas.

**Nunca coloque neste repositório** chaves `service_role`, tokens administrativos, senhas ou segredos de integração.

O banco Supabase do projeto já foi provisionado separadamente. Este repositório contém o código frontend recuperado da implantação publicada; não contém ainda um dump/migration SQL completo e reproduzível do banco. Antes de recriar o ambiente em outro projeto Supabase, exporte e revise o schema, políticas RLS, funções e gatilhos do projeto original.

## Estado e limitações

Esta migração preserva o código HTML servido pela implantação de preview da Vercel e a configuração de cabeçalhos disponível nela. A publicação no GitHub não significa que todos os fluxos da aplicação ou integrações tenham sido homologados em produção. Faça testes de cadastro, login, recuperação de senha, candidatura, consentimento de CPF e gestão de vagas após cada implantação.
