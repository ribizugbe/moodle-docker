# Moodle CBT Platform on Windows Laptop using Docker

**Author:** Raphael Ibizugbe

**Purpose**

This document records the steps taken to deploy Moodle on a Windows laptop using Docker Desktop and WSL2. It also contains recommendations for expanding the system into a production CBT platform integrated with Asterisk, playSMS and ERPNext.

---

# System Architecture

```
                    Internet
                        |
                 Router / Firewall
                        |
                 Windows Laptop
                        |
                 Docker Desktop
                        |
         +--------------+---------------+
         |                              |
      Moodle                        phpMyAdmin
         |                              |
         +--------------+---------------+
                        |
                     MariaDB
                        |
                      (Future)
                        |
                      Redis
                        |
              Asterisk / playSMS
                        |
                     ERPNext
```

---

# Software Used

- Windows 11
- WSL2 (Ubuntu)
- Docker Desktop
- Docker Compose
- MariaDB 11.8
- Moodle
- phpMyAdmin

---

# Critical Download & Installation Steps

- wget https://download.moodle.org/download.php/direct/stable405/moodle-latest-405.tgz
- tar xzf moodle-latest-405.tgz
- mv moodle/* ./moodle/
- docker compose up -d

---

# Access

- Moodle: 	http://localhost:8080
- phpMyAdmin: 	http://localhost:8081

---

# Verify Docker

```
docker version

docker compose version

docker ps
```

---

# Project Directory

```
moodle-platform/
│
├── compose.yaml
├── .env
├── moodle/
├── moodledata/
├── mariadb/
└── redis/
```

---

# compose.yaml

Services used

- Moodle
- MariaDB
- phpMyAdmin

Future additions

- Redis
- Nginx Proxy Manager
- SMTP
- Cron

---

# Starting Containers

```
docker compose pull

docker compose up -d
```

---

# Check Containers

```
docker ps
```

Expected

```
moodle

moodle-db
```

---

# Logs

```
docker compose logs -f

docker logs moodle

docker logs moodle-db
```

---

# Enter Container

```
docker exec -it moodle bash
```

or

```
docker exec -it moodle-db bash
```

---

# Moodle URL

```
http://localhost:8080
```

---

# phpMyAdmin

```
http://localhost:8081
```

---

# Common Docker Commands

Start

```
docker compose up -d
```

Stop

```
docker compose down
```

Restart

```
docker compose restart
```

Restart one service

```
docker compose restart moodle
```

List running containers

```
docker ps
```

List all containers

```
docker ps -a
```

---

# Useful Troubleshooting Notes

## Docker daemon not running

Symptom

```
Cannot connect to the Docker daemon
```

Resolution

Start Docker Desktop.

Wait until it reports

```
Engine Running
```

---

## Docker Compose disappeared

Symptom

```
docker compose

unknown command
```

Cause

Docker Desktop had entered Resource Saver mode.

Resolution

Restart Docker Desktop.

---

## Input/output error

Example

```
/usr/bin/docker-compose

Input/output error
```

Cause

Docker Desktop lost its WSL integration.

Restart Docker Desktop.

---

## MariaDB image not found

Old image

```
bitnami/mariadb
```

Solution

Use

```
mariadb:11.8
```

---

## Moodle image

We initially attempted

```
moodlehq/moodle-php-apache
```

Although it starts correctly, it is intended primarily as a development image.

The document root

```
/var/www/html
```

was empty.

This resulted in

```
403 Forbidden
```

---

# Verifying Apache

```
docker exec -it moodle bash
```

Then

```
ls -la /var/www/html

apache2ctl -S
```

---

# Hosting Exams

For a small number of candidates, running Moodle from the laptop is acceptable.

Requirements

- Laptop powered on
- Docker running
- Router port forwarding
- Reliable Internet
- Good UPS

---

# Port Forwarding

Router

```
External Port

8080

↓

Laptop

8080
```

Public URL

```
http://YOUR_PUBLIC_IP:8080
```

Better

```
https://cbt.yourdomain.com
```

using

- Nginx Proxy Manager
- Let's Encrypt

---

# Moodle Administration

Create

- Categories
- Courses
- Users
- Quizzes

Question import

Supported

- GIFT
- Aiken
- XML

---

# GIFT

Example

```
Nigeria is in Africa.{TRUE}

2+2=4.{TRUE}

2+2=5.{FALSE}
```

---

# Aiken

Example

```
What is 2+2?

A. 3
B. 4
C. 5
D. 6

ANSWER: B
```

---

# Future Improvements

## Infrastructure

- Redis
- Nginx Proxy Manager
- HTTPS
- SMTP
- Cron
- Automatic backups

---

## Integrations

### Asterisk

Candidate reminders

Voice notifications

PIN verification

IVR access

---

### playSMS

Exam reminders

OTP

Result notification

Bulk messaging

---

### ERPNext

Employee training

Certification

Learning records

Attendance

Reporting

---

# Long-term Architecture

```
Internet
      |
Nginx Proxy Manager
      |
Moodle
      |
MariaDB
      |
Redis
      |
ERPNext
      |
Asterisk
      |
playSMS
```

---

# Backup Strategy

Daily

```
mysqldump
```

Weekly

Backup

- compose.yaml
- .env
- moodle/
- moodledata/
- mariadb/

---

# Migration to VPS

Because Docker Compose is being used, migration is straightforward.

Copy

```
compose.yaml

.env

moodle/

moodledata/

mariadb/
```

to the Ubuntu server.

Run

```
docker compose up -d
```

---

# Useful Commands

Restart everything

```
docker compose restart
```

Shutdown

```
docker compose down
```

View logs

```
docker compose logs -f
```

List containers

```
docker ps
```

Open Moodle container

```
docker exec -it moodle bash
```

Open MariaDB container

```
docker exec -it moodle-db bash
```

---

# Planned Enhancements

- Moodle production deployment
- Redis cache
- HTTPS
- Automatic backups
- SMTP
- ERPNext integration
- playSMS integration
- Asterisk IVR integration
- CBT automation
- Candidate self-registration
- SMS invitations
- SMS result notifications
- Voice reminders


# Later Additions

Once Moodle is running, I'd add:

Redis session cache
Moodle Cron container
SMTP (Amazon SES / SendGrid)
HTTPS via Nginx Proxy Manager
Automatic backups
Monitoring (Prometheus/Grafana or your preferred PHP dashboard)
S3-compatible storage (optional)
Integration with Your Existing Systems

This is where I think your platform becomes particularly powerful. Because you're already working with:

Asterisk
playSMS
ERPNext
PHP APIs
MySQL/MariaDB

you can integrate Moodle rather than treating it as a standalone LMS. For example:

Candidate
    │
    ▼
Asterisk IVR
    │
    ▼
PHP API
    │
    ▼
Moodle Web Services
    │
    ▼
Question Bank
    │
    ▼
Assessment Engine
    │
    ▼
Results
    │
    ├── ERPNext
    ├── SMS (playSMS)
    ├── Email
    └── Certificates

This would let candidates:

Receive exam invitations by SMS.
Confirm attendance or receive reminders via IVR.
Take CBT assessments in Moodle.
Receive results by SMS and email.
Have results synchronized into ERPNext for reporting or HR workflows.
One improvement I'd make

Rather than downloading the Moodle source manually as shown above, I would create a custom Docker image that:

Downloads the correct Moodle release automatically during the build.
Installs all required PHP extensions.
Enables Apache modules (rewrite, etc.).
Configures Redis and MariaDB connectivity.
Sets sensible PHP limits (memory_limit, upload_max_filesize, max_execution_time).
Is version-controlled alongside your compose.yaml.

That gives you a fully reproducible deployment. When you later move from your laptop to an Ubuntu VPS, you simply copy the project and run:

docker compose up -d

and the same environment comes up without any manual setup. Given your long-term plans, I think that's the most maintainable approach.


The document I intend to include will cover, in detail:

System Overview
Overall architecture
Component descriptions
Network diagram
Prerequisites
Windows
WSL2
Docker Desktop
Docker Compose
Verification commands
Project Structure
Directory layout
Purpose of each folder
Docker Compose
Complete compose.yaml
.env
Explanation of every service
Installation Procedure
Pulling images
Starting containers
Verifying containers
First login
Database
MariaDB
phpMyAdmin
Backup and restore
Running Moodle
Creating courses
Creating quizzes
Importing GIFT questions
Importing Aiken questions
Scheduling examinations
Hosting Exams from Your Laptop
Port forwarding
Dynamic DNS
HTTPS
Firewall rules
Performance recommendations
Docker Administration
Useful commands
Restarting services
Viewing logs
Entering containers
Troubleshooting
Docker daemon issues
Docker Desktop Resource Saver
WSL integration
Missing Docker Compose
Image errors
Apache 403 errors
Empty document root
Common Moodle startup problems
Future Production Architecture
Nginx Proxy Manager
Redis
Automatic backups
SMTP
Monitoring
Migration to Ubuntu VPS
Future Integrations
Asterisk IVR
playSMS
ERPNext
Web Services
SMS Notifications
CBT Workflow
Appendix
Frequently used Docker commands
Frequently used Moodle administration commands
Useful URLs
Recommended directory structure

I also want to improve it beyond a simple transcript of our conversation.

Given everything we've worked on together over the past months, I'd like to turn it into a professional deployment manual (around 35–50 pages) with:

A proper table of contents
Diagrams
Screenshots/placeholders where appropriate
Best practices
Security recommendations
Backup strategy
Recovery procedures
Upgrade procedures
Maintenance checklist

====

Let's just add the missing PHP extensions.

Step 1

Enter the container:

docker exec -it moodle bash
Step 2

Update apt:

apt update
Step 3

Install the development libraries required to build the PHP extensions:

apt install -y \
    default-libmysqlclient-dev \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libpq-dev \
    zlib1g-dev

(If one package name has changed on Debian 13, we'll adjust it. That's normal.)

Step 4

Configure GD:

docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg
Step 5

Build the extensions:

docker-php-ext-install \
    mysqli \
    intl \
    gd \
    zip \
    soap \
    exif \
    opcache \
    xsl

This will take several minutes.

Step 6

Verify:

php -m | grep mysqli

You should now get:

mysqli

Then also verify:

php -m | grep intl
php -m | grep gd
php -m | grep zip
Why I'm recommending this

Earlier I suggested replacing the image, but now that I know you're using php:8.2-apache with a manually downloaded Moodle source, I actually think this is the better long-term architecture.

It gives you:

complete control over the Moodle version,
independence from third-party Moodle images,
easy upgrades by replacing the Moodle code,
a setup very similar to how many production Linux servers are built.
One improvement for later

Once we have Moodle installed successfully, I recommend creating a small Dockerfile that installs these extensions during the image build instead of manually inside the running container.

For example:

FROM php:8.2-apache
---
# Install required libraries
RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    libicu-dev \
    libzip-dev \
    ...

# Build PHP extensions
RUN docker-php-ext-install mysqli intl gd zip soap xsl exif
---

Then your docker-compose.yml would build this custom image automatically. If you ever recreate the containers, all the required extensions would already be present—no manual installation needed.

For now, though, let's get the installer past the database page by adding the missing extensions. Once that's done, we can continue the Moodle installation.
