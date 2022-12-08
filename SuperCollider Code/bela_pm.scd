/*******************
Pattern control
Connect analog sources (e.g.: potentiometers, LDR, FSR) to analog input 0 and 1

AnalogIn returns a value from 0-1

.ar (analogPin: 0, mul: 1, add: 0)

analogPin:  Analog pin number to read. Pin numbers begin at 0. This value can be modulated at audiorate.

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

	SynthDef('pm', {arg freq=200, amp=0.5, pan=0, dur=1, modfreq=200, idx=0.1, modphase=0, trig=1;
		var sig, env;
		sig = PMOsc.ar(freq, modfreq, idx, SinOsc.ar(modfreq * 3));
		env = EnvGen.ar(Env.perc(0.01, 1), trig, timeScale: dur, doneAction: 2);
		Out.ar(0, Pan2.ar(sig * env * amp, pan));
	}).send(s);


	~ctrl = {
		var a0 = AnalogIn.ar(0) * 0.5;
		var a1 = AnalogIn.ar(1) * 0.5;
		var a2 = AnalogIn.ar(2) * 0.5;
		var a3 = AnalogIn.ar(3);
		var a4 = AnalogIn.ar(4);

		SendReply.kr(Impulse.kr(10), '/ctrl', [a0, a1, a2, a3, a4]);
	}.play;

	~dur = 0.2;
	~amp = 0.8;
	~pitch = 300;
	~modfreq = 300;
	~idx = 5;
	OSCdef('listen', {arg msg;
		~amp = msg[3].linexp(0.0, 1.0, 0.1, 0.8);
		~dur = msg[4].linexp(0.1, 1.0, 1.0, 0.01);
		~pitch = msg[5].linlin(0.0, 1.0, 80, 800);
		~modfreq = msg[6].linlin(0.0, 1.0, 300, 9000);
		~idx = msg[7].linlin(0.0, 1.0, 0, 20);
		//[~modfreq, ~idx].postln;
	}, '/ctrl');


	p = Pbind('instrument', 'pm',
		'freq', Pbinop('*', Pseq(Scale.dorian.ratios * [1, 2, 8], inf), Pfunc({~pitch})),
		'modfreq', Pfunc({~modfreq}),
		'amp', Pfunc({~amp}),
		'dur', Pfunc({~dur}),
		'idx', Pfunc({~idx}),
		'pan', Pseq([-0.3, 0.3],inf),
	).play;
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
FMOsc

fingers 