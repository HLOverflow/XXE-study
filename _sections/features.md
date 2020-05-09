---
title: Features
icon: fa-heart
order: 3
---

### Portability
The environment was build via docker containers which allows for easy set up, without having to worry about dependencies.

### Incorporated an attacker's file hosting server
With the incorporated attacker file server, one can interactively shell in to drop files for the vulnerable server to fetch.

### Simulated AWS Metadata Instance
Each App has been configured with an AWS Metadata Simulator that can be used to demonstrate the impact of Server-side Request Forgery (SSRF) via XXE.
If a cloud instance is vulnerable to XXE, credentials may be obtained.
