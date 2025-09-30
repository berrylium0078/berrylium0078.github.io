---
layout: draft
title: Some Tips Collection for Arch Linux
date: 2025-07-26 17:12:56
tags:
---

### Remove spam log info from acpid

```plaintext /etc/acpi/events/buttons
event=button/.*
action=<drop>
```
