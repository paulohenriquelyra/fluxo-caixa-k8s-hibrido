# Projeto de Infraestrutura TI

## Sistemas de Fluxo de Caixa Empresa XPTO – FLCX (Ver 1.0)

**Autor:** Paulo Lyra ([Paulo.lyra@gmail.com](mailto:Paulo.lyra@gmail.com))
**Documento**  Projeto_Desafio_VERX_XPTO completo em PDF no diretório raiz  


---

## Índice - completo com detalhes no PDF (70 páginas) 

- [1. Objetivo](#objetivo)
- [2. Objetivo do Sistema](#objetivo-do-sistema)
- [3. Premissas Assumidas](#premissas-assumidas)
- [4. Dimensionamento de Recursos](#dimensionamento-de-recursos)
- [5. Cálculo de Sizing](#calculo-de-sizing)
- [6. Data Center Local](#data-center-local)
- [7. Dimensionamento dos Worker Nodes](#dimensionamento-dos-worker-nodes)
- [8. Recursos Utilizados](#recursos-utilizados)
- [9. Racional Detalhado Kubernetes](#racional-detalhado-kubernetes)
- [10. Volumetria Consolidada](#volumetria-consolidada)
- [11. Capacidade dos Pods](#capacidade-dos-pods)
- [12. Cálculo do Número de Worker Nodes por Ambiente](#calculo-do-numero-de-worker-nodes-por-ambiente)
- [13. Ajuste Final](#ajuste-final)
- [14. Discos (Nodes e PVs)](#discos-nodes-e-pvs)
- [15. Banco de Dados](#banco-de-dados)
- [16. Conclusão](#conclusao)
- [17. Finops](#finops)
- [18. FinOps e Governança – Estratégias para Eficiência e Controle](#finops-e-governanca-–-estrategias-para-eficiencia-e-controle)
- [19. Tagueamento Correto de Recursos](#tagueamento-correto-de-recursos)
- [20. Planejamento do Uso com Escalabilidade e Sizing](#planejamento-do-uso-com-escalabilidade-e-sizing)
- [21. Uso Estratégico de Serverless](#uso-estrategico-de-serverless)
- [22. Kubernetes com Auto Scaling Planejado](#kubernetes-com-auto-scaling-planejado)
- [23. Relatórios Precisos e Alertas de Anomalias](#relatorios-precisos-e-alertas-de-anomalias)
- [24. Automação com Terraform, Ansible e Padrões](#automacao-com-terraform-ansible-e-padroes)
- [25. Impacto na Governança](#impacto-na-governanca)
- [26. Tabela Comparativa](#tabela-comparativa)
- [27. Resumo de Benefícios](#resumo-de-beneficios)
- [28. Conclusão](#conclusao-finops)
- [29. Diagrama de Topologia e Arquitetura](#diagrama-de-topologia-e-arquitetura)
- [30. DC On Premises XPTO](#dc-on-premises-xpto)
- [31. CLOUD CENÁRIO DC XPTO <-> AWS](#cloud-cenario-dc-xpto---aws)
- [32. CLOUD CENÁRIO DC XPTO <–> AZURE ARC](#cloud-cenario-dc-xpto---azure-arc)
- [33. Fluxo de Comunicação](#fluxo-de-comunicacao)
- [34. Justificativas](#justificativas)
- [35. Framework](#framework)
- [36. Kubernetes (com NGINX, Node.js, Redis)](#kubernetes-com-nginx-nodejs-redis)
- [37. Namespaces Segregados (proxy e app)](#namespaces-segregados-proxy-e-app)
- [38. Banco de Dados MS SQL Server](#banco-de-dados-ms-sql-server)
- [39. Prometheus e Grafana](#prometheus-e-grafana)
- [40. ELK (Elasticsearch, Logstash, Kibana)](#elk-elasticsearch-logstash-kibana)
- [41. Workload Híbrido (considerando 60% Datacenter Local, 40% Nuvem)](#workload-hibrido-considerando-60-datacenter-local-40-nuvem)
- [42. Cenário 1: Datacenter Local + Azure Arc com Azure SQL Managed Instance](#cenario-1-datacenter-local--azure-arc-com-azure-sql-managed-instance)
- [43. Cenário 2: Datacenter Local + AWS com EKS e MS SQL em EC2](#cenario-2-datacenter-local--aws-com-eks-e-ms-sql-em-ec2)
- [44. Tabela Comparativa](#tabela-comparativa-justificativas)
- [45. Quando Escolher Cada Cenário?](#quando-escolher-cada-cenario)
- [86. GitHub e GitHub Actions](#github-e-github-actions)
- [87. Integração com GitHub e GitHub Actions](#integracao-com-github-e-github-actions)
- [88. Explicação do Workflow](#explicacao-do-workflow)
- [89. Benefícios da Integração](#beneficios-da-integracao)
- [90. Estrutura do Repositório no GitHub](#estrutura-do-repositorio-no-github)
- [91. Conclusão](#conclusao-github)
- [92. Conclusão do Projeto de Desafio](#conclusao-do-projeto-de-desafio)
- [93. Alta Disponibilidade e Escalabilidade](#alta-disponibilidade-e-escalabilidade)
- [94. Segurança e Controle de Acesso Aprimorados](#seguranca-e-controle-de-acesso-aprimorados)
- [95. Otimização dos Custos](#otimizacao-dos-custos)
- [96. Resiliência e Recuperação (DR)](#resiliencia-e-recuperacao-dr)
- [97. Automação e Governança](#automacao-e-governanca)
- [98. Resumo Final](#resumo-final)
- [99. Anexos](#anexos)
- [100. Referências de Ferramentas e Tecnologias Utilizadas](#referencias-de-ferramentas-e-tecnologias-utilizadas)
- [101. Sobre Paulo Lyra](#sobre-paulo-lyra)

---

## Objetivo

O objetivo deste projeto é propor uma nova arquitetura híbrida para o sistema de fluxo de caixa da empresa XPTO, integrando recursos on-premises e na nuvem, atendendo aos seguintes requisitos:

- Alta disponibilidade e escalabilidade da solução.
- Segurança e controle de acesso aprimorados.
- Otimização dos custos.
- Resiliência e recuperação (DR).
- Automação e governança.

---

## Objetivo do Sistema

Desenvolver uma solução moderna, modular, e escalável para o sistema de fluxo de caixa, possibilitando:

- Alta escalabilidade.
- Robustez e granularidade.
- Portabilidade.
- Depuração eficiente e menor tempo de troubleshooting.
- Operação simplificada e eficiente.
- Distribuição híbrida de workload entre on-premises e nuvem.

---

## Premissas Assumidas

- Solução baseada em contêineres com Kubernetes, utilizando NGINX, Node.js, Redis, e SQL Server.
- Arquitetura híbrida com:
  - Workload normal: 60% DC Local + 40% Cloud (6 nodes DC + 4 nodes Cloud).
  - Workload DR (100% Cloud, Normal): 2 nodes base + 7 nodes autoscaling.
  - Workload DR (100% Cloud, Campanha): 2 nodes base + 12 nodes autoscaling.
- Conectividade via link dedicado DC-Cloud para maior segurança, baixa latência, e conformidade (LGPD, PCI-DSS).
- Infraestrutura on-premises com cluster de virtualização (Hyper-V ou VMware).
- Recursos existentes no DC: cluster ELK (3 VMs: 8 vCPUs, 32 GB RAM, 500 GB disco), Bastion Host (1 VM: 2 vCPUs, 8 GB RAM, 40 GB disco), e VM Helm (4 vCPUs, 8 GB RAM, 120 GB disco).
- Necessidade de um "landing zone" na nuvem com autenticação e autorização (SAML, OAuth2) e federação com o DC local.
- Volumetria estimada:
  - **Consumo Normal (Pico 14h-15h):** 550 RQS (500 Entradas/Saídas + 50 Consolidado), 200 TPS, 200 sessões simultâneas.
  - **Modo Campanha:** 1050 RQS (1000 Entradas/Saídas + 50 Consolidado), 400 TPS, 400 sessões simultâneas.

### Sizing do Banco de Dados

- Lançamento típico de fluxo de caixa: ~3 KB por lançamento (com margem de 1 KB adicional).
![Figura 1 – Tamanho Registo Banco de Dados](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-1.png)
- Crescimento anual de 20%.

| Ano  | Dados de Lançamentos (GB) | Índices (GB) | Overhead (GB) | Subtotal (GB) |
|------|---------------------------|--------------|---------------|---------------|
| Ano 1| 429,15                    | 214,58       | 64,37         | 708,1         |
| Ano 2| 514,98                    | 257,49       | 77,25         | 849,72        |
| Ano 3| 617,98                    | 308,99       | 92,7          | 1019,67       |
| Ano 4| 741,58                    | 370,79       | 111,24        | 1223,61       |
| Ano 5| 889,89                    | 444,95       | 133,48        | 1468,32       |
| Total|                           |              |               | 5289,42       |

---

## Dimensionamento de Recursos

### Cálculo de Sizing

- Capacidade Node.js ajustada para **20 TPS por pod** (devido ao overhead de HTTPS e mTLS).
- Dimensionamento para suportar:
  - **Consumo Normal:** 550 RQS, 200 TPS, 200 sessões.
  - **Modo Campanha:** 1050 RQS, 400 TPS, 400 sessões.
  - **Cenário DR:** 100% da carga em um ambiente, com ~75% de utilização (25% ocioso).

---

### Data Center Local

- **Cluster Kubernetes Control Plane (RKE-K8S):**
  - 3 nodes: 4 vCPUs, 8 GB RAM, 150 GB disco.
  - 1 PVC: 100 GB.

---

### Dimensionamento dos Worker Nodes

- **Cada Ambiente (On-Premises ou Cloud):**
  - Base: 5 worker nodes (4 vCPUs, 8 GB RAM cada).
  - Total por ambiente: 20 vCPUs, 40 GB RAM.
  - Autoscaling: Até 7 nodes (28 vCPUs, 56 GB).
- **Total (Ambos os Ambientes):**
  - 10 worker nodes (40 vCPUs, 80 GB RAM).
- **Cenário DR:**
  - 5 nodes (20 vCPUs, 40 GB), autoscaling para 7 nodes (28 vCPUs, 56 GB).

---

### Recursos Utilizados

- **Consumo Normal (550 RQS, 200 TPS):**
  - CPU: 8,82 vCPUs (~22% de 40 vCPUs).
  - Memória: 12,84 GB (~16% de 80 GB).
- **Modo Campanha (1050 RQS, 400 TPS):**
  - CPU: 14,02 vCPUs (~35,1% de 40 vCPUs).
  - Memória: 19,28 GB (~24,1% de 80 GB).
- **Cenário DR (100% em 1 Ambiente):**
  - CPU: 14,02 vCPUs (~70,1% de 20 vCPUs).
  - Memória: 19,28 GB (~48,2% de 40 GB).
- **Após Autoscaling (7 nodes):**
  - CPU ociosa: 25%.
  - Memória ociosa: 25%.

---

### Racional Detalhado Kubernetes

#### Volumetria Consolidada

- **Consumo Normal:**
  - RQS Total: 550 (500 Entradas/Saídas + 50 Consolidado).
  - TPS: 200.
  - Sessões Simultâneas: 200.
- **Modo Campanha:**
  - RQS Total: 1050 (1000 Entradas/Saídas + 50 Consolidado).
  - TPS: 400.
  - Sessões Simultâneas: 400.
- **Distribuição Normal:**
  - On-Premises (60%): 630 RQS, 240 TPS.
  - Cloud (40%): 420 RQS, 160 TPS.
- **Cenário DR:**
  - 100% da carga em um ambiente: 1050 RQS, 400 TPS, 400 sessões.

#### Capacidade dos Pods

- **NGINX:** 120 RPS por pod.
  - Normal: 5 pods.
  - Campanha: 9 pods.
- **Node.js:** 20 TPS (60 RQS) por pod.
  - Normal: 10 pods.
  - Campanha: 20 pods.
- **Redis:** 1 pod (256Mi–512Mi RAM).
- **Prometheus:** 1–2 pods (200m–400m CPU, 400Mi–800Mi RAM).
- **Grafana:** 1 pod (100m–200m CPU, 256Mi–512Mi RAM).
- **Fluentd (DaemonSet):** 10 pods (55m–110m CPU, 140Mi–280Mi RAM per pod).

![Figura 2 – racional consumo de pods](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-2.png)
![Figura 3 – racional consumo de pods DR ](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-3.png)


#### Cálculo do Número de Worker Nodes por Ambiente

- **Cenário DR (CPU):** 14,02 vCPUs → 5 nodes (20 vCPUs, 70,1% utilização).
- **Cenário DR (Memória):** 19,28 GB → 4 nodes (32 GB, 60,3% utilização).
- **Ajuste Final:** 5 nodes base, autoscaling para 7 nodes (28 vCPUs, 56 GB).

#### Ajuste Final

- Cada ambiente: 5 nodes (20 vCPUs, 40 GB), autoscaling para 7 nodes.
- **Após Autoscaling (7 nodes):**
  - CPU: 50,1% (~49,9% ocioso).
  - Memória: 34,4% (~65,6% ocioso).

---

### Discos (Nodes e PVs)

#### Persistent Volumes (PVs) com Retenção de 3 Anos

| Componente | Tamanho do PV (On-Premises) | Tamanho do PV (Cloud) | Descrição                                 |
|------------|-----------------------------|-----------------------|-------------------------------------------|
| Redis      | 1 GB                        | 1 GB                  | Cache de sessões (400 sessões, 1 KB cada) |
| Prometheus | 380 GB                      | 380 GB                | Métricas (1050 RQS, retenção de 3 anos)  |
| Grafana    | 2 GB                        | 2 GB                  | Dashboards e configurações (3 anos)       |
| Fluentd    | 5 GB                        | 5 GB                  | Buffer de logs (5 minutos, 1050 RQS)      |
| **Total**  | **388 GB**                  | **388 GB**            | Total por ambiente                        |

- **Total Geral de PVs:** 776 GB.

#### Espaço em Disco dos Worker Nodes

| Ambiente    | Número de Nodes (Base/Pico) | Espaço por Node | Total (Base) | Total (Pico - Cenário DR) | Descrição                                 |
|-------------|-----------------------------|-----------------|--------------|---------------------------|-------------------------------------------|
| On-Premises | 5 / 7                       | 50 GB           | 250 GB       | 350 GB                    | SO, Kubernetes, imagens, logs, espaço temp |
| Cloud       | 5 / 7                       | 50 GB           | 250 GB       | 350 GB                    | SO, Kubernetes, imagens, logs, espaço temp |
| Total Geral | 10 / 14                     | 50 GB           | 500 GB       | 700 GB                    | Total para ambos os ambientes             |

---

### Banco de Dados

#### Sizing do Banco de Dados

- Crescimento anual: 20%.
- Total em 5 anos: 5,3 TB (sujeito a políticas de descarregamento).

| Ano  | Dados de Lançamentos (GB) | Índices (GB) | Overhead (GB) | Subtotal (GB) |
|------|---------------------------|--------------|---------------|---------------|
| Ano 1| 429,15                    | 214,58       | 64,37         | 708,1         |
| Ano 2| 514,98                    | 257,49       | 77,25         | 849,72        |
| Ano 3| 617,98                    | 308,99       | 92,7          | 1019,67       |
| Ano 4| 741,58                    | 370,79       | 111,24        | 1223,61       |
| Ano 5| 889,89                    | 444,95       | 133,48        | 1468,32       |
| Total|                           |              |               | 5289,42       |

#### Banco de Dados SQL On-Premises (MS SQL Enterprise)

- 2 servidores físicos: 8 cores, 256 GB RAM, 8 TB SSD.
- Réplica síncrona com Always On ativo.

#### Opção Cloud: Azure SQL Managed Instances (Azure ARC)

- 16 vCPUs, 128 GB RAM, 1 TB disco (1º ano).
- Réplica assíncrona com Always On.

#### Opção Cloud: AWS MS SQL Enterprise em EC2

- Instância R6i.4xlarge: 16 vCPUs, 128 GB RAM, 1 TB EBS io2 (10,000 IOPS).
- Réplica assíncrona com Always On.

---

### Conclusão

Com a volumetria consolidada e a capacidade do Node.js ajustada para **20 TPS por pod** (devido ao overhead de HTTPS e mTLS), cada ambiente (on-premises e nuvem) é dimensionado com **5 worker nodes** (20 vCPUs, 40 GB de RAM, 50 GB de disco por node), totalizando 10 nodes (40 vCPUs, 80 GB de RAM, 500 GB de disco). Esse dimensionamento suporta a carga total do modo campanha (**1050 RQS, 400 TPS, 400 sessões simultâneas**) no cenário catastrófico (DR), onde um único ambiente assume 100% da carga. O **autoscaling** para 7 nodes por ambiente (28 vCPUs, 56 GB de RAM, 350 GB de disco) mantém ~25% de recursos ociosos, garantindo alta disponibilidade (HA) com no mínimo 2 nodes por ambiente e configurações de failover ajustadas (ex.: Global Load Balancer com DNS failover).

Os **Persistent Volumes (PVs)** foram dimensionados considerando a retenção de dados por 3 anos para Prometheus e Grafana: **380 GB** para Prometheus (métricas de 1050 RQS com downsampling) e **2 GB** para Grafana (dashboards e configurações), além de **1 GB** para Redis (cache de sessões) e **5 GB** para Fluentd (buffer de logs). Isso resulta em **388 GB de PVs por ambiente**, totalizando **776 GB** para ambos os ambientes. A volumetria do banco de dados foi estimada com base no *sizing* do banco para um horizonte de 1 a 5 anos, considerando a família de servidores disponíveis (ex.: SSDs de alta capacidade e IOPS para Prometheus), com estratégias de retenção em camadas (ex.: dados antigos em storage de longo prazo como S3) e backups regulares.

Todo o dimensionamento está alinhado às práticas de [Melhores práticas para dimensionar clusters Kubernetes](https://learnk8s.io/kubernetes-node-size), garantindo performance, escalabilidade e resiliência em cenários normais e catastróficos.

---

## Finops

### FinOps e Governança – Estratégias para Eficiência e Controle

A gestão eficiente da infraestrutura híbrida combina práticas de FinOps e governança para garantir eficiência financeira, agilidade operacional e segurança.

#### Tagueamento Correto de Recursos

- Tags: `ambiente=producao`, `projeto=fluxo-de-caixa`.
- Ferramentas: Azure Cost Management, AWS Cost Explorer.
- Impacto: Relatórios detalhados e transparência.

#### Planejamento do Uso com Escalabilidade e Sizing

- Kubernetes: Base de 2 nodes, escalando até 5 (HPA, Cluster Autoscaler).
- Estratégia: Reserved Instances para cargas fixas, Spot Instances para tarefas não críticas.
- Impacto: Custos otimizados e flexibilidade.

#### Uso Estratégico de Serverless

- Datacenter Local: Ansible, Jenkins.
- Azure: Azure Functions.
- AWS: AWS Lambda.
- Impacto: Execução sob demanda com custo reduzido.

#### Kubernetes com Auto Scaling Planejado

- HPA: CPU > 70%.
- Nodes pré-configurados para picos sazonais.
- Impacto: Alta disponibilidade com eficiência financeira.

#### Relatórios Precisos e Alertas de Anomalias

- Datacenter Local: Grafana, Prometheus (disco > 90%).
- Azure: Azure Monitor, Budgets.
- AWS: CloudWatch, Budgets.
- Impacto: Controle financeiro e mitigação de riscos.

#### Automação com Terraform, Ansible e Padrões

- Terraform: Infraestrutura como código.
- Ansible: Configuração e automação de segurança.
- Impacto: Redução de erros e conformidade.

#### Impacto na Governança

- Compliance: Logs e relatórios para auditorias.
- Segurança: Políticas de acesso (RBAC).
- Financeiro: Tagueamento e relatórios detalhados.

#### Tabela Comparativa

| Aspecto           | Datacenter Local         | Datacenter + Azure Arc + SQL MI | Datacenter + AWS + EC2  |
|-------------------|--------------------------|----------------------------------|-------------------------|
| Tagueamento       | vSphere tags (Terraform) | Azure tags (Terraform)           | AWS tags (Terraform)    |
| Escalabilidade    | Cluster Autoscaler, HPA  | AKS Autoscaler, HPA              | EKS Autoscaler, HPA     |
| Serverless        | Ansible/Jenkins          | Azure Functions                  | AWS Lambda              |
| Relatórios/Alertas| Grafana, Prometheus      | Azure Monitor, Budgets           | CloudWatch, Budgets     |
| Automação         | Terraform, Ansible       | Terraform, Ansible               | Terraform, Ansible      |
| Governança        | Políticas manuais        | Azure Policy                     | AWS Organizations       |

#### Resumo de Benefícios

- Custos otimizados via automação.
- Transparência com tagueamento e relatórios.
- Flexibilidade e escalabilidade dinâmica.
- Governança reforçada para auditorias e segurança.

#### Conclusão Finops

A aplicação de FinOps e governança resulta em uma solução eficiente, segura e econômica, com ferramentas como Terraform, Ansible, Grafana e estratégias de Reserved/Spot Instances.

---

## Diagrama de Topologia e Arquitetura

### DC On Premises XPTO

![Figura 4 - Topologia DC On-premises](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/diagrama-topologia-dc-on-premises.png) 


### CLOUD CENÁRIO DC XPTO <-> AWS

![Figura 5 - VPC AWS](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/vpc-aws.png)
![Figura 6 - Integracão DC AWS](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-aws.png)


### CLOUD CENÁRIO DC XPTO <–> AZURE ARC

![Figura 7 - Integracao DC Azure ARC 1a](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-azure-1a.png)

![Figura 8 - Integracao DC Azure ARC 1b](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-azure-1b.png)

### Fluxo de Comunicação

![Figura 9 - Macro Fluxo comunicação aplicação](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/macro-fluxo-aplicacao.png)



---

## Justificativas

### Framework

#### Kubernetes (com NGINX, Node.js, Redis)

- **Escalabilidade e Orquestração:** Kubernetes gerencia e escala microsserviços com HPA.
- **Portabilidade:** Funciona on-premises e na nuvem.
- **Alta Disponibilidade:** Réplicas e múltiplos nodes.

- **NGINX:** Proxy e balanceador de carga, validação de tokens JWT.
- **Node.js:** Desenvolvimento rápido de microsserviços RESTful.
- **Redis:** Cache em memória e filas assíncronas.

#### Namespaces Segregados (proxy e app)

- **Segurança:** Network Policies e RBAC por namespace.
- **Organização:** Escalonamento independente de NGINX e Node.js.

#### Banco de Dados MS SQL Server

- **Confiabilidade:** Always On com replicação assíncrona.
- **Performance:** Otimizado para consultas financeiras.

#### Prometheus e Grafana

- **Controle de Métricas:** Modelo pull-based.
- **Alertas:** Regras para anomalias.
- **Dashboards:** Visão em tempo real por namespace.

#### ELK (Elasticsearch, Logstash, Kibana)

- **Monitoramento:** Centralização de logs com visualização no Kibana.

#### Workload Híbrido (considerando 60% Datacenter Local, 40% Nuvem)

- **Custo e Controle:** 60% on-premises reduz custos.
- **Escalabilidade e Resiliência:** 40% na nuvem para picos e continuidade.

#### Cenário 1: Datacenter Local + Azure Arc com Azure SQL Managed Instance

- **Gerenciamento:** Azure Arc centraliza governança.
- **Azure SQL MI:** Réplica na nuvem com backups automáticos.
- **Segurança:** Integração com AAD (SSO).
- **Vantagens:** Simplicidade e alta disponibilidade.

#### Cenário 2: Datacenter Local + AWS com EKS e MS SQL em EC2

- **EKS:** Hospeda 40% da carga com auto scaling.
- **MS SQL em EC2:** Controle total sobre configurações.
- **Flexibilidade:** Ajustes finos no EKS.
- **Vantagens:** Ideal para equipes experientes.

#### Tabela Comparativa Justificativas

| Aspecto        | Cenário 1 (Azure Arc)       | Cenário 2 (AWS)         |
|----------------|-----------------------------|-------------------------|
| Gerenciamento  | Centralizado via Azure Arc  | Separado (EKS e EC2)    |
| Banco de Dados | SQL Managed Instance        | MS SQL em EC2 (manual)  |
| Segurança      | Políticas unificadas com AAD| Configurações manuais (IAM) |
| Complexidade   | Menor, mais automatizado    | Maior, mais configurável |

#### Quando Escolher Cada Cenário?

- **Cenário 1 (Azure Arc):** Integração simples com AAD, gerenciamento unificado.
- **Cenário 2 (AWS):** Flexibilidade e controle total, para equipes experientes.

---

## GitHub e GitHub Actions

### Integração com GitHub e GitHub Actions

O código será gerenciado em um repositório público no GitHub, com GitHub Actions automatizando o pipeline CI/CD.

#### Repositório no GitHub

```
fluxo-de-caixa/
├── src/                    # Código-fonte (Node.js)
│   └── Dockerfile          # Imagem Docker para a aplicação Node.js
├── k8s/                    # Configurações do Kubernetes
│   ├── deployment.yaml     # Manifest para deployment da aplicação
│   ├── service.yaml        # Manifest para o service
│   └── ingress.yaml        # Manifest para o ingress
├── helm/                   # Helm Chart para implantação no K8s
│   ├── Chart.yaml          # Definição do Helm Chart
│   ├── values.yaml         # Valores padrão para o chart
│   └── templates/          # Templates do Helm
├── tests/                  # Testes automatizados
├── .github/workflows/      # Workflows GitHub Actions
│   ├── ci-cd.yaml          # Pipeline CI/CD
│   └── security-scan.yaml  # Varredura de segurança
├── README.md               # Documentação
└── docs/                   # Documentação adicional

```

- **Branches:** `main` (produção), `develop` (desenvolvimento), `feature/*`.

#### Configuração do GitHub Actions

**Workflow: `.github/workflows/ci-cd.yaml`**

```yaml
name: CI/CD Pipeline para Fluxo de Caixa
on:
  push:
    branches:
      - main
      - develop
  pull_request:
    branches:
      - main
      - develop
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout do Código
        uses: actions/checkout@v3
      - name: Configurar Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      - name: Instalar Dependências
        run: npm install
        working-directory: ./src
      - name: Executar Testes Unitários
        run: npm test
        working-directory: ./src
  build-and-push:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - name: Checkout do Código
        uses: actions/checkout@v3
      - name: Configurar Docker Buildx
        uses: docker/setup-buildx-action@v2
      - name: Login no Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      - name: Construir e Publicar Imagem Docker
        uses: docker/build-push-action@v4
        with:
          context: ./src
          file: ./Dockerfile
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/fluxo-de-caixa:${{ github.sha }}
            ${{ secrets.DOCKER_USERNAME }}/fluxo-de-caixa:latest
  security-scan:
    runs-on: ubuntu-latest
    needs: build-and-push
    steps:
      - name: Checkout do Código
        uses: actions/checkout@v3
      - name: Executar Varredura com Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ secrets.DOCKER_USERNAME }}/fluxo-de-caixa:${{ github.sha }}
          severity: 'HIGH,CRITICAL'
          exit-code: '1'
  deploy:
    runs-on: ubuntu-latest
    needs: security-scan
    steps:
      - name: Checkout do Código
        uses: actions/checkout@v3
      - name: Configurar Helm
        uses: azure/setup-helm@v3
        with:
          version: 'v3.9.0'
      - name: Configurar kubectl
        uses: azure/setup-kubectl@v3
        with:
          version: 'v1.24.0'
      - name: Autenticar no Cluster Kubernetes (On-Premises)
        run: |
          echo "${{ secrets.KUBE_CONFIG }}" > kubeconfig
          export KUBECONFIG=kubeconfig
          kubectl config use-context on-premises-cluster
      - name: Implantar no Kubernetes On-Premises
        run: |
          helm upgrade --install fluxo-de-caixa ./helm \
            --namespace app \
            --set nodejs.image=${{ secrets.DOCKER_USERNAME }}/fluxo-de-caixa:${{ github.sha }}
      - name: Autenticar no AKS (Azure)
        uses: azure/login@v1
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      - name: Configurar Contexto AKS
        run: |
          az aks get-credentials --resource-group fluxo-de-caixa-rg --name aks-fluxo-de-caixa
      - name: Implantar no AKS
        run: |
          helm upgrade --install fluxo-de-caixa ./helm \
            --namespace app \
            --set nodejs.image=${{ secrets.DOCKER_USERNAME }}/fluxo-de-caixa:${{ github.sha }}
```

#### Explicação do Workflow

- **Trigger:** Push ou pull request em `main` e `develop`.
- **Testes:** Testes unitários do Node.js.
- **Construção:** Imagem Docker publicada no Docker Hub.
- **Varredura:** Trivy verifica vulnerabilidades.
- **Implantação:** Atualiza Helm Chart e implanta no Kubernetes.

#### Benefícios da Integração

- Automação de CI/CD.
- Segurança com varredura de vulnerabilidades.
- Escalabilidade com Helm.
- Rastreabilidade com versionamento.

#### Estrutura do Repositório no GitHub

- Código-fonte, Helm Chart, testes, workflows, e documentação.


- URL: [https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido)

#### Conclusão GitHub

A integração com GitHub e GitHub Actions completa o projeto, com um pipeline CI/CD automatizado que garante qualidade, segurança e eficiência nas implantações.

---

## Conclusão do Projeto de Desafio

### Alta Disponibilidade e Escalabilidade

- Clusters Kubernetes com autoscaling (HPA, Cluster Autoscaler).
- Distribuição de carga: 60% DC, 40% Cloud.
- Operação contínua e escalabilidade eficiente.

### Segurança e Controle de Acesso Aprimorados

- Autenticação: AAD (OAuth 2.0, OIDC, SAML).
- Criptografia: HTTPS, mTLS, TLS.
- Kubernetes: Namespaces, Network Policies, RBAC.
- Varredura: Trivy, Microsoft Defender for Containers, Amazon Inspector.

### Otimização dos Custos

- Tagueamento detalhado.
- Reserved e Spot Instances.
- Monitoramento com Azure Cost Management, AWS Cost Explorer, Grafana, Prometheus.

### Resiliência e Recuperação (DR)

- **Azure:** RTO 5-15 minutos, RPO ~0 (replicação síncrona).
- **AWS:** RTO 15-30 minutos, RPO ~5 minutos (replicação assíncrona).

### Automação e Governança

- IaC com Terraform, Ansible.
- Governança com Azure Policy, AWS Organizations, FinOps.

### Resumo Final

A solução é robusta, segura, eficiente, resiliente e bem governada, combinando alta disponibilidade, segurança, otimização de custos, resiliência, automação e governança em um ambiente híbrido.

---

## Anexos

### Referências de Ferramentas e Tecnologias Utilizadas

- **Terraform:** [https://www.terraform.io/docs](https://www.terraform.io/docs)
- **Ansible:** [https://docs.ansible.com/ansible/latest/index.html](https://docs.ansible.com/ansible/latest/index.html)
- **Kubernetes:** [https://kubernetes.io/docs/home/](https://kubernetes.io/docs/home/)
- **RKE:** [https://rancher.com/docs/rke/latest/en/](https://rancher.com/docs/rke/latest/en/)
- **Azure Active Directory:** [https://learn.microsoft.com/en-us/azure/active-directory/](https://learn.microsoft.com/en-us/azure/active-directory/)
- **Azure SQL Managed Instance:** [https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/)
- **AWS EC2/EKS:** [https://docs.aws.amazon.com/ec2/](https://docs.aws.amazon.com/ec2/), [https://docs.aws.amazon.com/eks/](https://docs.aws.amazon.com/eks/)
- **Grafana:** [https://grafana.com/docs/](https://grafana.com/docs/)
- **Prometheus:** [https://prometheus.io/docs/](https://prometheus.io/docs/)
- **Trivy:** [https://aquasecurity.github.io/trivy/](https://aquasecurity.github.io/trivy/)
- **Microsoft Defender for Containers:** [https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-introduction](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-containers-introduction)
- **Amazon Inspector:** [https://docs.aws.amazon.com/inspector/](https://docs.aws.amazon.com/inspector/)
- **Azure Cost Management:** [https://learn.microsoft.com/en-us/azure/cost-management-billing/](https://learn.microsoft.com/en-us/azure/cost-management-billing/)
- **AWS Cost Explorer:** [https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costexplorer.html](https://docs.aws.amazon.com/cost-management/latest/userguide/what-is-costexplorer.html)
- **ELK Stack:** [https://www.elastic.co/guide/index.html](https://www.elastic.co/guide/index.html)
- **Azure Functions/AWS Lambda:** [https://learn.microsoft.com/en-us/azure/azure-functions/](https://learn.microsoft.com/en-us/azure/azure-functions/), [https://docs.aws.amazon.com/lambda/](https://docs.aws.amazon.com/lambda/)

### Sobre Paulo Lyra

**Perfil:** Profissional sênior com + de 34 anos de experiência em TI e Telecomunicações, com atuação em empresas como iBest, Brasil Telecom, Oi e V.tal. 


**Contatos:**
- Emails: [Paulo.lyra@gmail.com](mailto:Paulo.lyra@gmail.com), [Paulo@ibest.com](mailto:Paulo@ibest.com)
- Telefone/WhatsApp: +55 (61) 98401-1394
- LinkedIn: [https://www.linkedin.com/in/paulolyra/](https://www.linkedin.com/in/paulolyra/)

---