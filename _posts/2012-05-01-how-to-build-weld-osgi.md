---
layout: post
title: "How to build Weld OSGi"
description: "This article explains how to build Weld-OSGi from sources"
category: 
tags: [Weld-OSGi OSGi Weld CDI]
---
{% include JB/setup %}

How to build Weld OSGi
----------------------

```
git clone https://github.com/alesj/api.git
git checkout -b osgi origin/osgi
cd api
mvn clean install


git clone https://github.com/alesj/core.git
git checkout -b osgi origin/osgi
cd core
mvn clean install
```

to build samples

```
cd core/environments/osgi/examples
mvn clean install
```

to run samples

```
cd core/environments/osgi
./run-felix.sh
```

important modules are in core module :

* api
* ee (for hybrid Java EE apps)
* extension
* integration
* mandatory
* spi





