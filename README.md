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
- Conectividade via link dedicado DC-Cloud para maior segurança, baixa latência, e conformidade (LGPD, PCI-DSS).
- Infraestrutura on-premises com cluster de virtualização (Hyper-V ou VMware).
- Recursos existentes no DC: cluster ELK (3 VMs: 8 vCPUs, 32 GB RAM, 500 GB disco), Bastion Host (1 VM: 2 vCPUs, 8 GB RAM, 40 GB disco), e VM Helm (4 vCPUs, 8 GB RAM, 120 GB disco).
- Necessidade de um "landing zone" na nuvem com autenticação e autorização (SAML, OAuth2) e federação com o DC local.
- Volumetria estimada:
  - **Consumo Normal (Pico 14h-15h):** 550 RQS (500 Entradas/Saídas + 50 Consolidado), 200 TPS, 200 sessões simultâneas.
  - **Modo Campanha:** 1050 RQS (1000 Entradas/Saídas + 50 Consolidado), 400 TPS, 400 sessões simultâneas.
  - **Outros** Tempo médio por sessão de 15 minutos com 20 lançamentos por sessão.
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

Adotamos a capacidade do Node.js em **20 TPS por pod** (devido ao overhead de HTTPS e mTLS) para dimensionar o cluster Kubernetes, atendendo à volumetria normal (550 RQS, 200 TPS, 200 sessões) e campanha (1050 RQS, 400 TPS, 400 sessões). No cenário DR, um único ambiente suporta 100% da carga, mantendo ~75% de utilização de CPU e memória, com 25% ociosos e HA (mínimo de 2 nodes).

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
  - 5 nodes (20 vCPUs, 40 GB), autoscaling para 7 nodes (28 vCPUs, 56 GB) ou 10 nodes se considerar HA a nível de node.

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

#### Capacidade dos Pods (cálculo detalhado no pdf em anexo)

- **NGINX:** 120 RPS por pod.
  - Normal: 5 pods <- 550 RQS / 120 RPS o qual é a capacidade estimada de atendimento do Pod NGINX no projeto.
  - Campanha: 9 pods.
- **Node.js:** 20 TPS (60 RQS) por pod.
  - Normal: 10 pods <- 200 TPS / 20 TPS que é a capacidade estimada de atendimento do Noje.js no projeto.
  - Campanha: 20 pods.
- **Redis:** 1 pod (256Mi–512Mi RAM).
- **Prometheus:** 1–2 pods (200m–400m CPU, 400Mi–800Mi RAM).
- **Grafana:** 1 pod (100m–200m CPU, 256Mi–512Mi RAM).
- **Fluentd (DaemonSet):** 10 pods (55m–110m CPU, 140Mi–280Mi RAM per pod).

![Figura 2 – racional consumo de pods](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-2.png)
![Figura 3 – racional consumo de pods DR ](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-3.png)

**Consumo Normal (550 RQS, 200 TPS, 200 sessões)**  
- **CPU**:  
  - NGINX (On-Premises): 0,75 vCPU  
  - NGINX (Nuvem): 0,5 vCPU  
  - Node.js (On-Premises): 3 vCPUs  
  - Node.js (Nuvem): 2 vCPUs  
  - Redis: 0,1 vCPU  
  - Prometheus: 0,4 vCPU  
  - Grafana: 0,1 vCPU  
  - Fluentd: 1,1 vCPU (10 pods)  
  - **Total**: 7,95 vCPUs (~19,9% de 40 vCPUs disponíveis)  

- **Memória**:  
  - NGINX (On-Premises): 0,94 GB  
  - NGINX (Nuvem): 0,63 GB  
  - Node.js (On-Premises): 3,75 GB  
  - Node.js (Nuvem): 2,5 GB  
  - Redis: 0,25 GB  
  - Prometheus: 0,78 GB  
  - Grafana: 0,25 GB  
  - Fluentd: 2,73 GB (10 pods)  
  - **Total**: 11,83 GB (~14,8% de 80 GB disponíveis)  

**Modo Campanha (1050 RQS, 400 TPS, 400 sessões)**  
- **CPU**:  
  - NGINX (On-Premises): 1,5 vCPUs  
  - NGINX (Nuvem): 1 vCPU  
  - Node.js (On-Premises): 6 vCPUs  
  - Node.js (Nuvem): 4 vCPUs  
  - Redis: 0,1 vCPU  
  - Prometheus: 0,8 vCPU  
  - Grafana: 0,1 vCPU  
  - Fluentd: 1,1 vCPU (10 pods)  
  - **Total**: 14,6 vCPUs (~36,5% de 40 vCPUs disponíveis)  

- **Memória**:  
  - NGINX (On-Premises): 1,88 GB  
  - NGINX (Nuvem): 1,25 GB  
  - Node.js (On-Premises): 7,5 GB  
  - Node.js (Nuvem): 5 GB  
  - Redis: 0,25 GB  
  - Prometheus: 1,56 GB  
  - Grafana: 0,25 GB  
  - Fluentd: 2,73 GB (10 pods)  
  - **Total**: 20,42 GB (~25,5% de 80 GB disponíveis)  

#### Cálculo do Número de Worker Nodes por Ambiente 


### Distribuição em modo normal 550 RQS (Ambos os Ambientes Ativos) cenário 60/40
#### On-Premises (60%)
- 3 nodes (total:12 vCPUs, 24 GB), autoscaling para 5 nodes em caso de falha na cloud.
- Carga: 335 RQS, 120 TPS, 120 sessões

#### Cloud (40%)
- 2 nodes (total:8 vCPUs, 16 GB), autoscaling para 5 nodes em caso de falha no DC on-premises.
- Carga: 215 RQS, 80 TPS, 80 sessões


### Distribuição em modo campanha 1050 RQS (Ambos os Ambientes Ativos) cdnário 60/40
#### On-Premises (60%)
- 4 nodes (total:16 vCPUs, 32 GB), autoscaling para 7 nodes em caso de falha na cloud.
- Carga: 630 RQS, 240 TPS, 240 sessões

#### Cloud (40%)
- 3 nodes (total:12 vCPUs, 24 GB), autoscaling para 7 nodes em caso de falha no DC on-premises.
- Carga: 420 RQS, 160 TPS, 160 sessões


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

- Licenciamento realizado por core portanto, considerando servidor especializado com poucoscores com processador xeon específico de cores mais elevados.
- 2 servidores físicos 8 cores 256 GB RAM e 8 TB de disco SSD (considerando que não temos storage SAN), 4 interfaces 10 GBE.
- SO Windows Server na última edição.
- MS SQL Server Enterprise na última edição.
- 1 servidor Banco Primário ativo, 1 servidor Secundário HA, ambos com réplica síncrona.
- Always On ativo


#### Opção Cloud: Azure SQL Managed Instances (Azure ARC)

- SQL Server Managed Instance Business Critical C  16 vCPUs, 128 GB RAM, 1 TB disco (1º ano).
- Réplica assíncrona que pode ser promovida para master em caso de indisponibilidade do cluster ativo-passivo on premises com Always On.

#### Opção Cloud: AWS MS SQL Enterprise em EC2

- Instância R6i.4xlarge: 16 vCPUs, 128 GB RAM, 1 TB EBS io2 (10,000 IOPS).
- Always On ativo.
- Replica assíncrona que pode ser promovida para master em caso de indisponibilidade do cluster ativo-passivo on premises.
- Keep-alive no load balancer para reduzir latência.


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

#### Uso Estratégico de Serverless envolvendo automações

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

![Diagrama 1 - Topologia DC On-premises](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/diagrama-topologia-dc-on-premises.png) 


### CLOUD CENÁRIO DC XPTO <-> AWS

![Diagrama 2 - VPC AWS](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/vpc-aws.png)
![Diagrama 3 - Integracão DC AWS](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-aws.png)


### CLOUD CENÁRIO DC XPTO <–> AZURE ARC

![Diagrama 4 - Integracao DC Azure ARC 1a](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-azure-1a.png)

![Diagrama 5 - Integracao DC Azure ARC 1b](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/integracao-dc-azure-1b.png)

### Fluxo de Comunicação

![Diagrama 6 - Macro Fluxo comunicação aplicação](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/diagrams/macro-fluxo-aplicacao.png)


### MONITORAÇÃO E OBSERVABILIDADE

## MONITORAÇÃO OSI

 - **Camada 1 – Física (Conexões Físicas):** 
    - 	Ferramenta: Prometheus com Node Exporter.
    - 	Monitoramento: O Node Exporter coleta métricas de hardware (ex.: taxa de erros de pacotes, latência de interface de rede) nos nós do Kubernetes (datacenter e nuvem).
    -	Exemplo: Um pico de erros na interface de rede pode indicar falhas físicas (ex.: cabos ou switches). Grafana exibe essas métricas em um dashboard, permitindo ação rápida para evitar quedas.
 - **Camada 2 – Enlace (Switches, VLANs):** 
    -	Ferramenta: Prometheus com SNMP Exporter.
    -	Monitoramento: Monitora switches e VLANs usados para segmentar o tráfego entre namespaces (proxy e app). Métricas como colisões de pacotes ou erros de frame são coletadas via SNMP.
    -	Exemplo: Um aumento de colisões pode indicar problemas de configuração no datacenter local ou na VPC (AWS). Grafana alerta a equipe para corrigir a segmentação.
- **Camada 3 – Rede (IP, Roteamento):** 
    -	Ferramenta: Prometheus com Blackbox Exporter.
    -	Monitoramento: Verifica a conectividade IP entre componentes (ex.: NGINX → Node.js, Node.js → SQL). Métricas como latência de pacotes, perda de pacotes e tempo de resposta são coletadas.
    -	Segurança: Detecta tentativas de acesso não autorizado (ex.: IPs fora do permitido pelas Network Policies).
    -	Exemplo: Um aumento na perda de pacotes entre o datacenter e o Azure pode indicar problemas de roteamento, visíveis em um dashboard Grafana, permitindo ajustes no Azure Traffic Manager.
- **Camada 4 – Transporte (TCP/UDP):** 
    -	Ferramenta: Prometheus com Node Exporter e NGINX Prometheus Exporter.
    -	Monitoramento: Métricas como conexões TCP ativas, retransmissões e timeouts são coletadas para portas específicas (ex.: 443 para HTTPS, 6379 para Redis, 1433 para SQL).
    -   Eficiência: Retransmissões altas podem indicar congestionamento, afetando o desempenho.
    -	Segurança: Um número anormal de conexões TCP pode sugerir um ataque DDoS, que pode ser correlacionado com logs do ELK.
    -	Exemplo: Grafana mostra um pico de retransmissões na porta 443 entre NGINX e Node.js, indicando problemas de rede que podem ser mitigados ajustando configurações de TCP.
- **Camada 5 – Sessão (Gerenciamento de Sessões):**  
    -   Ferramenta: ELK (Elastic Stack).
    -	Monitoramento: Logs do NGINX (namespace proxy) registram detalhes de sessões (ex.: duração, falhas de autenticação).
    -	Segurança: Detecta tentativas de hijacking de sessão ou falhas repetidas de autenticação (ex.: tokens JWT inválidos).
    -	Exemplo: Kibana exibe um aumento de falhas de autenticação, sugerindo um ataque de força bruta, permitindo bloqueio proativo de IPs suspeitos.
- **Camada 6 – Apresentação (Criptografia, Formato):** 
    -   Ferramenta: Prometheus com Blackbox Exporter e Grafana.
    -	Monitoramento: Verifica a integridade do TLS (ex.: certificados expirados, falhas de handshake).
    -	Segurança: Garante que o tráfego HTTPS (NGINX → Usuários, NGINX → Node.js com mTLS) e TLS (Node.js → SQL) esteja funcionando corretamente.
    -	Exemplo: Um alerta no Grafana indica que um certificado está prestes a expirar, permitindo renovação via cert-manager antes de falhas.

- **Camada 7 – Aplicação (HTTP, APIs):** 
    -	Ferramenta: Prometheus com NGINX Prometheus Exporter e Grafana.
    -	Monitoramento: Métricas de requisições HTTP (ex.: taxas de erro 5xx, latência de APIs REST).
    -	Eficiência: Identifica gargalos em endpoints críticos (ex.: /entradas no Node.js).
    -	Segurança: Detecta padrões de tráfego anormais (ex.: aumento de requisições suspeitas), correlacionando com logs no ELK para análise detalhada.
    -	Exemplo: Grafana mostra um pico de erros 403, indicando falhas de autorização, que podem ser investigadas via logs no Kibana.

 ### ABORDAGENS COMPLEMENTARES

Além do Modelo OSI, podemos adotar abordagens complementares para monitoramento de rede:
- **Análise de Fluxo de Rede (NetFlow/IPFIX):** 
    -	Ferramenta: ntopng ou AWS VPC Flow Logs (no cenário AWS).
    -	Monitoramento: Registra fluxos de tráfego entre componentes (ex.: datacenter → AKS/EKS).
    -	Segurança: Identifica tráfego suspeito (ex.: portas não autorizadas).
    -	Eficiência: Ajuda a otimizar rotas de tráfego entre o datacenter e a nuvem.
- **Monitoramento de Segurança (WAF e IDS):**  
    -	Ferramenta: AWS WAF (AWS) ou Azure Application Gateway com WAF (Azure).
    -	Monitoramento: Analisa tráfego na camada 7 para detectar ataques (ex.: SQL injection, XSS).
    -	Segurança: Bloqueia requisições maliciosas antes que cheguem ao NGINX.

Especificidades por Cenário
	
- **CENÁRIO 1: DATACENTER LOCAL + AZURE ARC + AZURE SQL MANAGED INSTANCE**
	- ***Monitoramento de Rede:*** 
      - Azure Network Watcher: Complementa o Prometheus/Grafana, fornecendo diagnóstico de rede (ex.: latência entre datacenter e AKS).
	    -  Azure Monitor: Integra-se com Grafana para exibir métricas de rede do SQL MI (ex.: conexões TCP na porta 1433).
	- ***Segurança:*** 
      - Network Watcher pode detectar tráfego não autorizado entre o datacenter e o Azure, correlacionando com logs no ELK.
	- ***Eficiência:*** 
      - Dashboards no Grafana mostram latência de rede entre o datacenter e o AKS, permitindo ajustes no Azure Traffic Manager para otimizar o tráfego.

- **CENÁRIO 2: DATACENTER LOCAL + AWS + MS SQL EM EC2**
	- ***Monitoramento de Rede:*** 
      - AWS VPC Flow Logs: Registra fluxos de tráfego entre o datacenter e o EKS, integrando com Prometheus/Grafana via exportadores.
      - Amazon CloudWatch: Fornece métricas de rede (ex.: latência de pacotes), que podem ser visualizadas no Grafana.
	- ***Segurança:*** 
      - VPC Flow Logs ajudam a identificar tráfego suspeito (ex.: IPs fora das regras de Security Groups), com alertas configurados no Prometheus.
	- ***Eficiência:*** 
      - Grafana exibe métricas de latência entre o datacenter e o EKS, permitindo ajustes no AWS ALB para melhorar o desempenho.

![Figura 6 – racional consumo de pods DR ](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-6.png)

Grafana, Prometheus e ferramentas complementares (como Azure Network Watcher e AWS VPC Flow Logs) permitem monitorar eventos de rede em todas as camadas do Modelo OSI, garantindo segurança (detecção de tráfego suspeito, validação de criptografia) e eficiência (otimização de latência e roteamento). No cenário Azure, a integração nativa com ferramentas como Network Watcher simplifica o monitoramento e ajustes, enquanto no cenário AWS, VPC Flow Logs e CloudWatch oferecem flexibilidade, mas exigem mais configuração. Ambas as abordagens protegem a aplicação de fluxo de caixa e otimizam o tráfego, com o Azure se destacando pela facilidade e o AWS pela personalização.

## OBSERVABILIDADE

Observabilidade é sustentada por três pilares principais, que já foram parcialmente implementados na stack (Kubernetes, NGINX, Node.js, Redis, ELK, Grafana, Prometheus). Vamos expandir e detalhar cada pilar:
- **Métricas (Prometheus e Grafana):** 
    -  	O que já temos: Prometheus coleta métricas (ex.: latência, erros HTTP, uso de CPU) e Grafana as visualiza em dashboards, cobrindo camadas do Modelo OSI (ex.: latência de rede na Camada 3, erros HTTP na Camada 7).
    -	Aprimoramento: 
        -	Métricas Customizadas nos Microsserviços: No Node.js, usar bibliotecas como prom-client para criar métricas específicas da aplicação (ex.: tempo de processamento de uma entrada no fluxo de caixa). 
        -	Métricas de Banco de Dados: Usar Prometheus SQL Exporter para coletar métricas detalhadas do MS SQL Server (ex.: tempo médio de queries, bloqueios de transação), tanto no datacenter quanto na Azure SQL MI ou EC2.
        -	Dashboards Avançados: Criar dashboards no Grafana com alertas baseados em thresholds (ex.: latência de API > 500ms), correlacionando métricas de diferentes camadas (rede, aplicação, banco).
- **Logs (ELK):** 
    -	O que já temos: O ELK (Elasticsearch, Logstash, Kibana) centraliza logs de NGINX, Node.js, Redis e MS SQL Server, permitindo análise de eventos de autenticação e erros.
    -	Aprimoramento: 
        -	Logs Estruturados: Padronizar logs no formato JSON em todos os componentes (ex.: NGINX, Node.js), facilitando a busca e análise no Kibana. 
        -	Correlação com Contexto: Adicionar IDs de transação (correlation IDs) aos logs, permitindo rastrear uma requisição desde o NGINX até o Node.js, Redis e MS SQL Server. 
            -	Exemplo: Um correlation ID txn-123 é incluído no cabeçalho HTTP pelo NGINX e propagado para logs de todos os serviços, visível no Kibana.
        -	Análise de Segurança: Usar Kibana para criar visualizações que detectem padrões de ataque (ex.: múltiplas falhas de autenticação por IP), complementando a análise de rede feita com Prometheus.
- **Tracing (OpenTelemetry ou Jaeger):** 
    -	O que falta: Atualmente, a stack não inclui tracing distribuído, essencial para entender o fluxo de requisições em um sistema de microsserviços.
    -	Aprimoramento: 
        -	Implementar OpenTelemetry: Instrumentar o NGINX, Node.js e conexões com Redis e MS SQL Server para gerar traces. 
        -	No Node.js, usar a biblioteca @opentelemetry para capturar spans: 
        -	Backend de Tracing: Usar Jaeger ou Elastic APM (integrado ao ELK) para armazenar e visualizar traces.
        -	Benefício: Tracing permite identificar gargalos (ex.: uma query lenta no MS SQL Server) e rastrear falhas em requisições distribuídas, como uma entrada que falha ao ser processada.

### ABORDAGENS COMPLEMENTARES

Além de Grafana, Prometheus, ELK e OpenTelemetry/Jaeger, podemos adicionar:

- **Loki (para Logs):** 
  -	Uma alternativa leve ao ELK, Loki é otimizado para logs em ambientes Kubernetes. Ele se integra ao Grafana, permitindo correlacionar logs e métricas em um único painel.
  -	Exemplo: Loki coleta logs do NGINX e Node.js, e Grafana exibe um gráfico de latência HTTP ao lado de logs de erros, facilitando a análise.
- **AWS X-Ray (no Cenário AWS):** 
  -	No cenário AWS, o X-Ray pode ser usado para tracing distribuído, complementando o OpenTelemetry. Ele rastreia requisições entre o EKS, EC2 e outros serviços AWS.
  -	Exemplo: X-Ray mostra que uma requisição ao MS SQL em EC2 está lenta devido a bloqueios de transação, visível em um mapa de serviço.
- **Azure Monitor (no Cenário Azure):** 
  -	No cenário Azure, o Azure Monitor coleta métricas e logs do AKS e do Azure SQL MI, integrando-se ao Grafana   para uma visão unificada.
  -	Exemplo: Azure Monitor detecta um pico de latência no SQL MI, correlacionado com métricas de rede no Grafana.


Especificidades por Cenário

- **Cenário 1: Datacenter Local + Azure Arc + Azure SQL Managed Instance:** 
    -	Métricas: Prometheus e Azure Monitor coletam métricas do AKS e do SQL MI (ex.: tempo de queries, conexões TCP). Grafana exibe essas métricas em dashboards, permitindo correlacionar latência de rede com desempenho do banco.
    -	Logs: ELK centraliza logs, e o Azure Monitor adiciona logs de diagnóstico do SQL MI, visíveis no Kibana.
    -	Tracing: OpenTelemetry instrumenta os microsserviços no AKS, e os traces são armazenados no Jaeger, 
    mostrando  fluxo completo de uma requisição (ex.: NGINX → Node.js → SQL MI).
    -	Vantagem: A integração nativa com Azure Monitor e a facilidade de configuração de tracing no AKS tornam a observabilidade mais simples e centralizada.
- **Cenário 2: Datacenter Local + AWS + MS SQL em EC2:** 
    -	Métricas: Prometheus coleta métricas do EKS e do EC2 (via SQL Exporter), complementado por métricas do Amazon CloudWatch. Grafana exibe tudo em dashboards unificados.
    -	Logs: ELK centraliza logs, e o AWS CloudWatch Logs adiciona logs do EC2, que podem ser exportados para o Elasticsearch.
    -	Tracing: OpenTelemetry com AWS X-Ray rastreia requisições no EKS, mostrando gargalos (ex.: latência entre Node.js e EC2).
    -	Vantagem: AWS X-Ray oferece uma visão detalhada do tráfego entre serviços AWS, mas a configuração de tracing e exportação de logs exige mais esforço.

### BENEFÍCIOS PARA SEGURANÇA E EFICIÊNCIA
- **Segurança:** 
    -	Tracing (OpenTelemetry/Jaeger) ajuda a identificar requisições suspeitas (ex.: tempos de resposta anormais que podem indicar ataques).
    -	Logs (ELK/Loki) correlacionados com métricas (Prometheus) detectam padrões de ataque (ex.: aumento de erros 403 com IPs suspeitos).
    -	Eficiência: 
    -	Métricas e traces identificam gargalos (ex.: latência alta no Redis ou no SQL), permitindo ajustes (ex.: aumentar réplicas do Redis).
    -	Dashboards unificados no Grafana mostram o impacto de mudanças (ex.: latência reduzida após otimizar Network Policies).

![Figura 7 – racional consumo de pods DR ](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-7.png)

Conclusão
A observabilidade é ampliada com métricas (Prometheus/Grafana), logs (ELK/Loki) e tracing (OpenTelemetry/Jaeger ou AWS X-Ray), proporcionando uma visão completa do sistema em ambos os cenários. No Azure, a integração nativa com Azure Monitor facilita a implementação, enquanto no AWS, ferramentas como X-Ray e CloudWatch oferecem flexibilidade, mas com maior esforço de configuração. Essa abordagem garante segurança (detecção de anomalias), eficiência (otimização de desempenho) e resiliência (diagnóstico rápido de falhas), essencial para uma aplicação crítica como fluxo de caixa em um ambiente híbrido.
 





---

## Justificativas

### Framework

#### Kubernetes (com NGINX, Node.js, Redis)

- **Escalabilidade e Orquestração:** Kubernetes gerencia e escala microsserviços com HPA.

O Kubernetes permite gerenciar e escalar automaticamente os microsserviços da aplicação (como entrada, saída e consolidação de dados) usando o Horizontal Pod Autoscaler (HPA). Isso garante que a aplicação suporte picos de até 50 requisições por segundo com perdas inferiores a 5%, além de simplificar atualizações e monitoramento.

- **Portabilidade:** Funciona on-premises e na nuvem.

Funciona tanto no datacenter local quanto na nuvem (Azure ou AWS), garantindo consistência em ambientes híbridos.


- **Alta Disponibilidade:** Réplicas e múltiplos nodes.

Réplicas de pods e múltiplos nodes asseguram que o sistema permaneça operacional mesmo em caso de falhas.

- **NGINX:** Proxy e balanceador de carga, validação de tokens JWT.

Usado como proxy e balanceador de carga, gerencia o tráfego no namespace proxy e valida tokens JWT para segurança.
É leve e otimizado para alto volume de requisições.

- **Node.js:** Desenvolvimento rápido de microsserviços RESTful.

Ideal para desenvolver microsserviços RESTful rapidamente, com suporte a operações assíncronas (I/O não bloqueante).
Integra-se facilmente com Redis (cache/filas) e MS SQL Server via bibliotecas como express e mssql.


- **Redis:** Cache em memória e filas assíncronas.

Fornece cache em memória e filas assíncronas, reduzindo a carga no banco de dados e garantindo baixa latência em operações frequentes.

#### Namespaces Segregados (proxy e app)

- **Segurança:** Network Policies e RBAC por namespace.

Separa o NGINX (proxy) dos microsserviços e Redis (app), com Network Policies controlando o tráfego (ex.: NGINX acessa Node.js apenas na porta 443).
O RBAC (Role-Based Access Control) restringe permissões por namespace, aplicando o princípio de privilégio mínimo.


- **Organização:** Escalonamento independente de NGINX e Node.js.

Permite gerenciar recursos de forma independente, escalando NGINX ou Node.js separadamente conforme a demanda.

#### Banco de Dados MS SQL Server

- **Confiabilidade:** Always On com replicação assíncrona.

Suporta transações consistentes e alta disponibilidade com Always On Availability Groups, replicando dados assincronamente entre o master (datacenter) e o slave (nuvem).

- **Performance:** Otimizado para consultas financeiras.

Otimizado para consultas complexas e relatórios financeiros, atendendo às necessidades do fluxo de caixa.

#### Prometheus e Grafana

- **Controle de Métricas:** Modelo pull-based.

Utiliza um modelo pull-based, obtendo dados de endpoints /metrics expostos por serviços como Node.js, NGINX e Redis.

- **Alertas:** Regras para anomalias.

Permite configurar regras de alerta para notificar a equipe sobre anomalias (ex.: uso excessivo de CPU ou alta latência), possibilitando ações rápidas para manter os serviços operacionais.

- **Dashboards:** Visão em tempo real por namespace.

Exibe o estado dos serviços em tempo real, organizados por namespaces (ex.: proxy para NGINX, app para Node.js e Redis).

#### ELK (Elasticsearch, Logstash, Kibana)

- **Monitoramento:** Centralização de logs com visualização no Kibana.

Centraliza logs do Kubernetes (via Fluentd) e do MS SQL Server (via Filebeat) no Elasticsearch, com visualização em dashboards no Kibana.
Ajuda a identificar e resolver problemas rapidamente, oferecendo visibilidade sobre métricas críticas.



#### Workload Híbrido (considerando 60% Datacenter Local, 40% Nuvem)

- **Custo e Controle:** 60% on-premises reduz custos.

Manter 60% no datacenter local reduz custos operacionais e dá mais controle sobre dados sensíveis.

- **Escalabilidade e Resiliência:** 40% na nuvem para picos e continuidade.

Os 40% na nuvem permitem escalar rapidamente em picos de demanda e garantem continuidade em caso de falhas no datacenter.

#### Cenário 1: Datacenter Local + Azure Arc com Azure SQL Managed Instance e Kubernetes com AKS

- **Gerenciamento:** Azure Arc centraliza governança.

Integra o cluster Kubernetes e o MS SQL Server master (no datacenter) como recursos Azure, centralizando governança e monitoramento no Azure Portal.

- **Azure SQL MI:** Réplica na nuvem com backups automáticos.

Hospeda a réplica do banco na nuvem com alta disponibilidade, backups automáticos e integração nativa com Always On Availability Groups, reduzindo a sobrecarga operacional.

- **AKS** Hospeda 40% da carga com auto scaling.

- **Segurança:** Integração com AAD (SSO).

Integração com Azure Active Directory (AAD) para autenticação SSO e aplicação de políticas de segurança unificadas (ex.: Azure Defender for SQL).

- **Facilidade Operacional:** Com Azure Traffic Manager.

Azure Traffic Manager distribui o tráfego entre datacenter (60%) e Azure (40%), com monitoramento simplificado via Azure Arc.

- **Vantagens:** Simplicidade e alta disponibilidade.
Ideal para quem busca simplicidade, integração nativa com AAD e alta disponibilidade com menos esforço operacional.
 



#### Cenário 2: Datacenter Local + AWS com EKS e MS SQL em EC2

- **EKS:** Hospeda 40% da carga com auto scaling.

Hospeda os 40% da carga na AWS com auto scaling e integração com serviços como ALB (Application Load Balancer) para balanceamento de tráfego.

- **MS SQL em EC2:** Controle total sobre configurações.

A réplica assíncrona roda em uma instância EC2, oferecendo controle total sobre configurações como Always On Availability Groups.

- **Flexibilidade:** Ajustes finos no EKS.

AWS permite ajustes finos no EKS e em serviços complementares, ideal para equipes experientes.

- **Vantagens:** Ideal para equipes experientes.

Melhor para quem precisa de maior controle e já tem expertise no ecossistema AWS.

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

A stack tecnológica foi adotada por oferecer escalabilidade (Kubernetes, Node.js, Redis), segurança (NGINX com mTLS, namespaces, RBAC), confiabilidade (MS SQL Server), visibilidade (ELK) e custo-benefício (workload híbrido). O Cenário 1 (Azure Arc) simplifica a gestão e melhora a resiliência com SQL Managed Instance, enquanto o Cenário 2 (AWS) dá mais controle com EKS e EC2, mas exige mais configuração. A escolha depende das prioridades da equipe, como facilidade operacional ou flexibilidade técnica

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

##  AUTENTICAÇÃO E SEGURANÇA

A autenticação e a segurança são fundamentais para proteger uma aplicação de fluxo de caixa, garantindo que apenas usuários autorizados acessem os serviços e que os dados financeiros permaneçam confidenciais e íntegros. A stack tecnológica utiliza componentes como um provedor de identidade central, NGINX como proxy seguro, namespaces (proxy, app) para isolamento, criptografia em todas as camadas e ferramentas de monitoramento para alcançar esses objetivos. A seguir, exploramos como esses elementos se aplicam aos cenários de integração entre um datacenter local e as nuvens Azure e AWS.

![Figura 4 –Autenticação e Segurança](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-4.png)

Ambos os cenários – datacenter local integrado com Azure e com AWS – oferecem autenticação robusta e segurança avançada para a aplicação de fluxo de caixa, utilizando um provedor de identidade central, NGINX como proxy seguro, isolamento via namespaces, criptografia em todas as camadas e monitoramento contínuo. O cenário com Azure se destaca pela simplicidade e integração nativa com o AAD e o Azure Arc, sendo ideal para quem busca agilidade na implementação. Já o cenário com AWS oferece maior flexibilidade e controle por meio do AWS IAM e configurações manuais, atendendo a quem prefere personalização detalhada. A escolha depende das prioridades: simplicidade (Azure) ou customização (AWS).

## DR 

Disaster Recovery (DR) em cenários de datacenter local integrado com Azure e com AWS podem prover RTO (Recovery Time Objective) e RPO (Recovery Point Objective) adequados para uma aplicação crítica como fluxo de caixa.
 - RTO (Recovery Time Objective): Representa o tempo máximo que a aplicação pode ficar indisponível após uma falha antes de causar impactos. Para uma aplicação crítica como fluxo de caixa, que exige alta disponibilidade, o RTO ideal é muito baixo, na casa de minutos (ex.: 5 a 15 minutos). 
 - RPO (Recovery Point Objective): Quantidade máxima de dados perdida, medida pelo tempo entre o último backup ou réplica e a falha. Em um sistema financeiro, onde cada transação é crucial, o RPO deve ser próximo de zero (ex.: segundos ou, no máximo, poucos minutos).

- **CENÁRIO 1: DATACENTER LOCAL + AZURE ARC + AZURE SQL MANAGED INSTANCE:**
   - ***RTO no Azure:** 
        No cenário com Azure Arc e Azure SQL Managed Instance (MI), a recuperação é altamente otimizada:
        - Failover Automático: O SQL Managed Instance suporta grupos de disponibilidade (como Always On Availability Groups) com failover automático para uma réplica na nuvem, reduzindo o tempo de inatividade a 5-15 minutos.
        - Redirecionamento de Tráfego: O Azure Traffic Manager redireciona o tráfego para o cluster Kubernetes (AKS) na nuvem quase instantaneamente após o failover.
   	Vantagem: A automação nativa do Azure minimiza a intervenção humana, garantindo um RTO baixo e confiável.
   - ***RPO no Azure:***
        - Replicação Assíncrona: A réplica no SQL MI é atualizada de forma assíncrona com um atraso mínimo (segundos a minutos), resultando em um RPO de até 5 minutos.
        - Cache com Redis: Dados voláteis podem ser mantidos no Redis, mas para um RPO menor, é necessário configurar persistência (ex.: AOF ou RDB) para evitar perdas.
        - Otimização: Ajustando a frequência da replicação ou usando backups frequentes, o RPO pode ser reduzido ainda mais.
 

- **CENÁRIO 2: DATACENTER LOCAL + AWS + MS SQL EM EC2:**
    - ***RTO na AWS:***
        No cenário com AWS e MS SQL Server rodando em instâncias EC2, o processo é menos automatizado:
        - Failover Manual: A promoção da réplica no EC2 para o papel de master exige intervenção manual, o que aumenta o tempo de recuperação para 30-60 minutos.
        - Redirecionamento de Tráfego: O AWS Application Load Balancer (ALB) redireciona o tráfego para o cluster EKS, mas o processo completo é mais lento devido à falta de automação nativa.
        - Desvantagem: A dependência de ações manuais eleva o RTO, tornando-o menos ideal para uma aplicação crítica.

    - ***RPO no AWS:***
        Replicação Assíncrona: Assim como no Azure, o uso de Always On Availability Groups em replicação assíncrona resulta em um RPO de até 5 minutos.
        - Cache com Redis: Configurações de persistência no Redis são igualmente necessárias para minimizar perdas de dados.
        - Risco: A falta de automação pode introduzir atrasos na sincronização, afetando a consistência do RPO.

- **Otimizações para uma Aplicação Crítica como Fluxo de Caixa:**
    Para garantir que o RTO e o RPO atendam aos requisitos rigorosos de uma aplicação de fluxo de caixa, algumas melhorias podem ser implementadas em ambos os cenários:
    - Automação Avançada: 
       - Azure: Scripts ou políticas de failover automático já são nativos, mas podem ser refinados para reduzir o RTO para menos de 5 minutos.
       - AWS: Configurar AWS Lambda ou ferramentas de automação para disparar o failover, diminuindo o RTO para algo próximo de 15-20 minutos.
    - Replicação Síncrona: 
      - Em ambos os cenários, adotar replicação síncrona (em vez de assíncrona) pode zerar o RPO, garantindo que nenhum dado seja perdido. Isso exige uma conexão de baixa latência e alta largura de banda entre o datacenter local e a nuvem, mas é viável para sistemas financeiros críticos.
    - Backups Frequentes: 
      - Azure: O SQL MI suporta backups automáticos com alta frequência (ex.: a cada 1-5 minutos).
      - AWS: Snapshots frequentes no EC2 ou uso do AWS Backup podem reduzir o RPO para segundos.
    - Testes Regulares: 
      - Simulações de falhas devem ser realizadas periodicamente para validar os tempos de RTO e RPO e ajustar as configurações conforme necessário.

Para uma aplicação crítica como fluxo de caixa, o cenário Datacenter Local + Azure Arc com Azure SQL Managed Instance é superior, oferecendo um RTO de 5-15 minutos e um RPO de até 5 minutos, com automação integrada e menor complexidade operacional. Já o cenário Datacenter Local + AWS com MS SQL em EC2 apresenta um RTO mais alto (30-60 minutos) devido à necessidade de intervenção manual, embora o RPO seja comparável (até 5 minutos).
Para atender aos requisitos mais exigentes (RTO e RPO próximos de zero), recomenda-se implementar replicação síncrona e backups frequentes em ambos os casos, com o Azure se destacando pela facilidade de automação e gerenciamento. Assim, o Azure é a escolha mais robusta e ágil para garantir a continuidade de uma aplicação financeira essencial.
utilizando Ansible, Terraform (ou AWS CloudFormation, se restrito a ferramentas AWS), podemos reduzir significativamente o RTO no cenário descrito para a AWS, chegando a 15-30 minutos. Isso envolve automatizar o failover do MS SQL Server, o redirecionamento de tráfego no EKS e a atualização das conexões dos microsserviços. Embora seja uma melhoria expressiva em relação ao processo manual, o Azure ainda seria mais rápido para aplicações críticas devido à sua automação nativa.


![Figura 5 – Autenticação e Segurança](https://github.com/paulohenriquelyra/fluxo-caixa-k8s-hibrido/blob/main/docs/figura-5.png)

---

## Conclusão do Projeto de Desafio

Consolidamos uma solução abrangente e estratégica para o projeto de desafio, abordando os tópicos cruciais de alta disponibilidade e escalabilidade, segurança e controle de acesso, otimização de custos, resiliência e recuperação (DR), e automação e governança. Abaixo, apresentamos uma conclusão que reflete como cada aspecto foi cuidadosamente considerado e implementado, resultando em uma solução robusta para suportar a aplicação de fluxo de caixa em cenários híbridos (datacenter local, Azure e AWS).

### Alta Disponibilidade e Escalabilidade

- Clusters Kubernetes com autoscaling (HPA, Cluster Autoscaler).
- Distribuição de carga: 60% DC, 40% Cloud.
- Operação contínua e escalabilidade eficiente.
- Resultado: Operação contínua e escalabilidade eficiente, atendendo às necessidades dos usuários sem interrupções.

### Segurança e Controle de Acesso Aprimorados

- Autenticação: AAD (OAuth 2.0, OIDC, SAML).
- Criptografia: HTTPS, mTLS, TLS.
- Kubernetes: Namespaces, Network Policies, RBAC.
- Varredura: Trivy, Microsoft Defender for Containers, Amazon Inspector.
- Resultado: Dados protegidos, acesso seguro e conformidade com padrões de segurança.

### Otimização dos Custos

- Tagueamento detalhado.
- Reserved e Spot Instances.
- Monitoramento com Azure Cost Management, AWS Cost Explorer, Grafana, Prometheus.
- Resultado: Custos otimizados, transparência financeira e ajustes proativos para evitar desperdícios.

### Resiliência e Recuperação (DR)

- **Azure:** RTO 5-15 minutos, RPO ~0 (replicação síncrona).
- **AWS:** RTO 15-30 minutos, RPO ~5 minutos (replicação assíncrona).
- Resultado: Recuperação rápida e perda mínima de dados, essencial para uma aplicação financeira crítica.

### Automação e Governança

- IaC com Terraform, Ansible.
- Governança com Azure Policy, AWS Organizations, FinOps.
- Resultado: Redução de erros humanos, maior eficiência e conformidade facilitada com diretrizes organizacionais.

### Resumo Final

A solução proposta é robusta, segura, economicamente eficiente, resiliente e bem governada, atendendo plenamente aos requisitos do projeto. A abordagem híbrida (datacenter local + Azure/AWS) oferece flexibilidade e redundância, enquanto tecnologias como Kubernetes, AAD, Terraform e práticas de FinOps proporcionam uma base moderna e sustentável. Essa infraestrutura suporta as operações financeiras críticas da organização, garantindo alta disponibilidade, proteção de dados, controle de custos, recuperação rápida em falhas e governança eficaz. Estamos preparados para desafios futuros com uma solução escalável, auditável e alinhada às metas estratégicas.


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

**Perfil:** Profissional sênior com + de 34 anos de experiência em TI e Telecomunicações, com atuação no Governo, RNP nos anos 90 e em empresas iBest, Brasil Telecom, Oi e V.tal nos últimos 22 anos.


**Contatos:**
- Emails: [Paulo.lyra@gmail.com](mailto:Paulo.lyra@gmail.com), [Paulo@ibest.com](mailto:Paulo@ibest.com)
- Telefone/WhatsApp: +55 (61) 98401-1394
- LinkedIn: [https://www.linkedin.com/in/paulolyra/](https://www.linkedin.com/in/paulolyra/)

---