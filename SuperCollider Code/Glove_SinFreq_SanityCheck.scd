/*******************
Initial sanity check for glove.
5 synths have their individual frequencies controlled by
each finger of the glove (AnalogIn(0-5)).
-Shane Wirkes 2022


architecture based on Pattern control
(c) 2017: Jonathan Reus, Marije Baalman, Giulio Moro, Andrew McPherson
*/

s = Server.default;

s.options.memSize = 8192 * 16; // the default is 8192 which is quite little

s.options.numAnalogInChannels = 8; // can only be 2, 4 or 8
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 0;
s.options.maxLogins = 4;  	   // set max number of clients
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server
s.options.headphoneLevel = -14; // sets the headphone level to -14 dB: it might get loud

s.options.blockSize = 128;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.waitForBoot{
	"Server Booted".postln;

	SynthDef('sin0', {arg freq=200;
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		sig = SinOsc.ar(freq, mul: 0.17);
		Out.ar(0, sig * env);
	}).send(s);

	SynthDef('sin1', {arg freq=200;
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		sig = SinOsc.ar(freq, mul: 0.17);
		Out.ar(0, sig * env);
	}).send(s);

	SynthDef('sin2', {arg freq=200;
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		sig = SinOsc.ar(freq, mul: 0.17);
		Out.ar(0, sig * env);
	}).send(s);

	SynthDef('sin3', {arg freq=200;
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		sig = SinOsc.ar(freq, mul: 0.17);
		Out.ar(0, sig * env);
	}).send(s);

	SynthDef('sin4', {arg freq=200;
		var sig, env;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		sig = SinOsc.ar(freq, mul: 0.17);
		Out.ar(0, sig * env);
	}).send(s);


	~ctrl = {
		var a0 = AnalogIn.ar(0);
		var a1 = AnalogIn.ar(1);
		var a2 = AnalogIn.ar(2);
		var a3 = AnalogIn.ar(3);
		var a4 = AnalogIn.ar(4);

		SendReply.kr(Impulse.kr(10), '/ctrl', [a0, a1, a2, a3, a4]);
	}.play;


	~freq0 = 200;
	~freq1 = 200;
	~freq2 = 200;
	~freq3 = 200;
	~freq4 = 200;

	OSCdef('fingers', {arg msg;
		~freq0 = msg[3].linlin(0.0, 1.0, 80, 8500);
		~freq1 = msg[4].linlin(0.0, 1.0, 80, 8500);
		~freq2 = msg[5].linlin(0.0, 1.0, 80, 8500);
		~freq3 = msg[6].linlin(0.0, 1.0, 8500, 80);
		~freq4 = msg[7].linlin(0.0, 1.0, 80, 8500);
		[~freq0, ~freq1, ~freq2, ~freq3, ~freq4].postln;
	}, '/ctrl');

	a = Pbind('finger0', 'sin0',
		'freq', Pfunc({~freq0}),
	).play;

	b = Pbind('finger1', 'sin1',
		'freq', Pfunc({~freq1}),
	).play;

	c = Pbind('finger2', 'sin2',
		'freq', Pfunc({~freq2}),
	).play;

	d = Pbind('finger3', 'sin3',
		'freq', Pfunc({~freq3}),
	).play;

	e = Pbind('finger4', 'sin4',
		'freq', Pfunc({~freq4}),
	).play;
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
