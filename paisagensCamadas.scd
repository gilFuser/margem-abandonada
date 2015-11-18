(
SynthDef(\playBuf, { | pan=0,amp=1, buf=0, dur=1, start=1, loop=1, trig=1, gate=1, pitRat=1, pitDis=0, timeDis=0.1, janela = 0.2, zScratch=0.1, zDjay=0.2, zFinger=0.2, out=0 |
	var rate, env, sig, filtro;
	rate={LFNoise0.kr(zDjay+(zFinger*2),zScratch)};
	rate = LFNoise0.kr(zDjay, rate, 1).lag2(zFinger);
	env = EnvGen.kr(Env([0,1,1,0],[0.01,1,0.01],[-4,0,4],2,1), gate, doneAction:2);
	rate = rate*env;
	sig = PlayBuf.ar( 2, buf, BufRateScale.kr(buf)*rate, trig ,start, loop);
	sig = PitchShift.ar(sig, janela, pitRat.lag2(0.2), pitDis, timeDis);
	sig = CompanderD.ar(sig,0.5, 1.5, 0.24, 0.002, 0.02, 1.5);
	sig = sig * env;
	sig = Pan2.ar(sig, pan, amp);
	OffsetOut.ar(out, sig);
}).add;
);

//change pitch ratio________________________________________

d = Prand(#[[[2,-2],[3,-3]],[[-4,6],4,-7],-4,10,[0,8],[6,-8,[-2,4]],[10,0,4],-4,[4,-4,0,-6], 6,10,0,-2], inf).midiratio;

d = Prand(#[[0,-2],[3,-2],[-3,2],4,-7,0,5,[0,4],3,-4,[-2,4],[2.5,0],0,-4,[4,-4],[0,-6], -3,3.5,0,-2], inf).midiratio;

d = Prand([Pn(-8,3),Pn(-5,3),Pn(0,12),Pn(2,1)],inf).midiratio;

Pdefn(\degree, d);  // evaluate one of the above and then this

//  ________________________________________________________

(
Pdef(\pBuf,
	Pbind(
		\instrument, \playBuf,
		\buf,   Pfunc({|ev|
			q.bufs[
				[\leute, \zuhause, \pngpong, \natur, \verkehr].wchoose([ev.y_leute, ev.y_zuhause, ev.y_pngpong, ev.y_natur, ev.y_verkehr].normalizeSum)
			].choose
		}, inf),
		\start, Pfunc{thisThread.seconds * s.sampleRate},
		\pitRat, Pdefn(\degree),
		[\timeDis,\janela],
		Pxrand([
			Pn([0.01,0.3],4),
			Pn([0.5,0.1],4),
			Pn([0.5,0.25],4),
			Pn([0.05,0.2],4),
		],inf),
		\pan, Pwhite(-0.75, 0.75)
	);
);
);

//change tempo
t=Tempo.bpm_(120);

// set the variables meant to be controlled trough PdefGui
(
Pdef(\pBuf).set(
	\amp, 0.1,
	\dur, 1,
	\legato, 1,
	\y_leute, 1,
	\y_zuhause, 1,
	\y_pngpong, 1,
	\y_natur, 1,
	\y_verkehr, 1,
	\zDjay, 2,
	\zFinger, 0.05,
	\zScratch, 1
)
);

Spec.add(\legato, [1/8, 16, \exp, 0.02, 1]);
Spec.add(\dur, [0.16, 16, \exp, 0.02, 1]);
Spec.add(\y_leute, [0, 100, 1]);
Spec.add(\y_zuhause, [0, 100, 1]);
Spec.add(\y_pngpong, [0, 100, 1]);
Spec.add(\y_natur, [0, 100, 1]);
Spec.add(\y_verkehr, [0, 100, 1]);
Spec.add(\zDjay, [0.2, 120, \exp, 0.2, 2]);
Spec.add(\zFinger, [0.05, 1.0, \exp, 0.01, 0.01]);
Spec.add(\zScratch, [0.2, 20, \exp, 0.1, 1]);

y = PdefGui(Pdef(\pBuf), 16);


// how to change Tempo dynamically?
// Control trough a gui witch of each buffer categories should be played. As in EZRanger in ParamGui. Maybe changing from PdefGui to that.
