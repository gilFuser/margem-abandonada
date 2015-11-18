// server options
(
Server.default = s = Server.local;
s.latency=nil;
s.options
.numAudioBusChannels_(512)	 // for proxy usage: lots of ar bus space
.memSize_(8192 * 64)		 // 512 MB memory for buffers, soundfiles!
.maxNodes_(1024 * 8)		 // lots of synth nodes
.numWireBufs_(64*4);			 // fat synthdefs need lots of interconnects
s
.recChannels_(2)	// record stereo out only
.scope(2);
s.meter
);

//booting the server and making a proxy space
(
s.waitForBoot({
	q = q ? ();
	q.fadeTime_(1);
})
);

// loading the buffers. Is in a task to give time to load between the other processes. You will need to drag and drop the folders with the samples here to get the correct path
(
Task({
    1.do({
        3.0.wait;
		q.bufs = IdentityDictionary
[
	'pngpong' -> PathName("/home/gil/SuperCollider/margem abandonada/astro/ghostPing").entries.collect({ |sframe| Buffer.read(s, sframe.fullPath)
	}),
	'leute' -> PathName("/home/gil/SuperCollider/margem abandonada/astro/leute").entries.collect({ |sframe| Buffer.read(s, sframe.fullPath)
	}),
	'natur' -> PathName("/home/gil/SuperCollider/margem abandonada/astro/natur").entries.collect({ |sframe| Buffer.read(s, sframe.fullPath)
	}),
	'verkehr' -> PathName("/home/gil/SuperCollider/margem abandonada/astro/verkehr").entries.collect({ |sframe| Buffer.read(s, sframe.fullPath)
	}),
	'zuhause' -> PathName("/home/gil/SuperCollider/margem abandonada/astro/zuhause").entries.collect({ |sframe| Buffer.read(s, sframe.fullPath)
	})
];
		0.5.wait;
    });
}).start
);

(
// load the instrument
"paisagensCamadas.scd".loadRelative;
);
