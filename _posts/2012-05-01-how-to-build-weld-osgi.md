---
layout: post
title: "How to build Weld OSGi"
description: "This article explains how to build Weld-OSGi from sources"
category: [Dev]
tags: [Weld-OSGi, OSGi, Weld, CDI]
---
{% include JB/setup %}

Maybe you already heard about Weld-OSGi before, lately I've done some presentations about it in Java User Groups and at some conferences like Devoxx France, JAX London or JUG Summer Camp. If you want to know more about it, you can check the slides out :

<script class="speakerdeck-embed" data-id="4f92ccc7cb4cd0001f01504b" data-ratio="1.6" src="//speakerdeck.com/assets/embed.js"> </script>

The only problem about Weld-OSGi is that we broke a public Weld API and because of that, the code of the project isn't merged into Weld core because of backward compatibility. But don't worry, it will be soon ;-)

In this post, I will explain how to build a version of Weld with Weld-OSGi inside. Then you will be able to do stuff like :


<iframe width="560" height="315" src="http://www.youtube.com/embed/R4MbRn46-AA" frameborder="0"> </iframe>


In a future post, I will explain how to integrate it inside JBoss AS7 to create hybrid Java EE/OSGi applications like demoed at DevoxxFR :


<iframe width="420" height="315" src="http://www.youtube.com/embed/zbgZp15Y-Eo" frameborder="0"> </iframe>


Let's get started
==================


In the following script samples, let's assume `${START}` is the place where you are going to work, where you are going to clone git repos.

<script src="https://gist.github.com/2569318.js?file=blog.sh"> </script>

And you're done, quite easy huh :-)

Let's play
==================

If you want to play with the Weld-OSGi samples you just have to build'em

<script src="https://gist.github.com/2569318.js?file=blog1.sh"> </script>

and run the OSGi container.

<script src="https://gist.github.com/2569318.js?file=blog2.sh"> </script>

Then you can list bundles installed with `ps` command and start them with `start/stop` command.

If you want to embed Weld-OSGi somewhere, important binaries are in core module :

* api

	* target

		* weld-osgi-core-api-1.2.0-SNAPSHOT.jar

* ee (for hybrid Java EE apps)

	* target

		* weld-osgi-ee-integration-1.2.0-SNAPSHOT.jar

* extension

	* target

		* weld-osgi-core-extension-1.2.0-SNAPSHOT.jar

* integration

	* target

		* weld-osgi-core-integration-1.2.0-SNAPSHOT.jar

* mandatory

	* target 

		* weld-osgi-core-mandatory-1.2.0-SNAPSHOT.jar

* spi

	* target

		* weld-osgi-core-spi-1.2.0-SNAPSHOT.jar

You can find how to use Weld-OSGi for pure OSGi application development in the 'examples' directory.
You can find how to use Weld-OSGi in an OSGi container in the samples, for instance inside a felix container :

-  core/environments/osgi/examples

	- container-felix

		- target

			- weld-osgi-container-felix-1.2.0-SNAPSHOT-all

				- weld-osgi-container-felix-1.2.0-SNAPSHOT


