/*******************
Demo for Composing with New Musical Instruments
Shane Wirkes
Aalto University 2022

Index, middle, and ring fingers are each assigned a synth which
is sent to a Pattern playing an arpeggio. The speed of the individual
arpeggios is controlled by the potentiometer on each of the three
fingers (AnalogIn(1-3)).

A global ~modulationFrequency is controlled by the thumb and connected
to all three synths. A global ~reverbAmt is controlled by the pinky.

The reverb is set up on a bus which all three synths are sent to before
the audio output.

architecture based on Pattern control
(c) 2017: Jonathan Reus, Marije Baalman, Giulio Moro, Andrew McPherson
*/

//TODO: CHANGE PINKY TO CONTROL PITCH INSTEAD OF REVERB

s = Server.default;

s.options.memSize = 8192 * 16; // the default is 8192 which is quite little

s.options.numAnalogInChannels = 8; // can only be 2, 4 or 8
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 2;
s.options.maxLogins = 4;  	   // set max number of clients
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server
s.options.headphoneLevel = -14; // sets the headphone level to -14 dB: it might get loud

s.options.blockSize = 512;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.waitForBoot{
	"Server Booted".postln;


	~thumb_pitch = 0.33;
	~index_finger_dur = 1;
	~mid_finger_dur = 1;
	~ring_finger_dur = 1;
	~pinky_mod_freq = 400;


	SynthDef('indexFingerSynth', {arg freq=200/7, rand_freq=54321, dur=1, mod_freq=400, rand_mod_freq=5413, mod_amp=300;
		var sig, env, mod;
		env = EnvGen.ar(Env.linen(0.1, 0.2, 0.1, 0.6), 1, timeScale: dur, doneAction: 2);
		mod = SinOsc.ar((mod_freq + rand_mod_freq) - 15000, mul: mod_amp);
		sig = SinOsc.ar((freq + rand_freq + mod) - 4000, mul: 0.33);
		Out.ar(0, Clip.ar((sig * env), 0.0, 0.33));
	}).send(s);

	SynthDef('midFingerSynth', {arg freq=400/3, rand_freq=12345, mod_freq=200, rand_mod_freq=2353, mod_amp=300;
		var sig, env, mod;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		mod = SinOsc.ar((mod_freq + rand_mod_freq) - 105000, mul: mod_amp);
		sig = SinOsc.ar((freq + rand_freq + mod) - 8000, mul: 0.33);
		Out.ar(0, Clip.ar((sig * env), 0.0, 0.33));
	}).send(s);

	SynthDef('ringFingerSynth', {arg freq=800/5, rand_freq=31245, mod_freq=200, rand_mod_freq=42315, mod_amp=300;
		var sig, env, mod;
		env = EnvGen.ar(Env.perc(0.01, 1), 1, doneAction: 2);
		mod = SinOsc.ar((mod_freq + rand_freq) - 55000, mul: mod_amp);
		sig = SinOsc.ar((freq + rand_freq + mod_freq) - 12000, mul: 0.33);
		Out.ar(0, Clip.ar((sig * env), 0.0, 0.33));
	}).send(s);





	~ctrl = {
		var thumb = AnalogIn.ar(0);
		var index_finger = AnalogIn.ar(1);
		var mid_finger = AnalogIn.ar(2);
		var ring_finger = AnalogIn.ar(3);
		var pinky_finger = AnalogIn.ar(4);

		SendReply.kr(Impulse.kr(10), '/ctrl',
			[thumb, index_finger, mid_finger,
				ring_finger, pinky_finger]);
	}.play;



	OSCdef('fingers', {arg msg;
		~thumb_pitch = msg[3].linlin(0.0, 1.0, 80, 800);
		~index_finger_dur = msg[4].linexp(0.0, 1.0, 1.0, 0.01);
		~mid_finger_dur = msg[5].linexp(0.0, 1.0, 1.0, 0.01);
		~ring_finger_dur = msg[6].linexp(0.0, 1.0, 1.0, 0.01);
		~pinky_mod_freq = msg[7].linlin(0.0, 1.0, 20, 20000);
		//[~thumb_pitch, ~index_finger_dur, ~mid_finger_dur,
		//		~ring_finger_dur, ~pinky_finger_dur].postln;
	}, '/ctrl');


	~indexFingerPattern = Pbind('instrument', 'indexFingerSynth',
		'freq', Pbinop('*', Pseq(Scale.locrian.ratios * [1, 3, 6, 3, 6, 3, 1], inf), Pfunc({~thumb_pitch})),
		'rand_freq', exprand(20, 20000),
		'mod_freq', Pfunc({~pinky_mod_freq}),
		'mod_amp', exprand(1, 20000),
		'rand_mod_freq', exprand(20, 20000),
		'dur', Pfunc({~index_finger_dur}),
	).play;

	~midFingerPattern = Pbind('instrument', 'midFingerSynth',
		'freq', Pbinop('*', Pseq(Scale.locrian.ratios * [5, 7, 5, 4, 3, 2, 1], inf), Pfunc({~thumb_pitch})),
		'rand_freq', exprand(20, 20000),
		'mod_freq', Pfunc({~pinky_mod_freq}),
		'rand_mod_freq', exprand(20, 20000),
		'mod_amp', exprand(1, 20000),
		'dur', Pfunc({~mid_finger_dur}),
	).play;

	~ringFingerPattern = Pbind('instrument', 'ringFingerSynth',
		'freq', Pbinop('*', Pseq(Scale.locrian.ratios * [3, 2, 1, 6, 7, 6, 3], inf), Pfunc({~thumb_pitch})),
		'rand_freq', exprand(20, 20000),
		'mod_freq', Pfunc({~pinky_mod_freq}),
		'rand_mod_freq', exprand(20, 20000),
		'mod_amp', exprand(1, 20000),
		'dur', Pfunc({~ring_finger_dur}),
	).play;

};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
