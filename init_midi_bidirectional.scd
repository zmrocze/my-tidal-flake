SuperDirt.start;

// Evaluate the block below to start the mapping MIDI -> OSC.
// (
var on, off, cc;
var osc;

osc = NetAddr.new("127.0.0.1", 6010);

MIDIClient.init;
MIDIIn.connectAll;

on = MIDIFunc.noteOn({ |val, num, chan, src|
  osc.sendMsg("/ctrl", "n" ++ num.asString, val/127);
});

// Check out
// oLatency = 0.2,         -- Additional delay, to smooth out network jitter/get things in sync
// in boottidal if things not sharp

off = MIDIFunc.noteOff({ |val, num, chan, src|
    osc.sendMsg("/ctrl", "n" ++ num.asString, 0);
});

cc = MIDIFunc.cc({ |val, num, chan, src|
    osc.sendMsg("/ctrl", num.asString, val/127);
});

if (~stopMidiToOsc != nil, {
    ~stopMidiToOsc.value;
});

~stopMidiToOsc = {
    on.free;
    off.free;
    cc.free;
};

~midiOut = MIDIOut.newByName("MiniFreak", "MiniFreak MiniFreak MIDI"); // substitute your own device here
~dirt.soundLibrary.addMIDI(\minifreak, ~midiOut);


// );

// Evaluate the line below to stop it.
// ~stopMidiToOsc.value;