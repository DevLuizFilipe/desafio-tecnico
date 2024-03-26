# Documentação do Projeto

Este documento descreve as tecnologias utilizadas, a arquitetura implementada e as customizações realizadas no projeto.

## Tecnologias Utilizadas

- **Python**: Utilizado para desenvolver a API recebida.
- **Docker**: Utilizado para containerizar a aplicação e garantir a portabilidade.
- **Terraform**: Utilizado para provisionar a infraestrutura de forma declarativa e automatizada.
- **AWS**: Utilizado como provedor de nuvem.
- **ECS (Amazon Elastic Container Service)**: Selecionado para orquestrar os contêineres da aplicação.
- **Fargate**: Utilizado para execução de contêineres sem gerenciar a infraestrutura subjacente.
- **GitHub Actions**: Utilizado para automação de CI/CD.
- **KICS (Keeping Infrastructure as Code Secure)**: Ferramenta open source utilizada para análise de segurança do código Terraform.

## Descrição da Infraestrutura

A infraestrutura foi projetada para garantir alta disponibilidade, escalabilidade e segurança da aplicação. Detalhes da infraestrutura incluem:

- **VPC (Virtual Private Cloud)**: Isola a infraestrutura da aplicação, proporcionando uma rede privada na nuvem da AWS. Isso permite um controle preciso sobre a segurança e a conectividade dos recursos.
- **Subnets Públicas e Privadas**: As subnets públicas são utilizadas para recursos que precisam de acesso à internet, como o Load Balancer, enquanto as subnets privadas são utilizadas para recursos que não precisam de acesso direto à internet, garantindo uma camada adicional de segurança.
- **ECS Cluster**: Gerencia os contêineres da aplicação de forma eficiente, escalável e altamente disponível. Ele ajusta dinamicamente a capacidade com base nas demandas de tráfego, garantindo um desempenho consistente.
- **Load Balancer**: Distribui o tráfego entre os contêineres da aplicação, melhorando o desempenho e a disponibilidade, além de permitir atualizações e manutenções sem interrupções no serviço.
- **Bucket S3**: Armazena o frontend estático da aplicação de forma durável e escalável, com redundância e alta disponibilidade integradas.
- **Repositório ECR**: Armazena as imagens Docker da aplicação com segurança, permitindo um controle preciso sobre as versões e facilitando a implantação automatizada.

## Customizações no Projeto Base

- **Biblioteca de Logging**: Implementada na API Python para coletar métricas da aplicação e monitorar seu desempenho, permitindo uma análise detalhada do comportamento da aplicação em produção.
- **Rota Raiz ("/")**: Adicionada para permitir o health check do ECS, garantindo a disponibilidade da aplicação e facilitando o monitoramento contínuo.

## Diagramas de Arquitetura

Foi criado um diagrama representando a arquitetura atual do projeto, destacando os principais componentes e a interação entre eles. Além disso, foi desenvolvido um outro diagrama que ilustra uma possível arquitetura alternativa, considerando cenários em que houvesse mais tempo de execução para explorar outras opções e otimizações.

## Pipeline de CI/CD

A pipeline de CI/CD automatiza o processo de construção, teste e implantação da aplicação. Ela inclui:

- **Deploy do Terraform**: Provisiona a infraestrutura de forma consistente e segura, permitindo a implantação rápida e confiável dos recursos necessários.
- **Análise de Segurança com KICS**: Identifica e corrige potenciais vulnerabilidades na infraestrutura, garantindo um ambiente seguro e protegido contra ameaças.
- **Construção e Envio da Imagem Docker**: Compila a aplicação e a disponibiliza no repositório ECR, permitindo uma implantação eficiente e automatizada.
- **Atualização do Serviço ECS**: Atualiza automaticamente o serviço ECS com a nova versão da aplicação, garantindo a implantação contínua e sem interrupções.

## Conclusão

A escolha das tecnologias e arquitetura foi guiada pela busca de eficiência, escalabilidade e segurança, visando garantir uma operação suave e confiável da aplicação na nuvem. A integração de ferramentas open source e práticas de DevOps permite uma abordagem ágil e iterativa no desenvolvimento e implantação do software. A infraestrutura e os processos de CI/CD foram cuidadosamente projetados para garantir um ambiente de produção robusto e altamente disponível, capaz de atender às demandas crescentes dos usuários e responder rapidamente às mudanças no mercado.

## Cenário Futuro

Em um cenário de maior tempo para execução do projetos, tais medidas seriam consideradas:

- **Correção de Vulnerabilidades no ECR e no KICS**: Seriam corrigidas as vulnerabilidades apontadas no repositório ECR e pelo KICS, garantindo uma infraestrutura e aplicação mais segura e resiliente.
- **Aprimoramento da Arquitetura**: Seria implementada uma arquitetura mais robusta e escalável, considerando a adição de redundância, segurança avançada, e demais serviços.

