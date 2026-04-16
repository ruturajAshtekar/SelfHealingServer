
**Overview**

This project implements a self-healing, auto-scaling microservice architecture using Docker and Docker Compose.
The system runs inside a virtual machine provided by Vagrant and consists of a Flask application, an Nginx load balancer, monitoring via Prometheus and Grafana, and automation through shell scripts and cron.

**The platform demonstrates core cloud concepts:**

- High availability
- Horizontal scaling
- Health-based recovery
- Load balancing
- Observability


**Architecture:**

Client
  ↓
Nginx (8080)
  ↓
Docker Network
  ↓
Flask App Containers (replicas)
  ↓
/health and /metrics
  ↓
Self-Heal & Auto-Scale Scripts
  ↓
Prometheus → Grafana



Technology Stack:
Component	-- Purpose
Vagrant	-- Virtualized Linux environment
Docker	-- Container runtime
Docker Compose	-- Service orchestration
Flask	-- Application backend
Nginx	-- Reverse proxy and load balancer
Prometheus	-- Metrics collection
Grafana	-- Metrics visualization
Cron	-- Task scheduling
ApacheBench	-- Load testing

**Project Structure:**

self-healing-server/
├── docker-compose.yml
├── app/
│   ├── app.py
│   ├── Dockerfile
│   ├── requirements.txt
│   └── .dockerignore
├── config/
│   └── nginx/
│       └── nginx.conf
└── scripts/
    ├── selfheal.sh
    └── autoscale.sh

**Setup:**

Start the virtual machine:
vagrant up
vagrant ssh

Start all services:
cd ~/server
docker compose up -d --build

**Access:**

Service	URL:
Application	http://localhost:8080

Health Check	http://localhost:8080/health

Prometheus	http://localhost:9090

Grafana	http://localhost:3000


**Self-Healing**

The application exposes a /health endpoint.
Docker monitors this endpoint and marks containers unhealthy when it fails.

The selfheal.sh script runs every minute via cron and:
- Restarts unhealthy containers
- Recreates the application if no instance is running

Enable automation:

crontab -e


Add:

* * * * * /usr/bin/bash /home/vagrant/server/scripts/selfheal.sh >> /tmp/selfheal.log 2>&1

**Auto-Scaling:**

The autoscale.sh script monitors container CPU usage:

- If CPU > 60% → a new replica is created

- If CPU < 5% → an idle replica is removed

Nginx is restarted to refresh the load-balancing pool

**Run manually:**

scripts/autoscale.sh

**Load Testing:**

sudo apt install -y apache2-utils
ab -n 10000 -c 80 http://localhost:8080/


This simulates concurrent users and triggers autoscaling.

**Monitoring:**

Prometheus scrapes metrics from each container.
Grafana visualizes:
- Request rate
- CPU usage
- Scaling behavior

**Key Capabilities:**

Feature	Status:

Self-healing	-- Implemented
Auto-scaling	-- Implemented
Load balancing	-- Implemented
Monitoring	-- Implemented
Automation	-- Implemented

**Conclusion:**

This project demonstrates a cloud-style, resilient application platform using containerized microservices and automation.
It models the behavior of real-world systems such as Kubernetes and AWS Auto Scaling within a lightweight Vagrant environment.
