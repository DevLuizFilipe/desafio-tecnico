# API de Comentários – Versão 2  
## 14 de Novembro de 2025 – Luiz Filipe Santana Martins

Este documento descreve as tecnologias utilizadas, a arquitetura implementada, as customizações realizadas no projeto e os novos recursos adicionados na versão **v2**.  
Na pasta **/imagens** do projeto encontram-se evidências como testes, diagrama de arquitetura e redes, testes de API, frontend e environment no GitHub.

---

## Tecnologias Utilizadas

- **Python**: Utilizado para desenvolver a API recebida.
- **Docker**: Utilizado para containerizar a aplicação e garantir portabilidade.
- **Terraform**: Utilizado para provisionar a infraestrutura de forma declarativa e automatizada.
- **AWS**: Provedor de nuvem utilizado.
- **ECS (Amazon Elastic Container Service)**: Responsável por orquestrar os contêineres da aplicação.
- **Fargate**: Plataforma serverless para execução dos contêineres.
- **EventBridge** *(v2)*: Utilizado para agendamento de rotinas automáticas.
- **AWS Lambda** *(v2)*: Função responsável por geração automática de arquivos no S3.
- **GitHub Actions**: Automação de CI/CD.
- **KICS (Keeping Infrastructure as Code Secure)**: Análise de segurança do código Terraform.

---

## Descrição da Infraestrutura

A infraestrutura foi projetada visando alta disponibilidade, escalabilidade, automação e segurança.

### Componentes Principais

- **VPC (Virtual Private Cloud)**  
  Isola toda a infraestrutura em uma rede privada, permitindo controle detalhado de segurança e conectividade.

- **Subnets Públicas e Privadas**  
  - *Públicas*: Utilizadas para o Load Balancer.  
  - *Privadas*: Utilizadas para ECS Fargate e demais recursos internos.

- **ECS Cluster**  
  Gerencia e executa os contêineres da aplicação de maneira escalável e altamente disponível.

- **Load Balancer**  
  Distribui o tráfego entre tasks ECS garantindo resiliência e atualizações sem downtime.

- **Bucket S3**  
  Armazena o **frontend estático** e, a partir da v2, também recebe **arquivos gerados automaticamente pelo Lambda**.

- **Repositório ECR**  
  Armazena imagens Docker da aplicação com versionamento e segurança.

---

## Novidades da Versão 2 (v2)

A v2 introduz um novo componente serverless responsável por executar uma rotina automática diária.

### 🆕 **Rotina Automática com AWS Lambda + EventBridge**

Foi adicionada uma função **AWS Lambda** que é executada diariamente às **10:00 AM (UTC)** através de uma regra agendada do **EventBridge**.

A função:

- Gera um arquivo contendo informações da data/hora exata da execução.
- Salva o arquivo no **mesmo bucket S3** utilizado pelo frontend estático.
- Utiliza nomeação baseada em timestamp para permitir auditoria e rastreabilidade.

Esse recurso amplia a automação do sistema e demonstra uso de arquitetura orientada a eventos (event-driven).

---

## Customizações no Projeto

- **Biblioteca de Logging**  
  Implementada na API Python para coletar métricas como status code, requisições HTTP, tempo de resposta, erros e demais indicadores importantes.

- **Rota Raiz ("/")**  
  Criada para servir como health check utilizado pelo ECS.

- **Lambda Automatizado (v2)**  
  Criado para executar uma rotina diária via EventBridge e armazenar resultados automaticamente no S3.

---

## Diagramas de Arquitetura

O projeto contém:

- **Diagrama Arquitetural da v1**  
  Representando ECS, ECR, VPC, Subnets, ALB e S3 para frontend.

- **Diagrama Arquitetural da v2**  
  Inclui os novos componentes:
  - EventBridge Rule
  - Lambda Function
  - Persistência automática de arquivos no S3  
  - Integração com o bucket já existente no ambiente

Esses diagramas estão disponíveis na pasta **/imagens**.

---

## Pipeline de CI/CD

A pipeline de CI/CD automatiza:

- **Deploy do Terraform**  
  Criação e atualização da infraestrutura.

- **Análise de Segurança com KICS**  
  Validação do código IaC para evitar vulnerabilidades.

- **Build e Push da Imagem Docker**  
  Nova imagem enviada para o repositório ECR.

- **Atualização do ECS Service**  
  Publicação contínua da aplicação sem interrupções.

---

## Métricas da Aplicação

As métricas e logs da aplicação estão disponíveis via **ECS → Serviço → Aba “Logs”**, onde é possível acompanhar o comportamento da API em tempo real.

A Lambda da v2 também possui logs disponíveis no **CloudWatch Logs**.

---

## Conclusão

A migração para a v2 adiciona automação serverless à arquitetura, tornando o sistema mais robusto, auditável e preparado para cenários de maior complexidade.  
A combinação entre ECS, Lambda, S3 e EventBridge cria um ambiente altamente escalável, seguro e com excelente custo-benefício.

---

## Cenário Futuro

Para versões posteriores, as seguintes melhorias poderão ser implementadas:

- Correção aprofundada de vulnerabilidades reportadas pelo ECR e KICS.
- Ampliação da arquitetura para redundância multi-AZ e multi-região.
- Implementação de monitoramento avançado com CloudWatch Dashboards e métricas customizadas.
- Expansão do uso de serviços serverless conforme necessidade.
