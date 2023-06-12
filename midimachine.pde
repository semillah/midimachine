import javax.sound.midi.*;

void setup() {
  size(400, 400);
  generateMidiFile("path to your folder");
}

void generateMidiFile(String fileName) {
  try {
    // Create a new MIDI sequence
    Sequence sequence = new Sequence(Sequence.PPQ, 24);

    // Create a new track
    Track track = sequence.createTrack();

    // Set the tempo (120 beats per minute)
    int bpm = 120;
    int tempo = 60000000 / bpm;
    MetaMessage metaMessage = new MetaMessage();
    byte[] data = { (byte) (tempo >> 16), (byte) (tempo >> 8), (byte) tempo };
    metaMessage.setMessage(0x51, data, 3);
    track.add(new MidiEvent(metaMessage, 0));

    // Generate MIDI notes
    int channel = 0;
    int velocity = 100;
    int duration = 96; // In ticks

    for (int i = 0; i < 16; i++) {
      int pitch = 60 + i; // Starting from C4
      int tick = i * duration;
      ShortMessage noteOn = new ShortMessage();
      noteOn.setMessage(ShortMessage.NOTE_ON, channel, pitch, velocity);
      track.add(new MidiEvent(noteOn, tick));
      ShortMessage noteOff = new ShortMessage();
      noteOff.setMessage(ShortMessage.NOTE_OFF, channel, pitch, velocity);
      track.add(new MidiEvent(noteOff, tick + duration));
    }

    // Save the MIDI sequence to a file
    File midiFile = new File(fileName);
    MidiSystem.write(sequence, 1, midiFile);

    println("MIDI file generated: " + midiFile.getAbsolutePath());
  } catch (Exception e) {
    e.printStackTrace();
  }
}
