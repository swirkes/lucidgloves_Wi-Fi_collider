/*******************
Analog Input
Connect analog sources (e.g.: potentiometers, LDR, FSR) to analog input 0 and 1

AnalogIn returns a value from 0-1

.ar (analogPin: 0, mul: 1, add: 0)

analogPin:  Analog pin number to read. Pin numbers begin at 0. This value can be modulated at audiorate.

(c) 2017: Jonathan Reus, Marije Baalman, Giulio Moro, Andrew McPherson
*/

s = Server.default;

s.options.numAnalogInChannels = 8; // can only be 2, 4 or 8
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 0;
s.options.maxLogins = 4;  	   // set max number of clients
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

s.options.blockSize = 4096;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

~rel = AnalogIn.ar(4).exprange(0.1, 3);

s.waitForBoot{
	"Server Booted".postln;

	////////////////////////////////////////////////////////////////////
	(
	SynthDef(\fm, {
		var sig, mod, env;
		var freq = AnalogIn.ar(0).exprange(20, 5000);
		var modfreq = AnalogIn.ar(1).exprange(20, 5000);
		var modamp = AnalogIn.ar(2).exprange(20, 20000);
		var atk = AnalogIn.ar(3).exprange(0.001, 0.3);
		env = Env([0,1,0], [atk,~rel], [1,-1]).ar(2);
		mod = SinOsc.ar(modfreq, mul:modamp);
		sig = SinOsc.ar(freq + mod);
		sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.2));
		sig = sig * env;
		sig = FreeVerb.ar(sig);
		Out.ar(\out.ir(0), sig);
	}).send(s);
	);
	s.sync;
	(
	p = Routine({
		loop{
			Synth(\fm, target:s);
			0.25.wait;
		}
	}).play;
	);
	////////////////////////////////////////////////////////////////////

	//Synth.new("AnalogIn-test", target: s);
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed


SynthDef('pm', {arg freq=200, amp=0.5, pan=0, dur=1, modfreq=200, idx=0.1, modphase=0, trig=1;
		var sig, env;
		sig = PMOsc.ar(freq, modfreq, idx, SinOsc.ar(modfreq * 3));
		env = EnvGen.ar(Env.perc(0.01, 1), trig, timeScale: dur, doneAction: 2);
		Out.ar(0, Pan2.ar(sig * env * amp, pan));
	}).send(s);

Env.perc(
p = Pbind('instrument', 'pm',
		'freq', Pbinop('*', Pseq(Scale.dorian.ratios * [1, 2, 8], inf), Pfunc({~pitch})),
		'modfreq', Pfunc({~modfreq}),
		'amp', Pfunc({~amp}),
		'dur', Pfunc({~dur}),
		'idx', Pfunc({~idx}),
		'pan', Pseq([-0.3, 0.3],inf),
	).play;





SynthDef('indexFingerSynth', {arg freq=200, mod_freq=400, mod_amp=0.33;
		var sig, env, mod;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		mod = SinOsc.ar(mod_freq, mul: mod_amp);
		sig = SinOsc.ar(freq + mod, mul: 0.33);
		Out.ar(0, sig * env);
	}).send(s);

~indexFingerPattern = Pbind('instrument', 'indexFingerSynth',
		'freq', Pbinop('*', Pseq(Scale.dorian.ratios * [1, 3, 6, 3, 6, 3, 1], inf),200),
		'mod_freq', 400,
	).play;

	